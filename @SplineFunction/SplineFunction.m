classdef SplineFunction < FunctionGenerator
    %SPLINEFUNCTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties( SetAccess = private , GetAccess = private )
        vx ;
        vy ;
        cs ;
    end
    
    methods
        
        function set_values( obj , x , y )
            obj.vx = set_array( x ) ;
            obj.vy = set_array( y ) ;
            
            obj.cs = spline( x , y ) ;
        end
        
        function y = f( obj , x ) 
            r = find( x > 2*pi ) ;
            x(r) = x(r) - floor(x(r))*2*pi ;
            
            r = find( x < 0 ) ;
            x(r) =  x(r) + (floor(abs(x(r))/(2*pi))+1)*2*pi ;
            
            y = ppval( obj.cs , x ) ;
        end
        
        
        function set_trumpet( obj ) 
             x = [0 0.1 0.15 0.25 0.5 0.6 0.75 0.8 0.9 1] ;
             y = [0 0.7 0.8 0.7 0.65 0 -0.65 -0.6 -0.8 0] ;
             obj.set_values( x , y ) ;
        end
        
    end
    
end

