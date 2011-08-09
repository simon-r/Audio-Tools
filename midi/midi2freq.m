function [ f ] = midi2freq( m , varargin )
%MIDI2FREQ Summary of this function goes here
%   Detailed explanation goes here

if nargin >= 2 
    a = varargin{1} ;
    if a < 410 || a > 470
        error('the a should be included between 410 Hz and 470 Hz') ;
    end
else
    a = 440 ;
end

f = a/32 * 2.^((m-9)./12) ;

end

