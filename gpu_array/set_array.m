function [ Y ] = set_array( Y )
%%set_array do noting: it return Y 
%   this function can be replaced with gpuArray if you want the GPU

Y = gpuArray( Y ) ;
end

