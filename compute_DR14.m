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
%   dr14: official dr14 value
%   dB_peak: the largest value of the track (in dB)
%   dB_rms: the Urms of the track (in dB).
%
% Copyright (c) 2011 Simone Riva


sizeY = size( Y ) ;
ch = sizeY(2) ;

block_time = 3 ;
block_samples = block_time * FS ;

seg_cnt = floor( sizeY(1) / block_samples ) ;

curr_sam = 1 ;

rms = zeros( seg_cnt , ch ) ;
peaks = zeros( seg_cnt , ch ) ;

for i=1:seg_cnt
    r = curr_sam:(curr_sam+block_samples-1) ;
    for j=1:ch
        
        rms(i,j) = decibel_u( dr_rms( Y(r,j) ) , 1 ) ;
        
        p = max( abs( Y(r,j) ) ) ;
        peaks(i,j) = p ;
    end
    curr_sam = curr_sam + block_samples ;
end

bins = -100:0.01:0 ;
bins_peak = 0:1e-04:1 ;

hist_rms = hist( rms , bins ) ;
hist_peaks = hist( peaks , bins_peak ) ;

ch_dr14 = zeros( ch , 1 ) ;

n_blk = floor( seg_cnt * 0.2 ) ;

for i = 1:ch

    indx_hp = find( hist_peaks(:,i) > 0 ) ;
    
    if size(indx_hp,1) > 1
        ref_peak_bin = indx_hp(size(indx_hp,1) - 1) ;
    else
        ref_peak_bin = indx_hp(size(indx_hp,1)) ;
    end
    
    indx_hrms = find( hist_rms(:,i) > 0 ) ;
    
    rms_sum = 0 ;
    rms_cum = 0 ;
    
    j = size( indx_hrms , 1 ) ;
    while rms_cum <= n_blk
        b_cnt = hist_rms(indx_hrms(j) , i ) ;
        
        rms_sum = rms_sum + 10^( bins( indx_hrms(j) ) / 20 )^2 * b_cnt ;
        rms_cum = rms_cum + b_cnt ;
        j = j - 1 ;
    end
    
    rms_sum = rms_sum / rms_cum ;
    
    ch_dr14(i) = -20 * log10( sqrt( rms_sum ) * (1/bins_peak(ref_peak_bin)) ) ;   
end


dr14 = round( mean( ch_dr14 ) ) ;

dB_peak = decibel_u( max( max( peaks ) ) , 1 ) ;
dB_rms = decibel_u( u_rms( sum(Y,2) , FS ) , 1 ) ;


    function r = dr_rms( y ) 
        r = sqrt ( 2 * sum( y.^2 ) / size( y , 1 ) ) ;
    end

end



