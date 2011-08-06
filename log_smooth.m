function smoothU = log_smooth( freq , U , w )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Wsum = 0 ;
r_old = [] ;

smoothU = zeros( size( U ) ) ;

b = 1 ;
e = 1 ;

lf = length(freq) ;

for i=1:lf
  
    fb = freq(i) - freq(i)/2 * w ;
    fe = freq(i) * (1 + w*freq(i)) ;
  
    while freq(b) <= fb
        Wsum = Wsum - U(b) ;
        b = b + 1 ;
    end
    
    while freq(e) <= fe
        Wsum = Wsum + U(e) ;
        e = e + 1 ;
        if e > lf ; e = lf ; end ;
    end
    
    smoothU(i,:) = Wsum / (e - b) ;
end



end

