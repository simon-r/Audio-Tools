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

if time_range(1) ~= -1
    if time_range(2) < time_range(1)
        error('error: negative time range') ;
    end
    
    if time_range(2) < 0 || time_range(1) < 0
        error('error: the values in time range must be positives') ;
    end
    
    start_sample = floor( time_range(1) / t ) ;
    end_sample = floor( time_range(2) / t ) ;
else
    start_sample = 1 ;
    end_sample = size(Y,1) ;
end

r = start_sample:end_sample ;
res = sqrt ( sum( Y(r,:).^2 / size( Y(r,:),1) ) ) ;
dB = 20 * log10( res / ref  ) ;

end

