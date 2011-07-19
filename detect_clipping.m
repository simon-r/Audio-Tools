function [ C clip_cnt ] = detect_clipping( Y , FS , level_dB )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% C { ch s_begin s_end t_begin t_end clip_sign }
p = inputParser ;

p.addOptional( 'level_dB' , 0 , @(x)isnumeric(x) && x <= 0 ) ;
p.parse( level_dB ) ;

level = 10^(level_dB/20) ;
clip = false ;

t = 1/FS ;

C = {} ;
clip_cnt = 0 ;
for ch=1:size(Y,2)
    
    clip_flag = false ;
    clip_begin = 0 ;
    clip_sign = 1 ;
    
    for i=1:size(Y,1)
        
        if ( Y(i,ch) >= level || Y(i,ch) <= -level ) && clip_flag == false
            
            clip_flag = true ;
            clip_cnt = clip_cnt + 1 ;
            clip_begin = i ;
            clip_sign = sign(Y(i,ch)) ;
            
        elseif ( Y(i,ch) < level || Y(i,ch) > -level ) && clip_flag
            
            clip_flag = false ;
            
            C{clip_cnt,1} = ch ;
            C{clip_cnt,2} = clip_begin ;
            C{clip_cnt,3} = i-1 ;
            C{clip_cnt,4} = clip_begin*t ;
            C{clip_cnt,5} = (i-1)*t ;
            C{clip_cnt,5} = clip_sign ;
            
        end
        
    end
end

end

