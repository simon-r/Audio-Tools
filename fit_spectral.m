function [ spr g ] = fit_spectral( ref_spr , spr , freq , varargin)
%[ spr g ] = fit_spectral( ref_spr , spr , freq )
%   move spr along the gain axis such that the the squared difference
%   between ref_spr and spr is minimized.
%
%   Arguments:
%      ref_spr: n-by-channels matrix that stores the reference spectra
%      spr:     n-by-channels matrix that stores the movable spectra
%      freq:    a n-by-1 vector that stores the frequancies.
%
%   Returns:
%      spr: the fitted spectra.
%      g: 1-by-channels vector that stores the differences the new spr 
%         and the old one.


p = inputParser ;
p.addOptional( 'freq_limit' , [min_freq max_freq] , @(x)isnumeric(x) ) ;
p.parse( varargin{:} );

fl = p.Results.freq_limit ;

r = find( freq > fl(1) && freq < fl(2) ) ;
g = - ( spr(r) - ref_spr(r) ) / size(  spr(r) , 1 ) ;

for i=1:size(spr,2)
    spr(:,i) = spr(:,i) + g(:,i) ;
end

end

