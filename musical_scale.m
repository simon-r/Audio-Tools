function [ Y ] = musical_scale( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addOptional('start_key', 1, @(x)isinteger(x) && x >= 1 ) ;
p.addOptional('end_key', 88, @(x)isinteger(x) && x >= 1 ) ;
p.addOptional('Fs', 44100, @(x)isnumeric(x) && x > 0 ) ;

p.addParamValue('note_time', 1 , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('gain', -16 , @(x)isnumeric(x) && x <= 0 ) ;
p.addParamValue('channels', 1 , @(x)isinteger(x) && x > 0 ) ;
p.addParamValue('a', 440 , @(x)isinteger(x) && x > 400 && x < 480 ) ;

p.parse(varargin{:});

a = p.Results.a ;
main_a = a / 16 ;

start_key = p.Results.start_key ;
end_key = p.Results.end_key ;
Fs = p.Results.Fs ;
note_time = p.Results.note_time ;
gain =  p.Results.gain ;
ch =  p.Results.channels ;

keys_cnt = end_key - start_key + 1 ;
Y = zeros( keys_cnt*Fs*note_time , ch ) ;

for i=start_key:end_key
    fr = main_a * 2^((i-1)/12) ;
    
    Yn = frequency_sweep( 44100 , fr , fr , note_time , 'gain' , gain ) ;
    
    Yn = fade_inout( Yn , Fs , note_time/10 ) ;
    
    r = ((i-1)*note_time*Fs+1):((i)*note_time*Fs) ;
    for j=1:ch
        Y(r,j) = Yn ;
    end
end

end

