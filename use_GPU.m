function use_GPU( flag )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

global use_gpu_array 

if flag
    use_gpu_array = true ;
    disp( 'GPU enabled' ) ;
else
    use_gpu_array = false ;
    disp( 'GPU disabled' ) ;
end

disp( 'Don''t forget to run: init_audio_tools' )

end
