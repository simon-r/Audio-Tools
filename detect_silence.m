function [ S silence_cnt ] = detect_silence( Y , FS , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;

p.addRequired( 'Y' ) ;
p.addRequired( 'FS' ) ;

p.addOptional( 'silence_level' , -45 , @(x)isnumeric(x) && x <= 0 ) ;
p.addOptional( 'time_range' , [-1 0] ) ;
p.addOptional( 'n' , 0 , @(x)isnumeric(x) && x >= 0) ;

p.parse(Y, FS, varargin{:});

time_range = p.Results.time_range ;
n = p.Results.n ;
silence_level = p.Results.silence_level ;

t = 1/FS ;

if time_range(1) == -1
    time_range = [0 0.1] ;
end

[ start_sample end_sample ] = test_time_range( time_range , t , size(Y) ) ;


delta_t = time_range(2) - time_range(1) ;
delta_samples = (end_sample - start_sample) ;


sizeY = size( Y ) ;

if n ~= 0
    er = start_sample + (end_sample - start_sample) * n ;
    r = [start_sample:er] ;
else
    r = [1:sizeY(1)] ;
end

seg = floor( (size(Y(r,:),1)*t) / delta_t ) ;

rms = zeros( seg , size(Y(r,:),2) ) ;

current_sample = start_sample ;
for i = 1:seg
    r = current_sample:(current_sample+delta_samples-1) ;
    [foo rms(i,:)] = u_rms( Y(r,:) , FS ) ;
    
    current_sample = current_sample + delta_samples ;
end

if current_sample < end_sample
    rms(i+1,:) = u_rms( Y(current_sample:end_sample) , FS ) ;
end


silence_cnt = 0 ;
S = zeros( size(rms,1) , 5 ) ;

for ch=1:size(rms,2)
    
    silence_flag = false ;
    silence_begin = 0 ;
    
    for i=1:size(rms,1)
        
        if not( silence_flag ) && rms(i,ch) <= silence_level
            
            silence_flag = true ;
            silence_begin = i ;
            silence_cnt = silence_cnt + 1 ;
            
        elseif silence_flag && rms(i,ch) > silence_level
            
            silence_flag = false ;
            
            S(silence_cnt,1) = ch ;
            S(silence_cnt,2) = silence_begin * delta_samples ;
            S(silence_cnt,3) = delta_samples + ( i - 1 ) * delta_samples ;
            S(silence_cnt,4) = S(silence_cnt,2) * t ;
            S(silence_cnt,5) = S(silence_cnt,3) * t ;
        end
         
    end
    
    if silence_flag
            
            S(silence_cnt,1) = ch ;
            S(silence_cnt,2) = silence_begin * delta_samples ;
            S(silence_cnt,3) = delta_samples + ( i - 1 ) * delta_samples ;
            S(silence_cnt,4) = S(silence_cnt,2) * t ;
            S(silence_cnt,5) = S(silence_cnt,3) * t ;
            
    end
    
end

S = S(1:silence_cnt,:) ;

end


