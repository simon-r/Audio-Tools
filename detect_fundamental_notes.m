function [ notes ] = detect_fundamental_notes( Y , FS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if length( Y ) < FS*10
    notes =  [] ;
    disp('The length of Y shoulb be of at least of 10 sec') ;
    return ;
end

min_f = 0.7 ;

cen = floor( length( Y ) / 2 ) ;
test_size = floor( length( Y ) / 3 ) ;
max_sh = floor( 1/min_f * 44100 ) ;

[d dg] = find_tracks_shifting( Y(:,1) , Y(:,1) , cen , test_size , max_sh ) ;

c = [-1 ; 1] ;
cv = conv (  dg(:,2) , c , 'same' ) ;

mr = find( cv < 0 ) ;


a = 1+1 ;
end

