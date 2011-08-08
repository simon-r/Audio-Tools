classdef SequenceFunction < FunctionGenerator
    %SEQUENCEFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties ( SetAccess = private , GetAccess = private )
        sinus_vect = [0 0 0] ;
        cosinus_vect = [0 0 0] ;
    end
    
    methods
        function y = f( obj , x ) 
            sizex = size(x) ;
            tr = false ;
            if sizex(2) < sizex(1) 
                x = x' ;
                tr = true ;
            end
            
            sx = obj.sinus_vect(:,2)*x ;
            cx = obj.cosinus_vect(:,2)*x ;
            
            for i=1:length(x)
                sx(:,i) = sx(:,i) + obj.sinus_vect(:,3) ;
                cx(:,i) = cx(:,i) + obj.cosinus_vect(:,3) ;
            end
            
            ys = sin( sx ) ;
            yc = cos( cx ) ;
            
            for i=1:length(x)
                ys(:,i) = obj.sinus_vect(:,1) .* ys(:,i) ;
                yc(:,i) = obj.cosinus_vect(:,1) .* yc(:,i) ;
            end
            
            ys = sum( ys , 1 ) ;
            yc = sum( yc , 1 ) ;
            
            y = ys + yc ;
            
            if tr 
                y = y' ;
            end
        end
        
        function add_sinus( obj , A , f , phi )
            new_sin = [ A f phi ] ;
            obj.sinus_vect = [ obj.sinus_vect ; new_sin ] ;
        end
        
        function add_cosinus( obj , A , f , phi ) 
            new_cos = [ A f phi ] ;
            obj.cosinus_vect = [ obj.cosinus_vect ; new_cos ] ;
        end
        
    end
    
end

