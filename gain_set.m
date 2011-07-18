function [ Y ] = gain_set( Y , FS , gain , mode , varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% p = inputParser ;
% p.addRequired('gain', 0 ) ;
% p.addRequired('gain_mode', 'lin' , @(x)strcmpi(x,'lin') || @(x)strcmpi(x,'dB') ) ;
% 
% p.parse(varargin{:});

p = inputParser ;
p.addOptional('time_range', [-1 0] ) ;

p.parse(varargin{:});
time_range = p.Results.time_range ;

if strcmpi(mode,'lin')
    g = gain ;
elseif strcmpi(mode,'dB')
    g = 10^(gain/20) ;
else
    error('error: invalid gain mode; admitted values are "lin" or "dB" ') ;
end

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

    Y(r,:) = Y(r,:) * g ;

end

