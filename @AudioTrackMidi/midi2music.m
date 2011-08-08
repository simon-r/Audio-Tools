function [time clock] = midi2music( obj , varargin ) 
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%[obj.notes_mat time] = midiInfo( obj.midi , 0 ) ;

channels = 1 ;

obj.Y = 0 ;

time = max ( obj.notes_mat(:,6) + obj.notes_mat(:,7) ) ;

Y = set_array( zeros( floor( max( time ) / obj.period ) + 10000 ,  channels ) ) ;

notes_cnt = length( obj.notes_mat ) ;

snd = obj.sounds ;

tic ;
for i=1:notes_cnt
    
    %if mod( i , 200 ) == 0 ; disp(i) ; end ;
    
    midi_ch = obj.notes_mat(i,3) ;
    
    snd(midi_ch).note = obj.notes_mat(i,4) ;
    snd(midi_ch).time = obj.notes_mat(i,7) ;
    snd(midi_ch).velocity = obj.notes_mat(i,5) ;
    
    
    
%     if snd.time < 0 
%         disp ( snd.time )
%     end
%     if i == 1125 
%         disp(i) ;
%     end
    y = snd(midi_ch).get_sound ;
    
    sb = floor ( obj.notes_mat(i,6) * obj.Fs ) + 1 ;
    se = sb + length( y ) - 1 ;
    
    for j=1:channels
        Y(sb:se,j) = Y(sb:se,j) + y ;
    end
end
clock = toc ;

m = stereo_max( gather( Y ) ) ;

obj.Y = Y * (0.5/m);

end

