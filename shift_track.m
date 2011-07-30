function [ Y ] = shift_track( Y , D , varargin )
%[ Y ] = shift_track( Y , D )
%   shift Y of D samples.
%    D can be positive or negative.
%    it return a new vector Y
%
%  shift_track( Y , D , shape )
%
%    optional shape:
%             same: return a new Y with the same size as the original Y it
%                   remove the unused data
%             full: remove or add as less as possible data; the size of the resulting
%                   vector is not equal to Y
%
%  see also: find_tracks_shifting

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
    if f == 0
        ns = [] ;
    end
    Y = [ Y( (D+1):sY(1) , : ) ; ns ] ;
elseif D < 0
    Y = [ ns ; Y( 1:(sY(1)+D*f) , : ) ] ;
end

end

