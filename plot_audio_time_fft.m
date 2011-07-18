function [ output_args ] = plot_audio_time_fft(  Y , FS , time_range , n )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


ch = size(Y,2) ;

[S freq time peak nr] = audio_time_fft( Y , FS , time_range , n , 20 ) ;

r = floor(size(S,2)/2):-1:1 ;

% max_f = max( freq(r) ) ;

logS = log(S) ;
l =  S ~= 0 ;
ls_max = max( logS(l) ) ;
ls_min = min( logS(l) ) ;

logS = ( logS - ls_min ) / ( ls_max - ls_min ) ;

for i=1:ch
    subplot( ch , 1 , i ) ;
    pcolor( time(1:n) , freq(r) , logS(1:n,r,i)' ) ;
    set( get(gca,'Children'), 'EdgeColor', 'none' ) ;
    caxis( [0 1] ) ;
    
    cm = colormap( 'Jet' ) ;
    colormap( cm ) ;
    colorbar ;

    ti = sprintf( 'Channel: %1.0f' , i ) ;
    title( ti ) ;
    ylabel('Freq [Hz]') ;
    xlabel('Time [sec]') ;   
end


end