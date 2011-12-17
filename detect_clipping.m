function [ C clip_cnt ] = detect_clipping( Y , FS , level_dB )
%function [ C clip_cnt ] = detect_clipping( Y , FS , level_dB )
%   return a ( clip by 6 ) matrix that stores all clipping intervals
%
% Matrix format:
% C [ channel sample_begin sample_end time_begin time_end clip_sign ]
%
% Arguments:
% Y : Audio trak
% FS : samplig freq.
% level_dB : clipping level in dB
%

if level_dB > 0
    error( 'error: the clipping level must be less or equal than 0.' )
end

level = 10^(level_dB/20) ;
clip = false ;

t = 1/FS ;

sz = 20000 ;
step = sz ;
C = zeros(sz,6) ;
clip_cnt = 0 ;

for ch=1:size(Y,2)
    
    clip_flag = false ;
    clip_begin = 0 ;
    clip_sign = 1 ;
    
    for i=1:size(Y,1)
        
        if not( clip_flag ) && ( Y(i,ch) >= level || Y(i,ch) <= -level )
            
            clip_flag = true ;
            clip_cnt = clip_cnt + 1 ;
            clip_begin = i ;
            clip_sign = sign(Y(i,ch)) ;
            
        elseif clip_flag && ( Y(i,ch) < level && Y(i,ch) > -level )
            
            clip_flag = false ;
            
            C(clip_cnt,1) = ch ;
            C(clip_cnt,2) = clip_begin ;
            C(clip_cnt,3) = i-1 ;
            C(clip_cnt,4) = clip_begin*t ;
            C(clip_cnt,5) = (i-1)*t ;
            C(clip_cnt,6) = clip_sign ;
            
            if clip_cnt >= sz
                C = [C ; zeros(step,6)] ;
                sz = size(C,1) ;
            end
            
        end
        
    end
    
    if clip_flag
        C(clip_cnt,1) = ch ;
        C(clip_cnt,2) = clip_begin ;
        C(clip_cnt,3) = i-1 ;
        C(clip_cnt,4) = clip_begin*t ;
        C(clip_cnt,5) = (i-1)*t ;
        C(clip_cnt,6) = clip_sign ;
        if clip_cnt >= sz
            C = [C ; zeros(step,6)] ;
            sz = size(C,1) ;
        end
    end
    
end

C = C(1:clip_cnt,:) ;

end

