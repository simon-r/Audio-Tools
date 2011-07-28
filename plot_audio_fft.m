function  plot_audio_fft( Y , FS , time_range , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


p = inputParser ;
p.addParamValue('min_freq', min_freq , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('max_freq', max_freq , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('XScale', 'linear' , @(x)strcmpi(x,'linear') || ... 
    strcmpi(x,'log') ) ;
p.addParamValue('YScale', 'log' , @(x)strcmpi(x,'linear') || ... 
    strcmpi(x,'log') ) ;

p.parse(varargin{:});


[ s_f freq mm ] = audio_fft( Y , FS , time_range ) ;

% r = 1:floor(size(s_f,1)/2) ;

mx_freq = p.Results.max_freq ;
mn_freq = p.Results.min_freq ;

r = find( freq <= mx_freq & freq >= mn_freq ) ;

ch = size(s_f,2) ;

for j = 1:ch
    subplot( ch , 1 , j ) ;
    plot( freq(r) , s_f(r,j)/mm ) ;
    set( gca ,  'XScale' , p.Results.XScale , 'YScale' , p.Results.YScale ) ;
    ti = sprintf( 'Channel: %1.0f' , j ) ;
    title( ti ) ; 
    xlabel('Freq: [Hz]') ;
    ylabel('Amplitude') ;
    
    grid on ;    
end 

end

