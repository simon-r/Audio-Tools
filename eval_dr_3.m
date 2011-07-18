function [ DR DRM DR_STD ] = eval_dr_3( dyn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ds = size( dyn , 1 ) ;

cut = 3 ;
dyn = dyn(cut : ds-cut) ;
dyn_std = std( dyn ) ;

[n,x] = hist( dyn , 0:0.8:48 ) ;

[ n , x ] = clean_nx( n , x ) ;

sum_n = sum( n ) ;

cl = round( sum_n * 0.12 ) ;

sn = size( n , 2 ) ;

b = 1 ;
e = sn ;

for i = 1:round(cl/2)
    %     if n(b) == 0
    %         b = b + 1 ;
    %     end
    %     n(b) = n(b) - 1 ;
    
    if n(e) == 0
        e = e - 1 ;
    end
    n(e) = n(e) - 1 ;
end

[ n , x ] = clean_nx( n , x ) ;

sx = size( x , 2 ) ;

DRM = sum( n .* x ) / sum( n ) ;
DR_STD = sqrt ( sum(n .* ( x - DRM ).^2 ) / sum ( n ) ) ;

%DR = round( ( x( sx ) - x( 1 ) ) * ( DR_STD * 0.5 )  * ( dyn_std * 0.5 ) ) ;
%DR = round( ( x( sx ) - x( 1 ) ) * ( DR_STD * 0.5 ) ) ;
DR = round( ( x( sx ) - x( 1 ) ) * ( 1 + 0.4*sigmoid( 0.5 , DR_STD ) ) ) ;


% figure ;
% plot( x , n ) ;
% xlabel( 'dinamica [dB]' ) ;

    function [ n x ] = clean_nx( n , x )
        x = x( n > 0 ) ;
        n = n( n > 0 ) ;
    end

    function [ y ] = sigmoid( x , f )
        y = 1./( 1 + (1/f)*exp( -0.5 * ( x ) ) ) ;
    end
        

end

