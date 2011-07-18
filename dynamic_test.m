function [] = dynamic_test( file_in , is_dir )

if nargin == 0
    is_dir = true ;
    file_in = '.' ;
end

if nargin == 1 
   is_dir = false ;
end

if is_dir
    d = dir( file_in ) ;
    sd = size( d , 1 ) ;
else
    sd = 1 ;
end


for i = 1:sd
    if is_dir == false
        file_name = file_in ;
    else 
        file_name =  d(i).name ;
    end
    
    if is_dir == true
        full_name = sprintf( '%s/%s' , file_in , file_name ) ;
    else
        full_name = file_in ;
    end
    
    mp3 = regexp ( file_name , '\.mp3$' ) ;
    flac = regexp ( file_name , '\.flac$' ) ;
    
    if mp3 > 0
        [dr , drm , dr_std] = test_file_mp3( full_name ) ;
        print_res( dr , drm , dr_std , file_name ) ;
    elseif flac > 0
        [dr , drm , dr_std] = test_file_flac( full_name ) ;
        print_res( dr , drm , dr_std , file_name ) ;
    end
end


    function [dr , drm , dr_std] = test_file_mp3( in_file )
        [Y,FS] = mp3read( in_file );
        [dr , drm , dr_std] = dynamic_range( Y , FS ) ;
    end

    function [dr , drm , dr_std] = test_file_flac( in_file )
        [Y,FS] = flacread2( in_file );
        [dr , drm , dr_std] = dynamic_range( Y , FS ) ;
    end

    function [] = print_res( dr , drm , dr_std , in_file )
        s_dr  = sprintf( 'Range dinamico mio  : %.5g' , dr ) ;
        s_drm = sprintf( 'Media               : %.5g' , drm ) ;
        s_std = sprintf( 'Deviazione standard : %.5g' , dr_std ) ;
        
        disp ('--------------------------------------------------') ;
        disp (in_file) ;
        disp (s_dr) ;
        disp (s_drm) ;
        disp (s_std) ;
    end

end





