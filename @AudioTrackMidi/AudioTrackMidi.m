classdef AudioTrackMidi < AudioTrack
   
    properties ( SetAccess = private , GetAccess = private )
        notes_mat ;
        midi ;
        sounds = Sound ;
    end
    
    methods
        
        function open( obj , file_name ) 
            obj.notes_mat = readmidi( file_name ) ;
        end
        
        function ch = get_midi_channels_cnt( obj ) 
            ch = max( obj.notes_mat(3,:) ) ;
        end
        
        function set_sound( obj , snd )
            obj.sounds = snd ;
        end
        
        [time clock] = midi2music( obj , varargin ) 
        
    end
    
end