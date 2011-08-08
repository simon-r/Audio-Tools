classdef AudioTrackMidi < AudioTrack
   
    properties ( SetAccess = private , GetAccess = private )
        notes_mat = [] ;
        sounds = Sound ;
    end
    
    properties ( Dependent = true, SetAccess = private , GetAccess = public )
        midi_channels ;
    end
    
    methods
        
        function midi_channels = get.midi_channels( obj )
            if isempty( obj.notes_mat ) 
                midi_channels = 0 ;
            else
                midi_channels = max( obj.notes_mat(:,3) ) ;
            end
        end
                
        
        function open( obj , file_name ) 
            obj.notes_mat = readmidi( file_name ) ;
            
            if length( obj.sounds ) == 1 
                obj.sounds(obj.midi_channels) = Sound ;
            elseif  length( obj.sounds ) < obj.midi_cahnnels
                obj.sounds(obj.midi_channels) = Sound ;
            end
            
        end    

        function set_sound( obj , snd , varargin )
            obj.sounds(:) = snd ;
        end
        
        [time clock] = midi2music( obj , varargin ) 
        
    end
    
end