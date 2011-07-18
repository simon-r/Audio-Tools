function [ nX ] = oversampling( X , FS , nFS )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

ts = size( X ) ;
X = X' ;

nX = zeros( ts(2) , ts(1)*nFS/FS ) ;

c = 1 ;

time = c+1 ;
delta_time = FS/nFS ;

j = 1 ;

for i=c+1:ts(1)-c
    x = i-c:i+c ;
    y = X(:,x) ;
    
    cs = spline( x , y ) ;
    
    xt = time + [0:delta_time:1] ;
    xt = xt(1:size(xt,2)-1) ;
    yt = ppval( cs , xt ) ;
    
    syt = size(yt) ;
    
    nX(:,j:j+syt(2)-1) = yt ; 
    j = j + syt(2) ;
    time = delta_time + xt(size(xt,2)) ;
    
    if mod(i,10000) == 0 
        disp(i) ;
    end
end

    nX = nX' ;

end

