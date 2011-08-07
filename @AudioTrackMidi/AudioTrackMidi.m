classdef AudioTrackMidi < AudioTrack
   
    properties ( SetAccess = private , GetAccess = private )
        notes_mat ;
        midi ;
    end
    
    methods
        
        function open( obj , file_name ) 
            obj.midi = readmidi( file_name ) ;
        end
        
        [ time ] = midi2music( obj , varargin ) 
        
    end
    
end