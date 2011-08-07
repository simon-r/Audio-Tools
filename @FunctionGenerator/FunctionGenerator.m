classdef FunctionGenerator < hgsetget
    %FUNCTIONGENERATOR Abstract class that define the interface for an
    %arbitrary periodic function
    %   The method f implements an 2*pi periodic function
    
    properties
    end
    
    methods (Abstract)
        y = f( obj , x ) 
    end
    
end

