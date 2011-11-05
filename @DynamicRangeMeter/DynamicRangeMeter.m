classdef DynamicRangeMeter  < hgsetget
    %DYNAMICRANGEMETER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = private , GetAccess = private )
        is_dir
        is_open = false ;
        name 
    end
    
    properties ( SetAccess = private , GetAccess = public )
        dr14 
    end
    
    properties ( Dependent = true , SetAccess = private , GetAccess = public )
        off_dr14 
    end
    
    methods
        
        function r = open( drm , name )
            drm.name = name ;
            if exist( name , 'dir' ) == 7
                drm.is_dir = true ;
                drm.is_open = true ;
                r = 2 ;
            elseif exist( name , 'file' ) == 2
                drm.is_dir = false ;
                drm.is_open = true ; 
                r = 1 ;
            else
                r = 0 ;
            end
        end
        
        function close( drm )
            drm.is_open = false ;
        end
        
        
        function [dr14 f] = scan( drm , varargin )
            
            if not ( drm.is_open )
                return
            end
            
            dr14 = [] ;
            
            t = AudioTrack ;
            if not( drm.is_dir ) % is a file!
                
                f = t.open( drm.name ) ;
                
                if f == false           
                    return ;
                end
                
                [ dr dB_peak dB_rms ] = compute_DR14( t.Y , t.Fs ) ;
                
                dr14.name = drm.name ;
                dr14.dr14 = dr ;
                dr14.peak = dB_peak ;
                dr14.rms = dB_rms ;
                
            else
                
                d = dir( drm.name ) ;
                
                f_cnt = size(d,1) ;
                
                j = 1 ;
                for i = 1:f_cnt
                    
                    file_name = fullfile( drm.name , d(i).name ) ;
                    f = t.open( file_name ) ;
                    
                    if f == false
                        continue ;
                    end
                    
                    [ dr dB_peak dB_rms ] = compute_DR14( t.Y , t.Fs ) ;
                    
                    dr14(j,1).name = d(i).name ;
                    dr14(j,1).dr14 = dr ;
                    dr14(j,1).peak = dB_peak ;
                    dr14(j,1).rms = dB_rms ; 
                    j = j + 1 ;
                     
                end
                
            end
            
            drm.dr14 = dr14 ;
        end
        
        function odr = get.off_dr14( drm )
            odr = round( mean( [drm.dr14(:,1).dr14] ) ) ;
        end
        
        
        function str = print_dr( drm )
            
            nl = sprintf('\n') ;
            tb = sprintf('\t') ;
            
            str = ['----------------------------------------------------------------------------------------------' nl ];
            str = [str 'Analyzed folder: ' ] ;
            str = [str drm.name  nl ] ;
            str = [str '----------------------------------------------------------------------------------------------' nl ];
            str = [str 'DR' tb tb tb 'Peak' tb tb tb 'RMS' tb tb tb 'Filename' nl] ;
            str = [str '----------------------------------------------------------------------------------------------' nl ];
            
            dr_cnt = size( drm.dr14 ) ;
            for i = 1:dr_cnt
                str = [str sprintf('DR%d \t\t\t %.2f %s \t\t\t' , drm.dr14(i,1).dr14 , drm.dr14(i,1).peak , 'dB' ) ];
                str = [str sprintf( '%.2f %s \t\t\t %s \n' , drm.dr14(i,1).rms , 'dB' , drm.dr14(i,1).name ) ];
            end
            
            str = [str '----------------------------------------------------------------------------------------------' nl ];
            str = [str nl ] ;
            str = [str  sprintf( '%s\t%d\n' , 'Number of files:' , size(drm.dr14,1) ) ];
            str = [str  sprintf( '%s\t%d\n' , 'Official DR value:' , drm.off_dr14 ) ];
            str = [str nl ] ;
            str = [str '==============================================================================================' nl ];
            
        end
        
        
        function f = sprint_drm( drm , file_name )
            fid = fopen(file_name,'w');
            
            str = print_dr( drm ) ;
            fprintf(fid, '%s', str);
            
            fclose(fid) ;
        end
    end
    

    
end

