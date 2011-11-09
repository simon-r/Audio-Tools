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
        off_dr14
    end
    
    properties ( SetAccess = private , GetAccess = public )
        
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
        
        
        function scan_dir( drm , dir_name )
           if ~exist( dir_name , 'dir' )
               disp( 'error: directory not found.' )
               return ;
           end
           
           disp( 'start ... ' )
           
           drm.open( dir_name ) ;
           drm.scan() ;
                      
           f1 = fullfile( dir_name , 'dr14.txt' ) ;
           f2 = fullfile( dir_name , 'dr14_bbcode.txt' ) ;
           
           drm.fprint_drm( f1 , 'format' , 'txt' ) ;
           drm.fprint_drm( f2 , 'format' , 'bbcode' ) ;
           
           odr = sprintf( 'DR = %d' , drm.off_dr14 ) ;
           disp( odr ) ;
           disp( 'done .... ' ) ;
           
        end
        
        
        function close( drm )
            drm.is_open = false ;
        end
        
        
        function [dr14 f] = scan( drm , varargin )
            
            if not ( drm.is_open )
                return
            end
            
            dr14 = [] ;
            off_dr = 0 ;
            
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
                    
                    disp(  d(i).name ) ;
                    
                    [ dr dB_peak dB_rms ] = compute_DR14( t.Y , t.Fs ) ;
                    
                    dr14(j,1).name = d(i).name ;
                    dr14(j,1).dr14 = dr ;
                    dr14(j,1).peak = dB_peak ;
                    dr14(j,1).rms = dB_rms ; 
                    j = j + 1 ;
                     
                    off_dr = off_dr + dr ;
                end
                
            end
            
            drm.off_dr14 = round( off_dr / j ) ;
            drm.dr14 = dr14 ;
        end
        
        
%         function odr = get.off_dr14( drm )
%             t = [drm.dr14(:,1).dr14] ;
%             odr = round( mean( t ) ) ;
%         end


        function str = print_dr( drm , varargin )
            
            nl = sprintf('\r\n') ;
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
                str = [str sprintf( '%.2f %s \t\t\t %s \n' , drm.dr14(i,1).rms , 'dB' , drm.dr14(i,1).name ) nl ];
            end
            
            str = [str '----------------------------------------------------------------------------------------------' nl ];
            str = [str nl ] ;
            str = [str  sprintf( '%s\t%d\n' , 'Number of files:' , size(drm.dr14,1) ) ];
            str = [str nl ] ;
            str = [str  sprintf( '%s\t%d\n' , 'Official DR value:' , drm.off_dr14 ) ];
            str = [str nl ] ;
            str = [str '==============================================================================================' nl ];
            
        end
        
        
        function str = print_tab_dr( drm , varargin )
            
            nl = sprintf('\r\n') ;
            tb = sprintf('\t') ;
            
            table_beg = sprintf( '[table]' ) ;
            table_end = sprintf( '[/table]' ) ;
            
            tr_beg = sprintf( '[tr]' ) ;
            tr_end = sprintf( '[/tr]' ) ;
            
            td_beg = sprintf( '[td]' ) ;
            td_end = sprintf( '[/td]' ) ;
            
            bold_beg = sprintf( '[b]' ) ;
            bold_end = sprintf( '[/b]' ) ;
            
            
            sep_row = [ tr_beg nl td_beg '-------------------' td_end ...
                td_beg '-------------------' td_end ... 
                td_beg '-------------------' td_end ... 
                td_beg '--------------------------------------' td_end nl tr_end nl ] ;
            
            str = ['----------------------------------------------------------------------------------------------' nl ];
            str = [str bold_beg 'Analyzed folder:    ' ] ;
            str = [str drm.name bold_end nl ] ;
            str = [str '----------------------------------------------------------------------------------------------' nl ];
            
            str = [str table_beg nl];
            
            str = [str sep_row ] ;
            
            str = [str tr_beg nl];
            str = [str td_beg 'DR' td_end td_beg 'Peak' td_end td_beg 'RMS' td_end td_beg 'Filename' td_end nl] ;
            str = [str tr_end nl];
            
            str = [str sep_row ] ;
            
            dr_cnt = size( drm.dr14 ) ;
            for i = 1:dr_cnt
                str = [str tr_beg nl] ;
                str = [str sprintf('%s DR%d %s %s %.2f %s %s %s ' , td_beg , ...
                    drm.dr14(i,1).dr14 , td_end , td_beg , drm.dr14(i,1).peak , 'dB' , td_end , td_beg ) ];
                str = [str sprintf( '%.2f %s %s %s %s %s' , drm.dr14(i,1).rms , 'dB' , ...
                    td_end , td_beg , drm.dr14(i,1).name  , td_end ) nl ];
                str = [str tr_end nl] ;
            end
            str = [str sep_row ] ;
            str = [str table_end nl];
            
            str = [str '----------------------------------------------------------------------------------------------' nl ];
            str = [str nl ] ;
            str = [str  sprintf( '%s\t%d\n' , 'Number of files:' , size(drm.dr14,1) )];
            str = [str nl ] ;
            str = [str  sprintf( '%s %s\t%d %s \n' , bold_beg , 'Official DR value:' , drm.off_dr14 , bold_end ) ];
            str = [str nl ] ;
            str = [str '==============================================================================================' nl ];
            
        end
        
        function f = fprint_drm( drm , file_name , varargin )
            
            p = inputParser ;
            p.addParamValue('format', 'txt' , @(x)strcmpi(x,'txt') || ...
                strcmpi(x,'bbcode') ) ;
            
            p.parse(varargin{:});
            
            fid = fopen(file_name,'w');
            
            if strcmpi( p.Results.format ,'txt' ) ;
                str = print_dr( drm ) ;
            elseif strcmpi( p.Results.format ,'bbcode' ) ;
                str = print_tab_dr( drm ) ;
            end
            
            fprintf(fid, '%s', str);
            
            fclose(fid) ;
        end
    end
    

    
end

