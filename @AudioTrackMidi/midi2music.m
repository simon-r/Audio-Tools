function [ time ] = midi2music( obj , varargin ) 
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

[obj.notes_mat time] = midiInfo( obj.midi , 0 ) ;

channels = 1 ;

obj.Y = 0 ;

Y = zeros( floor( max( time ) / obj.period ) + 10 ,  channels ) ;

notes_cnt = length( obj.notes_mat ) ;

snd = Sound ;

tic ;
for i=1:notes_cnt
    
    %if mod( i , 200 ) == 0 ; disp(i) ; end ;
    
    snd.note = obj.notes_mat(i,3) ;
    snd.time = obj.notes_mat(i,6) - obj.notes_mat(i,5) ;
    snd.velocity = obj.notes_mat(i,4) ;
    
    y = snd.get_sound ;
    
    sb = floor ( obj.notes_mat(i,5) * obj.Fs ) + 1 ;
    se = sb + length( y ) - 1 ;
    
    for j=1:channels
        Y(sb:se,j) = Y(sb:se,j) + y ;
    end
end
time = toc ;

m = stereo_max( Y ) ;

obj.Y = Y * (0.5/m);

end

