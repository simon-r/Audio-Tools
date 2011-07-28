function [ h ] = plot_audio_track( Y , FS )
%plot_audio_track plot an audio track
%   Detailed explanation goes here

t = 1/FS ;
sY = size( Y ) ;

time = t * (0:(sY(1)-1)) ;

max_sam = 20000 ;

if sY(1) > max_sam
    r = find( mod( 1:sY(1) , floor( sY(1) / max_sam ) ) == 1 ) ;
else
    r = 1:sY(1) ;
end


for i=1:sY(2)
    subplot( sY(2) , 1 , i ) ;
    plot( time(r) , Y(r,i) ) ;
    grid on ;
    ti = sprintf( 'Channel: %1.0f' , i ) ;
    title( ti ) ; 
    xlabel('Time: [Sec]') ;
    ylabel('Amplitude') ;
end


end

