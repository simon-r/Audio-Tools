function [ res , dB ] = u_rms( Y , FS , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addOptional('time_range', [-1 0] ) ;
p.addOptional('ref', 1 ) ;

p.parse(varargin{:});

time_range = p.Results.time_range ;
ref = p.Results.ref ;

t = 1/FS ;

[ start_sample end_sample ] = test_time_range( time_range , t , size(Y) ) ;

r = start_sample:end_sample ;
res = sqrt ( sum( Y(r,:).^2 / size( Y(r,:),1) ) ) ;
dB = 20 * log10( res / ref  ) ;


end

