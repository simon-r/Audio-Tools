function [ Y ti ] = frequency_sweep( FS , f_min , f_max , time )
% frequency_sweep Summary of this function goes here
%   Detailed explanation goes here


ch = 1 ;
t = 1/FS ;

samples = floor( time / t ) ;
Y = zeros( samples , ch ) ;

omega_min = 2*pi*f_min ;
omega_max = 2*pi*f_max ;

delta_omega = ( omega_max - omega_min ) / ( samples - 1 ) ;
delta_t = time / ( samples - 1 ) ;

t_v = omega_min:delta_omega:omega_max ;
ti = 0:delta_t:time ;

for i = 1:ch
    Y(:,i) = sin(t_v .* ti )' ;
end

end

