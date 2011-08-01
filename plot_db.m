function [ h ] = plot_db( x , dB , x_mode , l_message , t_message , varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


sdB = size( dB ) ;

if strcmpi( x_mode , 'freq' ) 
    xl_message = 'Freq [Hz]' ;
else
    xl_message = 'Time [sec]' ;
end

h = zeros(sdB(2)) ;

for i=1:sdB(2)         
    subplot( sdB(2) , 1 , i ) ;
    h(i) = plot( x , dB , 'Color' , 'blue' ) ;
    set( h(i) , 'YScale' , 'lin' , 'XScale' , 'lin' ) ;
    xlabel(xl_message) ;
    ylabel('dB') ;
    legend(l_message);
    title(t_message)
    grid on ;
end

end

