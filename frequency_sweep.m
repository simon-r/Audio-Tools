function [ Y t_vect ] = frequency_sweep( FS , f_min , f_max , time , varargin )
% frequency_sweep Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addParamValue( 'waveform', 'sin' , @(x)strcmpi(x,'sin') || ... 
    strcmpi(x,'triangle') || ...
    strcmpi(x,'square') || ... 
    strcmpi(x,'sawtooth') ) ;

p.addParamValue('gain', -10 , @(x)isnumeric(x) && x <= 0 ) ;

p.parse(varargin{:});

if strcmpi( p.Results.waveform , 'sin' ) 
    wave_f = @sin ;
elseif strcmpi( p.Results.waveform , 'triangle' ) 
    wave_f = @triangle_f ;
elseif strcmpi( p.Results.waveform , 'square' ) 
    wave_f = @square_f ;
elseif strcmpi( p.Results.waveform , 'sawtooth' ) 
    wave_f = @sawtooth_f ;
end

ch = 1 ;
t = 1/FS ;

gain = p.Results.gain ;

samples = floor( time / t ) ;
Y = zeros( samples , ch ) ;

omega_min = 2*pi*f_min ;
omega_max = 2*pi*f_max ;

delta_omega = ( omega_max - omega_min ) / ( samples - 1 ) ;
delta_t = time / ( samples - 1 ) ;

if delta_omega == 0
    t_v = ones(1,samples) * omega_min ;
else
    t_v = omega_min:delta_omega:omega_max ;  
end

t_vect = 0:delta_t:time ;

for i = 1:ch
    Y(:,i) = wave_f( t_v .* t_vect )' ;
end

    Y = gain_set( Y , FS , gain , 'dB' ) ;

end

function [ tr ] = triangle_f(x)
    tr = asin( sin( x ) ) / (pi/2) ;
end

function [ sq ] = square_f(x)
    sq = sign( sin( x ) ) ;
end

function [ sw ] = sawtooth_f ( x ) 
    a = 2*pi ;
    sw = 2*( x/a - floor( x/a + 1/2 ) ) ;
end