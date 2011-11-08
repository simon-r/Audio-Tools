function [ drO dB_peak dB_rms ] = compute_DRO( Y , FS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sizeY = size( Y ) ;
ch = sizeY(2) ;

block_time = 3 ;
block_samples = block_time * FS ;

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
    for j=1:ch
        
        rms(i,j) = decibel_u( u_rms( Y(r,j) , 1 ) , 1 ) ;
        
        p = decibel_u( max( abs( Y(r,j) ) ) , 1 ) ;
        peaks(i,j) = p ;
    end
    curr_sam = curr_sam + block_samples ;
end

drO = 1 ;

end

