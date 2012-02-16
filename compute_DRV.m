function [ drV dB_peak dB_rms hi ] = compute_DRV( Y , FS )
%compute_DRV compute the DRV of an audio track
%   this procedure measure the dynamic vivacity of an audio track.
%
% Input args:
%       Y: an audio track (samples by channels)
%       FS: sampling rate 
%
% return:
%   drV:  drV value
%   dB_peak: the largest value of the track (in dB)
%   dB_rms: the Urms of the track (in dB).
%
% Copyright (c) 2011 Simone Riva

sizeY = size( Y ) ;
ch = sizeY( 2 ) ;

block_time = 1 ;
block_samples = block_time * FS ;

threshold = 0.15 ;

seg_cnt = floor( sizeY(1) / block_samples ) ;

if seg_cnt < 3
    % track too short.
    drO = 0 ;
    dB_peak = -100 ;
    dB_rms = -100 ;
    return ;
end

rms = zeros( seg_cnt , ch ) ;
peaks = zeros( seg_cnt , ch ) ;

curr_sam = 1 ;

for i=1:seg_cnt
    r = curr_sam:(curr_sam+block_samples-1) ;
    
    %for j=1:ch
    rms(i,:) = decibel_u( u_rms( Y(r,:) , FS ) , 1 ) ;    
    p = decibel_u( max( abs( Y(r,:) ) ) , 1 ) ;
    peaks(i,:) = p ;
    %end
    
    curr_sam = curr_sam + block_samples ;
end

Ydr = mean ( peaks - rms , 2 ) ;

[n bins] = hist( Ydr , 100 ) ;

max_freq = max( n ) ;
i = find( n > max_freq*threshold ) ;

n = n(i) ;
bins = bins(i) ;

% mb = mean( bins ) ;
% 
% i = find( bins > mb ) ;
% 
% n = n(i) ;
% bins = bins(i) ;

%bar(bins,n) ;

hi.bins = bins ;
hi.n = n ;

m = sum( n.*bins ) / sum( n ) ;

sdev = sqrt( sum( n.*( bins - m ).^2 ) / sum( n ) ) ;

drV = round ( ( m - 3 ) ) ;

dB_peak = max( max( peaks ) ) ;
dB_rms = decibel_u( u_rms( sum(Y,2) , FS ) , 1 ) ;

end

