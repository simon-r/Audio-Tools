classdef Sound < hgsetget
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties( SetAccess = private , GetAccess = private )
        fun ;
    end
       
    properties( SetAccess = public , GetAccess = public )
        note = 69 ;
        a = 440 ;
        time = 1;
        gain = 0.3 ;
        acc = 90 ;
        Fs = 44100 ;
    end
    
    methods
        function obj = Sound( varargin )
            if nargin >= 1
                obj.fun = varargin{1} ;
            end
        end
        
        function Y = get_sound( obj )
            freq = midi2freq( obj.note , obj.a ) ;
            Y = frequency_sweep( obj.Fs , freq , freq , obj.time , ... 
                'waveform_fun' , @obj.fun.f , 'gain' , 1 ) ;
            
            Y = Y * obj.gain ;
        end
    end
    
end

