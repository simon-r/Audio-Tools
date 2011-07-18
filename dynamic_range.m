function [ DR , DRM , DR_STD , VOL ] = dynamic_range( y , fs )

s = size( y ) ;

seg_time = 2 ;
seg_s = fs * seg_time ;
dys = 4900*2 ;

p = floor ( s(1) / seg_s ) ;

res = zeros( p , 1 ) ;

VOL.max_v = zeros( p , 1 ) ;
VOL.min_v = zeros( p , 1 ) ;

y = y.^2 ;
ref = sqrt(2)^(-2) ;

for i = 1:p
    dynamic = zeros ( seg_s/dys , 1 ) ;
    for j=1:seg_s/dys
        b = (i-1)*(seg_s)+1 + (j-1)*dys ;
        e = b + dys ;
        dynamic(j) = mean( y( b:e , 1 ) ) ;
    end ;
    
    mi = min( dynamic ) ;
    ma = max( dynamic ) ;
    
    VOL.max_v(i) = 10*log10( ma / ref ) ;
    VOL.min_v(i) = 10*log10( mi / ref ) ;
    
    res(i) = 10*log10( ma/mi ) ;   
end ;

v_i = isnan(res) | isinf(res) ;

res(v_i) = [] ;
VOL.max_v(v_i) = [] ;
VOL.min_v(v_i) = [] ;

p = size( res , 1 ) ;

figure(1) ;
plot( 2*[1:p] , res ) ;
hold all ;
plot( 2*[1:p] , VOL.max_v ) ;
plot( 2*[1:p] , VOL.min_v ) ;
grid on ;

xlabel( 'Tempo [sec]' ) ;
ylabel( 'dinamica [dB]' ) ;

figure(2) ;
hist( res , 0:0.8:48 ) ;
xlabel( 'dinamica [dB]' ) ;

[ DR DRM DR_STD ] = eval_dr_3( res ) ;

end

