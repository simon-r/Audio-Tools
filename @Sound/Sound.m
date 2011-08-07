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
        velocity = 63 ;
        Fs = 44100 ;
        
    end
    
    methods
        function obj = Sound( varargin )
            if nargin >= 1
                obj.fun = varargin{1} ;
            else
                obj.fun = @sin ;
            end
        end
        
        function Y = get_sound( obj )
            freq = midi2freq( obj.note , obj.a ) ;
            
            dB = decibel_u( obj.gain * (obj.velocity / 63.5 ) , 1 ) ;
            
            Y = frequency_sweep( obj.Fs , freq , freq , obj.time , ...
                'waveform_fun' , @obj.fun , 'gain' , dB ) ;
                      
            fade_in_time = obj.time / ( 10 * ( obj.velocity / 63.5 ) ) ;
            fade_out_time = obj.time / 5 ;
            
            Y = fade_in( Y , obj.Fs , fade_in_time ) ;
            Y = fade_out( Y , obj.Fs , fade_out_time ) ;
                        
        end
    end
    
end

