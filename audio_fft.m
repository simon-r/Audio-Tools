function [ abs_dft phase freq peak ] = audio_fft( Y , FS , time_range , varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if size( varargin , 2 ) >= 1
    smooth = varargin{1} ;
else
    smooth = 30 ;
end

t = 1/FS ;

[t_begin t_end] = test_time_range( time_range , t , size( Y ) ) ;

s = Y(t_begin:t_end,:) ;
abs_dft = fft( s ) ;
phase = angle( abs_dft ) ;

r = find( phase < 0 ) ;
phase(r) = 2*pi + phase(r) ;

abs_dft = abs( abs_dft ) ;

freq = (FS / size(abs_dft,1)) * [0:(size(abs_dft,1)-1)] ;

ch = size(abs_dft,2) ;

m = zeros( ch , 1 ) ;

for j = 1:ch
    abs_dft(:,j) = fastsmooth( abs_dft(:,j) , smooth , 1 , 1 ) ;
    m(j) = max( abs(abs_dft(:,j) ) ) ;
end

peak = max( m ) ;

end

