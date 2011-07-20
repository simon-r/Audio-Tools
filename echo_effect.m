function [ D ] = echo_effect( Y , FS , varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;

p.addRequired( 'Y' ) ;
p.addRequired( 'FS' ) ;

p.addOptional( 'delay' , 0.2 , @(x)isnumeric(x) ) ;

p.addParamValue('repetitons', 1 , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('rep_attenuation', -6 , @(x)isnumeric(x) && x <= 0 ) ;

p.addParamValue('echo_type', 'normal' , @(x)strcmpi(x,'peak') || ... 
    strcmpi(x,'normal') || strcmpi(x,'ramp') || strcmpi(x,'rand_peaks') ) ;

p.addParamValue('sigma', 0.0003 , @(x)isnumeric(x) ) ;
p.addParamValue('gain', 1 , @(x)isnumeric(x) ) ;

p.parse( Y, FS, varargin{:} );

delay = p.Results.delay ;
echo_type = p.Results.echo_type ;

sigma = p.Results.sigma ;
gain = p.Results.gain ;
rep = p.Results.repetitons ;
rep_att = p.Results.rep_attenuation ;

t = 1/FS ;



if strcmpi(echo_type,'normal')
    
    c_time = delay * 2 ;
    C = -c_time:t:c_time ;
    
    X = normpdf( C , delay , sigma ) * (sigma*sqrt(2*pi)) ;
    X = X / sum( X ) * gain ;
    X(floor(size(C,2)/2)) = 1 ;
    
elseif strcmpi(echo_type,'peak')
    
    X = zeros( 1 , 2*floor( (rep*delay)/t ) ) ;
    
    dd = floor( delay / t ) ;
    dh = dd ;
    
    for i=1:rep
        X(dh+i*dd) = gain ;
        gain = gain * 10^(rep_att/20) ;
    end
    
    X(dh) = 1 ;
    
%     sX = size( X , 2 ) ;
%     X = X(sX:-1:1) ;
    
elseif strcmpi(echo_type,'ramp')
    
    X = zeros( 1 , 2*floor( (rep*delay)/t ) ) ;
    
    dd = floor( delay / t ) ;
    dh = floor( size(X,2) / 2 ) ;
    
    b = 100 ;
    delta = -0.01 ;
    C = exp(b:delta:0)/exp(b) ;
    
    Cs = size( C , 2 ) ;
    
    X(dh+dd+1:dh+dd+Cs) = C * gain ;
    
    sX = size( X , 2 ) ;
    X(dh) = 1 ;
    X = X(sX:-1:1) ;
    
elseif strcmpi(echo_type,'rand_peaks')   
    
    X = zeros( 1 , 2*floor( (rep*delay)/t ) ) ;
    
    dd = floor( delay / t ) ;
    dh = floor( size(X,2) / 2 ) ;
    
    indx = dh + floor(100*rand(1,100)) ;
    val = rand(1,100) * gain ;
    
    X(indx) = val ;
    
    X(dh) = 1 ;
end


sizeY = size(Y) ;

sX = size( X , 2 ) ;
D = zeros( sizeY(1) + sX - 1 , sizeY(2) ) ;

for ch=1:sizeY(2) 
    D(:,ch) = conv( Y(:,ch) , X ) ;
end

my = stereo_max( Y ) ; 
m = stereo_max( D ) ;
D = D * my/m ;

end

