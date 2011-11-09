function [Y SR NBITS OPTS] = m4aread(FILE,N,MONO,DOWNSAMP,DELAY)
% M4AREAD   Read mpeg 4 audio (AAC) file via use of external binaries.
%   Y = M4AREAD(FILE) reads an m4a-encoded audio file into the
%     vector Y just like wavread reads a wav-encoded file (one channel 
%     per column).  Extension ".m4a" is added if FILE has none.
%     Also accepts other formats of wavread, such as
%   Y = M4AREAD(FILE,N) to read just the first N sample frames (N
%     scalar), or the frames from N(1) to N(2) if N is a two-element vector.  
%   Y = M4AREAD(FILE,FMT) or Y = m4aread(FILE,N,FMT) 
%     with FMT as 'native' returns int16 samples instead of doubles; 
%     FMT can be 'double' for default behavior (to exactly mirror the
%     syntax of wavread).
%
%   [Y,FS,NBITS,OPTS] = M4AREAD(FILE...) returns extra information:
%     FS is the sampling rate,  NBITS is the bit depth (always 16), 
%     OPTS.fmt is a format info string; OPTS has multiple other
%     fields, see WAVREAD.
%
%   SIZ = M4AREAD(FILE,'size') returns the size of the audio data contained
%     in the file in place of the actual audio data, returning the
%     2-element vector SIZ=[samples channels].
%
%   [Y...] = M4AREAD(FILE,N,MONO,DOWNSAMP) extends the
%     WAVREAD syntax to emulate special features of the
%     mpg123 engine:  MONO = 1 forces output to be mono (by
%     averaging stereo channels); DOWNSAMP = 2 or 4 downsamples by 
%     a factor of 2 or 4 (thus FS returns as 22050 or 11025
%     respectively for a 44 kHz m4a file).  (A final DELAY argument
%     is also supported for full compatibility with mp3read, but
%     has no use).  In this case, N is interpreted in terms of the 
%     post-downsampling samples
%
%   Example:
%   To read an m4a file as doubles at its original width and sampling rate:
%     [Y,FS] = m4aread('piano.m4a');
%   To read the first 1 second of the same file, downsampled by a
%   factor of 4, cast to mono, using the default filename
%   extension:
%     [Y,FS4] = m4aread('piano', FS/4, 1, 4);
%
%   Note: requires external binary faad
%     http://labrosa.ee.columbia.edu/matlab/mp3read.html
%
%   See also wavread.
% $Header: /Users/dpwe/matlab/columbiafns/m4aread/RCS/m4aread.m,v 1.1 2010/09/17 16:07:46 dpwe Exp dpwe $
% 2009-10-14 m4aread created from mp3read
% Copyright (c) 2010, Dan Ellis
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.




% find our baseline directory
%path = fileparts(which('m4aread'));

if ispc() 
    path = fileparts(which('m4aread')) ;
    ext = 'exe';
    faad = fullfile(path,['faad.',ext]);
elseif isunix()
    path = locate_unix_cmd( 'faad' ) ;
    faad = path ;
elseif ismac()
   fooo = 1 ;
end

% %%%%% Directory for temporary file (if needed)
% % Try to read from environment, or use /tmp if it exists, or use CWD
tmpdir = getenv('TMPDIR');
if isempty(tmpdir) || exist(tmpdir,'file')==0
  tmpdir = '/tmp';
end
if exist(tmpdir,'file')==0
  tmpdir = '';
end
% ensure it exists
%if length(tmpdir) > 0 && exist(tmpdir,'file')==0
%  mkdir(tmpdir);
%end

%%%%%% Command to delete temporary file (if needed)
rmcmd = 'rm';

%%%%%% Location of the binaries - attempt to choose automatically
%%%%%% (or edit to be hard-coded for your installation)
% ext = lower(computer);
% if ispc
%   
%   rmcmd = 'del';
% end

%faad = '/opt/local/bin/faad';

%%%%% Process input arguments
if nargin < 2
  N = 0;
end

% Check for FMT spec (per wavread)
FMT = 'double';
if ischar(N)
  FMT = lower(N);
  N = 0;
end

if length(N) == 0
  N = [1 0];
elseif length(N) == 1
  % Specified N was upper limit
  N = [1 N];
end
if nargin < 3
  forcemono = 0;
else
  % Check for 3rd arg as FMT
  if ischar(MONO)
    FMT = lower(MONO);
    MONO = 0;
  end
  forcemono = (MONO ~= 0);
end
if nargin < 4
  downsamp = 1;
else
  downsamp = DOWNSAMP;
end
if downsamp ~= 1 && downsamp ~= 2 && downsamp ~= 4
  error('DOWNSAMP can only be 1, 2, or 4');
end

% process DELAY option (nargin 5) after we've read the SR

if strcmp(FMT,'native') == 0 && strcmp(FMT,'double') == 0 && ...
      strcmp(FMT,'size') == 0
  error(['FMT must be ''native'' or ''double'' (or ''size''), not ''',FMT,'''']);
end


%%%%%% Constants
NBITS=16;

%%%%% add extension if none (like wavread)
[path,file,ext] = fileparts(FILE);
if isempty(ext)
  FILE = [FILE, '.m4a'];
end

  %%%%%% Probe file to find format, size, etc. 
  cmd = ['"',faad, '" -i "', FILE,'"'];
  [s,w] = system(cmd);
  % Break into lines
  rp =  [0,find(w==10)];
  for i =1:length(rp)-1; 
    ll{i} = w(rp(i)+1:rp(i+1)-1);
  end
  % Find the line that ends "file info:"
  r = strfind(ll,'file info');
  for i = 1:length(r); 
    if length(r{i}) ==0; 
      rr(i) = 0; 
    else 
      rr(i) = r{i}; 
    end
  end
  fil = find(rr);
  if length(fil) ~= 1
    display(['m4aread: Unexpected result from "',cmd,'": ',w]);
    %error('unexpected result');
    Y = [];
    SR = 0;
    return;
  end

  % line after gives info e.g.
  % LC AAC	318.870 secs, 2 ch, 44100 Hz
  % or 
  % ADTS, 100.008 sec, 128 kbps, 44100 Hz
  infoline = '';
  while length(infoline) == 0
    fil = fil +1;
    infoline = ll{fil};
  end
  infoline(infoline == 9) = ' ';
  strs = tokenize(infoline);

  % defaults
  SR = 44100; dur = 0; nchans = 2;
  
  % try to find stuff
  ps = strmatch('Hz', strs);
  if length(ps) > 0
    SR = str2num(strs{ps(1)-1});
  else
    disp(['Warn: using default SR = ',num2str(SR)]);
  end
  ps = strmatch('sec',strs);  % will match 'sec' or 'secs'
  if length(ps) > 0
    dur = str2num(strs{ps(1)-1});
  else
    disp(['Warn: no duration found, using ', num2str(dur)]);
  end
  ps = strmatch('ch',strs);  % will match 'ch,'
  if length(ps) > 0
    nchans = str2num(strs{ps(1)-1});
  else
    disp(['Warn: no channel count found, using ', num2str(nchans)]);
  end
  
  nframes = round(SR*dur); % well, approximately
  smpsperfrm = nchans;

  % fields from wavread's OPTS
  OPTS.fmt.nAvgBytesPerSec = 0; % bitrate/8;
  OPTS.fmt.nSamplesPerSec = SR;
  OPTS.fmt.nChannels = nchans;
  OPTS.fmt.nBlockAlign = 0; %smpspfrm/SR*bitrate/8;
  OPTS.fmt.nBitsPerSample = NBITS;
  OPTS.fmt.mpgLayer = strs{1}; % [strs{1},' ',strs{2}];
  
% process or set delay
if nargin < 5
  delay = 0;
else
  delay = DELAY;
end

% Size-reading version
if strcmp(FMT,'size') == 1
   Y = [floor(nframes/downsamp), nchans];
else

  % Temporary file to use
  %tmpfile = fullfile(tmpdir, ['tmp',num2str(round(1000*rand(1))),'.wav']);
  [s,upid] = system('echo $$');
  % remove final CR
  upid = upid(1:end-1);
  tmpfile = fullfile(tmpdir, ['m4atmp',upid,'.wav']);

  sttfrm = max(0,N(1)-1);

  lenstr = '';
  endfrm = -1;
  decblk = 0;
  if length(N) > 1
    endfrm = N(2);
  end

  % Run the decode
  cmd=['"',faad,'" -o "', tmpfile,'"  "',FILE,'"'];
  %w = 
  mysystem(cmd);

  sttfrm = sttfrm + delay;
  endfrm = endfrm + delay;

  if endfrm > sttfrm
    % don't load more data than we want
    [Y,SR] = wavread_downsamp(tmpfile, [sttfrm+1 endfrm], forcemono, downsamp);
  else
    % Load all the data
    [Y,SR] = wavread_downsamp(tmpfile, [sttfrm+1 Inf], forcemono, downsamp);
  end

%  % pad delay on to end, just in case
%  Y = [Y; zeros(delay,size(Y,2))];
%  % no, the saved file is just longer
  
  % Delete tmp file
  mysystem([rmcmd,' "', tmpfile,'"']);
  
  % debug
%  disp(['sttfrm=',num2str(sttfrm),' endfrm=',num2str(endfrm),' delay=',num2str(delay),' len=',num2str(length(Y))]);

  % Convert to int if format = 'native'
  if strcmp(FMT,'native')
    Y = int16((2^15)*Y);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function w = mysystem(cmd)
% Run system command; report error; strip all but last line
[s,w] = system(cmd);
if s ~= 0 
  error(['unable to execute ',cmd,' (',w,')']);
end
% Keep just final line
w = w((1+max([0,findstr(w,10)])):end);
% Debug
%disp([cmd,' -> ','*',w,'*']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = tokenize(s,t)
% Break space-separated string into cell array of strings.
% Optional second arg gives alternate separator (default ' ')
% 2004-09-18 dpwe@ee.columbia.edu
if nargin < 2;  t = ' '; end
a = [];
p = 1;
n = 1;
l = length(s);
nss = findstr([s(p:end),t],t);
for ns = nss
  % Skip initial spaces (separators)
  if ns == p
    p = p+1;
  else
    if p <= l
      a{n} = s(p:(ns-1));
      n = n+1;
      p = ns+1;
    end
  end
end
    
