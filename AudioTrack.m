classdef AudioTrack
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = public , GetAccess = public )
        Y ;
        Fs = 44100 ;
    end
    
    properties (Dependent = true, SetAccess = private , GetAccess = public)
        time
        channels
        samples
    end
    
    methods
        function obj = set.Y( obj , y )
            
        end
        
        function obj = set.Fs( obj , FS )
            if not( isscalar( FS ) || FS <= 0 )
                error('AudioTrack: Fs must be a positive scalar') ;
            end
        end
    end
    
end

