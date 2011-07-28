classdef AudioTrack < hgsetget
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = public , GetAccess = public )
        Y ;
        Fs = 44100 ;
        nbits ;
    end
    
    properties ( Dependent = true, SetAccess = private , GetAccess = public )
        time
        channels
        samples
        period
    end
    
    properties ( SetAccess = private , GetAccess = private )
        player
    end
    
    methods
        function obj = set.Y( obj , y )
            s = size(y) ;
            if s(2) > 15 
                error('AudioTrack: too many channels') ;
            end
            obj.Y = y ;
        end
        
        function obj = set.Fs( obj , FS )
            if not( isscalar( FS ) || FS <= 0 )
                error('AudioTrack: Fs must be a positive scalar') ;
            end
            obj.Fs = FS ;
        end
        
        function ch = get.channels( obj )
            ch = size( obj.Y , 2 ) ;
        end
        
        function s = get.samples( obj )
            s = size( obj.Y , 1 ) ;
        end
        
        function t = get.time( obj )
            t = obj.samples * (1/obj.Fs) ;
        end
        
        function T = get.period( obj )
            T = 1 / obj.Fs ;
        end
        
        function open( at , file_name ) 
            if not ( isempty( regexp( file_name , '\.wav$', 'once' ) ) )
                [ at.Y at.Fs at.nbits ] = wavread( file_name ) ;
            elseif not ( isempty( regexp( file_name , '\.mp3$', 'once' ) ) )
                [ at.Y at.Fs at.nbits ] = mp3read( file_name ) ;
            elseif not ( isempty( regexp( file_name , '\.flac$', 'once' ) ) )
                [ at.Y at.Fs at.nbits ] = flacread2( file_name ) ;
            end
        end
        
        function write( at , file_name )
            wavwrite( at.Y , at.Fs , at.nbits , file_name ) ;
        end
        
        function plot_audio_fft( at , time_range , varargin )
            plot_audio_fft( at.Y , at.Fs , time_range , varargin{:} ) ;
        end

        function plot_audio_time_fft( at , time_range , n , varargin )
            plot_audio_time_fft(  at.Y , at.Fs , time_range , n , varargin{:} )
        end 
        
        function play( at )
            at.player = audioplayer( at.Y , at.Fs ) ; 
            play ( at.player ) ;
        end
        
        function stop( at )
            stop( at.player ) ;
        end
    end
    
end

