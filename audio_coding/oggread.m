function [Y,FS,NBITS,encoding_info,tag_info] = oggread(FILE)
%OGGREAD Read OGG (".ogg") sound file.
%    Y = OGGREAD(FILE) reads a OGG file specified by the string FILE,
%    returning the sampled data in Y. Amplitude values are in the range [-1,+1].
% 
%    [Y,FS,NBITS,encoding_info,tag_info] = OGGREAD(FILE) returns the sample rate (FS) in Hertz
%    and the number of bits per sample (NBITS) used to encode the
%    data in the file.
%
%    'encoding_info' is a string containing information about the mp3
%    encoding used
%
%    'tag_info' is a string containing the tag information of the file
%
% 
%    Supports two channel or mono encoded data.
% 
%    See also OGGWRITE, WAVWRITE, AUREAD, AUWRITE.
a = length(FILE);
if a >= 4
    exten = FILE(a-3:a);
    if exten ~= '.ogg'
        FILE = strcat(FILE,'.ogg');
    end
end
if a <= 3
    FILE = strcat(FILE,'.ogg');
end
if exist(FILE) ~= 2
    error('File not Found')
end
%%%%%% Location of the ".exe" Files
if ispc
    location_oggdec = which('oggdec.exe');
    location_ogginfo = which('ogginfo.exe');
elseif isunix
    location_oggdec = locate_unix_cmd( 'oggdec' ) ;
    location_ogginfo = locate_unix_cmd( 'ogginfo' ) ;
elseif ismac 
    location_oggdec = which('oggdec');
    location_ogginfo = which('ogginfo');
else
    location_oggdec = which('oggdec');
    location_ogginfo = which('ogginfo');
end
%ww = findstr('oggread.m',s);
%%%%Temporary file%%%%%%
tmpfile = ['temp.wav'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Info extraction using "ogginfo.exe"%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[stat_1,raw_info] = dos([location_ogginfo , ' ' , '"',FILE,'"']);
raw_info_channels_beg = findstr(raw_info,'Channels: ');
raw_info_channels_end = findstr(raw_info,'Rate: ')-2;
info_channels = raw_info(raw_info_channels_beg:raw_info_channels_end);
raw_info_rate_beg = findstr(raw_info,'Rate: ');
raw_info_rate_end = findstr(raw_info,'Nominal bitrate: ')-1;
info_rate = strcat(raw_info(raw_info_rate_beg:raw_info_rate_end),' Hz');
raw_info_bit_rate = findstr(raw_info,'Nominal bitrate: ');
raw_info_bit_rate_end = findstr(raw_info,'kb/s');
info_bit_rate = raw_info(raw_info_bit_rate+17:raw_info_bit_rate_end-1);
info_bit_rate = ['Bit Rate: ',num2str(floor(str2num(info_bit_rate))),' Kb/s'];
encoding_info = {info_channels info_rate info_bit_rate};
%%%%% TAG INFO %%%%%
if isempty(findstr(raw_info,'User comments section follows...')) ~= 1
    tag_info_beg = findstr(raw_info,'User comments section follows...')+32;
    tag_info_end = findstr(raw_info,'Vorbis stream 1:')-1;
    tag_info = raw_info(tag_info_beg:tag_info_end);
else
    tag_info = 'No Tag Info';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% File Decoding using "oggdec.exe" %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[stat_2,raw_data] = dos([location_oggdec, ' -o ', tmpfile, ' ', '"',FILE,'"']);
if stat_1 == 1 | stat_2 == 1
    error('Error while decodong file. File may be corrupted')
end
[Y,FS,NBITS] = wavread(tmpfile);    % Load the data and delete temporary file
delete(tmpfile);
