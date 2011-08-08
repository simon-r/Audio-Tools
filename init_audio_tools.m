addpath('audio_coding') ;
addpath('midi') ;
addpath('samples') ;
addpath('miditoolbox') ;

f = false ;

if exist( 'use_gpu_array' , 'var' ) && use_gpu_array == true 
    set_array = @gpuArray ;
    set_gather = @gather ;
    disp('GPU enabled') ;
    f = true ;
elseif exist( 'use_gpu_array' , 'var' ) && use_gpu_array == false 
    clear set_array ;
    clear set_gather ;
    f = false ;
end

global use_gpu_array 
use_gpu_array = f ;

clear f ;