classdef TestSpeakerResponse < hgsetget
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = public , GetAccess = public )
        RefT
    end
    
    properties ( SetAccess = private , GetAccess = public )
        ResT
        
        play_times = [] ;
        rec_times = [] ;
    end
    
    properties ( SetAccess = private , GetAccess = private )
        player ;

        play_cnt = 1 ;           
        rec_cnt = 1 ;
        
        TimerPeriod = 0.5 ;
    end
    
    methods
        
        function obj = TestSpeakerResponse( varargin ) 
            obj.RefT = AudioTrack ;
            obj.ResT = AudioTrack ;
        end
        
        function obj = set.RefT( obj , Y )
            if isa( Y , 'AudioTrack' )
                obj.RefT = Y ;
            else
                error( 'set.RefT: Y must be an object of type AudioTrack' ) ;
            end
        end
        
        function run_test( obj )
            obj.play_cnt = 1 ;
            obj.play_times = zeros( floor( obj.RefT.time / obj.TimerPeriod ) + 2 , 2 ) ;
            obj.rec_times  = obj.play_times ;
            
            tic ;
            obj.play_ref ;
        end
        
 
    end
    
    methods ( Access = private )
        
        function play_ref( obj )
            obj.player = audioplayer( obj.RefT.Y , obj.RefT.Fs ) ;
            set ( obj.player , 'StartFcn' , @obj.play_callback ) ;
            set ( obj.player , 'TimerPeriod' , 0.5 ) ;
            set (  obj.player , 'TimerFcn' , @obj.play_callback ) ;
            set (  obj.player , 'StopFcn' , @obj.play_callback ) ;
            
            play ( obj.player ) ;
        end   
        
        function play_callback( obj , varargin)
            obj.play_times(obj.play_cnt,1) = toc ;
            obj.play_times(obj.play_cnt,2) = obj.player.CurrentSample ;
            obj.play_cnt = obj.play_cnt + 1 ;
        end
    end
        
end

