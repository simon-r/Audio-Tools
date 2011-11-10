function [ dr14 dB_peak dB_rms ] = compute_DR14( Y , FS )
% compute_DR14 Compute the DR14 value according to the algorithm published
% by the Pleasurize Your Music foundation.
% for more details visit: http://www.pleasurizemusic.com/
%
% Input args:
%       Y: an audio track (samples by channels)
%       FS: sampling rate
%
% return:
%   dr14: 'official' dr14 value
%   dB_peak: the largest value of the track (in dB)
%   dB_rms: the Urms of the track (in dB).
%
% Copyright (c) 2011 Simone Riva

sizeY = size( Y ) ;
ch = sizeY(2) ;

block_time = 3 ;
cut_best_bins = 0.2 ;

block_samples = block_time * FS ;

seg_cnt = floor( sizeY(1) / block_samples ) ;

if seg_cnt < 3
    % track too short.
    dr14 = 0 ;
    dB_peak = -100 ;
    dB_rms = -100 ;
    return ;
end ;

curr_sam = 1 ;

rms = zeros( seg_cnt , ch ) ;
peaks = zeros( seg_cnt , ch ) ;

for i=1:seg_cnt
    r = curr_sam:(curr_sam+block_samples-1) ;
    rms(i,:) = decibel_u( dr_rms( Y(r,:) ) , 1 ) ;
    
    p = max( abs( Y(r,:) ) ) ;
    peaks(i,:) = p ;
    
    curr_sam = curr_sam + block_samples ;
end

peaks = sort( peaks ) ;
rms = sort( rms ) ;

n_blk = floor( seg_cnt * cut_best_bins ) ;
if n_blk == 0
    n_blk = 1 ;
end

r = seg_cnt:-1:(seg_cnt-n_blk+1) ;
rms_sum = sum(  ( 10.^( rms(r,:) / 20 ) ).^2 , 1 ) ;

rms_sum = rms_sum / n_blk ;

ch_dr14 = -20 * log10( sqrt( rms_sum ) .* (1./peaks(seg_cnt-1,:)) ) ;

err_i = ( rms_sum <  1/(2^24) ) ;
ch_dr14(err_i) = 0 ;

dr14 = round( mean( ch_dr14 ) ) ;

dB_peak = decibel_u( max( max( peaks ) ) , 1 ) ;
dB_rms = decibel_u( u_rms( sum(Y,2) , FS ) , 1 ) ;

    function r = dr_rms( y )
        r = sqrt ( 2 * sum( y.^2 ) / size( y , 1 ) ) ;
    end
end



