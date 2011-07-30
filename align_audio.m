function [ D , best_dist , dv ] = align_audio( Y , X , c , s , m )


if s <= 10000
    p = 1 ;
else
    p = -9.090e-7 * s + 1.0091 ;
end

if p < 0.01
    p = 0.01 ;
end

indx = floor ( 2*s*rand( 1 , floor( s/(1/p*log(s)+1) ) ) ) - s ;
r = c + indx ; 

D = -m ;
best_dist = realmax('double') ;

dv = zeros(2*m+1,2) ;

for i=-m:m   
   d = distance( Y(r,:) , X(r+i,:) ) ;
   
   if d < best_dist 
       D = i ;
       best_dist = d ;
   end
   
   dv(i+m+1,:) = [i d] ;
end

    function d = distance( x , y )
        d = mean ( sqrt( sum( ( x - y ).^2 ) ) ) ;
    end

end

