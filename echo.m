function [ D ] = echo( Y , FS , varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;

p.addRequired( 'Y' ) ;
p.addRequired( 'FS' ) ;

p.addOptional( 'delay' , 0.2 , @(x)isnumeric(x) ) ;

p.addParamValue('repetitons', 1 , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('rep_attenuation', -6 , @(x)isnumeric(x) && x <= 0 ) ;

p.addParamValue('echo_type', 'normal' , @(x)strcmpi(x,'peak') || ... 
    strcmpi(x,'normal') || strcmpi(x,'ramp') ) ;

p.addParamValue('rep_attenuation', -6 , @(x)isnumeric(x) && x <= 0 ) ;

p.parse( Y, FS, varargin{:} );

delay = p.Results.delay ;
echo_type = p:Results.echo_type ;

sigma = 0.0003 ;
gain = 1 ;

t = 1/FS ;

c_time = delay * 2 ;
C = -c_time:t:c_time ;

if strcmpi(echo_type,'normal')
    X = normpdf( C , delay , sigma ) * (sigma*sqrt(2*pi)) ;
    X = X / sum( X ) * gain ;
    X(floor(size(C,2)/2)) = 1 ;
elseif strcmpi(echo_type,'normal')
    
    X(floor(size(C,2)/2)) = 1 ;
end



sizeY = size(Y) ;

D = zeros( sizeY ) ;

for ch=1:sizeY(2) 
    D(:,ch) = conv( Y(:,ch) , X , 'same' ) ;
end

my = stereo_max( Y ) ; 
m = stereo_max( D ) ;
D = D * my/m ;

end

