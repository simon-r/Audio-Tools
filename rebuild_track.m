function [ Y ] = rebuild_track( Y , FS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sY = size( Y ) ;
th = 0.99 ;

for i = 1:sY(2) 
    indx = find( not( Y(:,i) > th | Y(:,i) < -th ) ) ;
%     indxn = find( Y(:,i) > th | Y(:,i) < -th ) ;
    
    Y(:,i) = spline( indx , Y(indx,i) , 1:sY(1) ) ;  
end
end

