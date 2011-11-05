classdef AudioTrack < hgsetget
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = public , GetAccess = public )
        Y ;
        Fs = 44100 ;
        nbits = 16 ;      
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
    
    properties ( SetAccess = private , GetAccess = public )
        opts
    end
    
    methods
        
        function obj = AudioTrack( varargin )
            if size( varargin , 2 ) >= 1
                obj.Y = varargin{1} ;
            end
            
            if size( varargin , 2 ) >= 2
                obj.Fs = varargin{2} ;
            end
            
            if size( varargin , 2 ) == 3
                obj.nbits = varargin{3} ;
            end
        end
        
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
        
        function r = open( at , file_name )
            r = true ;
            if not ( isempty( regexp( file_name , '\.wav$', 'once' ) ) )
                [ at.Y at.Fs at.nbits at.opts] = wavread( file_name ) ;
            elseif not ( isempty( regexp( file_name , '\.mp3$', 'once' ) ) )
                [ at.Y at.Fs at.nbits at.opts] = mp3read( file_name ) ;
            elseif not ( isempty( regexp( file_name , '\.flac$', 'once' ) ) )
                [ at.Y at.Fs at.nbits at.opts] = flacread2( file_name ) ;
            elseif not ( isempty( regexp( file_name , '\.ogg$', 'once' ) ) )
                [ at.Y at.Fs at.nbits at.opts] = oggread( file_name ) ;
            else
                r = false ;
            end
        end
        
        function write( at , file_name )
            wavwrite( at.Y , at.Fs , at.nbits , file_name ) ;
        end
        
        function noise( at , time , FS , n_type , ch , varargin )
            at.Y = noise( time , FS , n_type , ch , varargin{:} ) ;
            at.Fs = FS ;
        end
        
        function frequency_sweep( at , time , FS , f_min , f_max  , varargin )
            at.Y = frequency_sweep( FS , f_min , f_max , time , varargin{:} ) ;
            at.Fs = FS ;
        end
        
        function [ dB freq h ] = spectral_comparison( at ,  at_ref , time_range , varargin )
            [ dB freq h ] = spectral_comparison( at.Y , at_ref.Y , at.Fs , time_range , varargin ) ;
        end
        
        function [ res , dB ] = u_rms( at , varargin )
            [ res , dB ] = u_rms( at.Y , at.Fs , varargin{:} ) ;
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

