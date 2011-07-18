function [ s_f freq peak ] = audio_fft( Y , FS , time_range )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


if time_range(2) < time_range(1)
    error('error') ;
end

smooth = 30 ;

t = 1/FS ;

t_begin = floor( time_range(1) / t ) ;
t_end = floor(  time_range(2) / t ) ;

s = Y(t_begin:t_end,:) ;
s_f = fft( s ) ;

s_f = abs( s_f ) ;

freq = (FS / size(s_f,1)) * [0:(size(s_f,1)-1)] ;

ch = size(s_f,2) ;

for j = 1:ch
    s_f(:,j) = fastsmooth( s_f(:,j) , smooth , 1 , 1 ) ;
    m(j) = max( abs(s_f(:,j) ) ) ;
end

peak = max( m ) ;

end

