function [ Y ] = shift_track( Y , D , varargin )
%[ Y ] = shift_track( Y , D )
%   schift Y of D samples.
%    D can be positive or nogative.
%   it return a new vector Y 
%
%  shift_track( Y , D , shape )
%
%    optional shape:
%             same: return a new Y with the same size of the original Y it
%                   remove the unused data
%             full: don't remove any data but simply prepend or append D
%                   zeros to Y
%

p = inputParser ;
p.addOptional( 'shape' , 'same' , @(x)strcmpi(x,'same') || ... 
    strcmpi(x,'full') ) ;

p.parse( varargin{:} ) ;

if strcmpi( p.Results.shape , 'same' )
    f = 1 ;
else
    f = 0 ;
end

sY = size( Y ) ;

ns = zeros( abs(D) , sY(2) ) ;

if D > 0
    Y = [ Y( (f*D+1):sY(1) , : ) ; ns ] ;
elseif D < 0
    Y = [ ns ; Y( 1:(sY(1)+f*D) , : ) ] ;
end

end

