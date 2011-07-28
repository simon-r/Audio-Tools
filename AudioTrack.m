classdef AudioTrack
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = public , GetAccess = public )
        Y ;
        Fs = 44100 ;
    end
    
    properties ( Dependent = true, SetAccess = private , GetAccess = public)
        time
        channels
        samples
        period
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
    end
    
end

