function  plot_audio_fft( Y , FS , time_range )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[ s_f freq mm ] = audio_fft( Y , FS , time_range ) ;

r = 1:floor(size(s_f,1)/2) ;

ch = size(s_f,2) ;

for j = 1:ch
    subplot( ch , 1 , j ) ;
    semilogy( freq(r) , s_f(r,j)/mm ) ;
    ti = sprintf( 'Channel: %1.0f' , j ) ;
    title( ti ) ; 
    xlabel('Freq: [Hz]') ;
    ylabel('Amplitude') ;
    grid on ;    
end 

end

