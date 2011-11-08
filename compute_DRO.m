function [ drO dB_peak dB_rms hi ] = compute_DRO( Y , FS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sizeY = size( Y ) ;
ch = sizeY( 2 ) ;

block_time = 0.5 ;
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
    for j=1:ch
        
        rms(i,j) = decibel_u( u_rms( Y(r,j) , FS ) , 1 ) ;
        
        p = decibel_u( max( abs( Y(r,j) ) ) , 1 ) ;
        peaks(i,j) = p ;
    end
    curr_sam = curr_sam + block_samples ;
end

Ydr = mean ( peaks - rms , 2 ) ;

[n bins] = hist( Ydr , 100 ) ;

hi.on = n ;
hi.obins = bins ;

max_freq = max( n ) ;
i = find( n > max_freq*threshold ) ;

n = n(i) ;
bins = bins(i) ;

%bar(bins,n) ;

hi.bins = bins ;
hi.n = n ;

m = sum( n.*bins ) / sum( n ) ;

sdev = sqrt( sum( n.*( bins - m ).^2 ) / sum( n ) ) ;

drO = round ( ( m - 3 ) * 1 ) ;

dB_peak = max( max( peaks ) ) ;
dB_rms = decibel_u( u_rms( sum(Y,2) , FS ) , 1 ) ;

end

