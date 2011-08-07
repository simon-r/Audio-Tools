classdef SequenceFunction < FunctionGenerator
    %SEQUENCEFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = private , GetAccess = private )
        sinus_vect = [] ;
    end
    
    methods
        function y = f( obj , x ) 
            sx = size(x) ;
            tr = false ;
            if sx(2) < sx(1) 
                x = x' ;
                tr = true ;
            end
            
            cx = obj.sinus_vect(:,2)*x ;
            
            for i=1:length(x)
                cx(:,i) = cx(:,i) + obj.sinus_vect(:,3) ;
            end
            
            y = sin( cx ) ;
            
            for i=1:length(x)
                y(:,i) = obj.sinus_vect(:,1) .* y(:,i) ;
            end
            
            y = sum( y , 1 ) ;
            
            if tr 
                y = y' ;
            end
        end
        
        function add_sinus( obj , A , f , phi )
            new_sin = [ A f phi ] ;
            obj.sinus_vect = [ obj.sinus_vect ; new_sin ] ;
        end
        
    end
    
end

