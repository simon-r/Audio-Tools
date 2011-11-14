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

if FS == 44100
    delta_sample = 60 ;
else
    delta_sample = 0 ;
end

block_samples = block_time * ( FS + delta_sample) ;

seg_cnt = floor( sizeY(1) / block_samples ) + 1 ;

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

for i=1:(seg_cnt-1)
    r = curr_sam:(curr_sam+block_samples-1) ;
    rms(i,:) = dr_rms( Y(r,:) ) ;
    peaks(i,:) = max( abs( Y(r,:) ) ) ;
    curr_sam = curr_sam + block_samples ;
end

r=curr_sam:sizeY(1) ;
rms(seg_cnt,:) = dr_rms( Y(r,:) ) ;
peaks(seg_cnt,:) = max( abs( Y(r,:) ) ) ;


peaks = sort( peaks ) ;
rms = sort( rms ) ;

n_blk = floor( seg_cnt * cut_best_bins ) ;
if n_blk == 0
    n_blk = 1 ;
end

r = (seg_cnt-n_blk+1):seg_cnt ;
rms_sum = sum(  ( rms(r,:) ).^2 , 1 ) ;

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



