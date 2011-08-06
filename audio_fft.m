function [ abs_dft phase freq peak ] = audio_fft( Y , FS , time_range , varargin )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if size( varargin , 2 ) >= 2
    if strcmpi( varargin{1} , 'lin' )
        smooth_type = 0 ;
        smooth_size = varargin{2} ;
    elseif strcmpi( varargin{1} , 'log' )
        smooth_type = 1 ;
        smooth_size = varargin{2} ;
    end
else
    smooth_type = -1 ;
    smooth_size = 30 ;
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
    
    if smooth_type == 0
        abs_dft(:,j) = fastsmooth( abs_dft(:,j) , smooth_size , 1 , 1 ) ;
    elseif smooth_type == 1
        abs_dft(:,j) = log_smooth( freq , abs_dft(:,j) , smooth_size ) ;
    end
    
    m(j) = max( abs(abs_dft(:,j) ) ) ;
end

peak = max( m ) ;

end

