function [ Y ] = musical_scale( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

a = 440 ;
main_a = a / 16 ;

keys_cnt = 88 ;
Fs = 44100 ;
note_time = 1 ;
gain = -13 ;
ch = 1 ;

Y = zeros( keys_cnt*Fs*note_time , ch ) ;

for i=1:keys_cnt 
    fr = main_a * 2^((i-1)/12) ;
    Yn = frequency_sweep( 44100 , fr , fr , note_time , 'gain' , gain ) ;
    
    r = ((i-1)*note_time*Fs+1):((i)*note_time*Fs) ;
    Y(r,1) = Yn ;
end

end

