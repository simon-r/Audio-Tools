function [Y,FS,NBITS,tag_info] = flacread2(FILE,varargin)
%    Y = flacread(FILE) reads a FLAC file specified by the string FILE,
%    returning the sampled data in Y. Amplitude values are in the range [-1,+1].
% 
%    [Y,FS,NBITS,tag_info] = FLACREAD2(FILE,[n1,n2],'fmt') 
%    fmt can be native or double (default)
%
%    [samples,channels] = FLACREAD2(FILE,'size')  returns samples and channels
%
%    Supports up to 8 channels of data, with up to 32 bits per sample.
%
%    By Emanuele Ruffaldi 2009/06/21
% 
%    See also  WAVWRITE, AUREAD, AUWRITE.
tag_info = [];
Y=[];
FS=0;
NBITS=0;
fmt = 'double';
a = length(FILE);
if a >= 5
    exten = FILE(a-4:a);
    if exten ~= '.flac'
        FILE = strcat(FILE,'.flac');
    end
end
if a <= 4
    FILE = strcat(FILE,'.flac');
end
if exist(FILE) ~= 2
    error('File not Found')
end

if ispc
    location_flac = which('flac.exe');
    location_metaflac = which('metaflac.exe');
elseif isunix
    location_flac = which('flac');
    location_metaflac = which('metaflac');
elseif ismac
    location_flac = which('flac');
    location_metaflac = which('metaflac');
else
    return 
end

%%%%Temporary file%%%%%%
tmpfile = tempname;
N12 = [];
location='';
for I=1:nargin-1
	if ischar(varargin{I}) && strcmp(varargin{I},'size') 
		[stat,data_title] = system([location,'metaflac', ' --show-total-samples --show-channels "', FILE,'"']);
		if length(data_title) >= 2
			YR = textscan(data_title,'%d\n%d\n');
			Y = [YR{1},YR{2}];
		else
			Y = [];
		end
		return
	elseif ~ischar(varargin{I})
		N12 = varargin{I}
		if length(N12) == 1
			N12 = [1 N12];
		end
	elseif ischar(varargin{I}) && strcmp(varargin{I},'native')
		fmt = varargin{I};
	elseif ischar(varargin{I}) && strcmp(varargin{I},'double')
		fmt = varargin{I};
	else
		error('not accepted');
	end
end	
s = [location_metaflac, ' --show-total-samples --show-channels --show-bps --show-sample-rate "', FILE,'"'];
[stat,data_title] = system(s);
if stat ~= 0
	return
end
YR = textscan(data_title,'%d\n%d\n%d\n%d\n');
TOT = double(YR{1});
CH = double(YR{2});
NBITS = double(YR{3});
if isempty(N12)
	N12 = [1 TOT];
end
if NBITS ~= 8 && NBITS ~= 16 && NBITS ~=24
	error('Unsupported Bits');
end
FS = double(YR{4});
if ~isempty(N12)
s = [location_flac, ' -d "', FILE ,'" -f ',' --sign=signed --endian=little  --force-raw-format ',sprintf(' --until=%d --skip=%d ',N12(2),N12(1)-1),' -o ', '"',tmpfile,'"'];
else
s = [location_flac, ' -d "', FILE ,'" -f ',' --sign=signed --endian=little --force-raw-format ',' -o ', '"',tmpfile,'"'];
end
[stat_2,raw_data] = system(s);
if stat_2 == 1
    error('Error while decodong file. File may be corrupted')
end
fid = fopen(tmpfile,'r');
dtype ='';
if NBITS==8
	dtype = 'uchar';
elseif NBITS==16
	dtype = 'int16';
elseif NBITS==24
	dtype = 'bit24';
end
if strcmp(fmt,'native')
	dtype = ['*' dtype];
end
Y = fread(fid,[CH (N12(2)-N12(1)+1)],dtype)';
if strcmp(fmt,'double')
	if NBITS==16
		Y = Y/32768; % is it safe?
	elseif NBITS==24
		Y = Y/(2^23);
	elseif NBITS==8
		Y = (Y-128)/128.0; % is it safe?
	end
end
fclose(fid);
delete(tmpfile);