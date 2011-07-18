function [ D , r , x , ry , dv] = align_audio( X , Y , c , s , m )

x = X(c-s:c+s) ;

D = -m ;
r =  realmax('double') ;

dv = zeros(2*m+1,2) ;

for i=-m:m
   y = Y(c+i-s:c+i+s)  ;
   d = distance( x , y ) ;
   
   if d < r 
       D = i ;
       r = d ;
       ry = y ;
   end
   
   dv(i+m+1,:) = [i d] ;
end

    function d = distance( x , y )
        d = sqrt( sum( ( x - y ).^2 ) ) ;
    end

end

