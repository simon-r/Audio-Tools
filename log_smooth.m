function smoothU = log_smooth( freq , U , w )
% smoothU = log_smooth( freq , U , w )
% perform the smooth on the logartimic scale
%
% perform a logaritmic rectamgular smooth on U where freq is the x-axis by
% generating a window that cover 2*w octave aroud freq(i).
% This function is useful for smoothing in log-xscale.
% freq: is 1-by-n vector
% U: is n-by-channels martix 
% w: a real where 0 < w < 1 

wsum = zeros( 1 , size( U , 2 ) ) ;

smoothU = zeros( size( U ) ) ;

b = 1 ;
e = 1 ;

lf = length(freq) ;

delta_f = ( freq(lf) - freq(1) ) / ( lf - 1 ) ;

ob = 1 ;
oe = 1 ;

for i=1:lf
  
    fb = freq(i) - freq(i)/2 * w ;
    fe = freq(i) * (1 + w) ;
  
    b = floor( fb / delta_f ) + 1 ;
    e = floor( fe / delta_f ) + 1 ;

    if e > lf ; e = lf ; end ;
    
    wsum = wsum - sum ( U(ob:b-1,:) , 1 ) ;
    wsum = wsum + sum ( U(oe+1:e,:) , 1 ) ;
    
    smoothU(i,:) = wsum / ( e - b + 1 ) ;
    
    ob = b ;
    oe = e ;
    
end



end

