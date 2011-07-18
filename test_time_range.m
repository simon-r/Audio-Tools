function [ start_sample end_sample ] = test_time_range( time_range , t , sizeY )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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
    end_sample = sizeY(1) ;
end

end

