function [ dB freq h ] = spectral_comparison( Y , Yref , FS , time_range , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addParamValue( 'freq_limit' , [min_freq max_freq] , @(x)isnumeric(x) ) ;
p.addParamValue( 'plot' , 'no' , @(x)strcmpi(x,'yes') || strcmpi(x,'no') ) ;
p.addParamValue( 'smooth' , 'no' , @(x)strcmpi(x,'smooth_log') || ...
    strcmpi(x,'smooth_lin') || strcmpi(x,'no') ) ;
p.addParamValue('smooth_w', 30 , @(x)isnumeric(x) && x > 0 ) ;

p.parse( varargin{:} ) ;

fl = p.Results.freq_limit ;

[com_fft phase freq] = audio_fft( Y , FS , time_range , p.Results.smooth , p.Results.smooth_w ) ;
[ref_fft] = audio_fft( Yref , FS , time_range , p.Results.smooth , p.Results.smooth_w ) ;

phase = [] ;

r = find( freq > fl(1) & freq < fl(2) ) ;

sM = size( com_fft ) ;
sR = size( ref_fft ) ;

com_fft = fit_spectral( com_fft , ref_fft , freq , ...
    'freq_limit' , fl , 'model' , 'mult' ) ;

if sR(2) == 1
    f = 0 ;
else
    f = 1 ;
end

dB = zeros( size(r,2) , sM(2) ) ;

for i=1:sM(2)
    dB(:,i) = decibel_u( com_fft(r,i) , ref_fft(r,i-(i-1)*f) ) ;
    dB(:,i) = remove_complex( dB(:,i) ) ;
end

freq = freq(r) ;

h = [] ;

if strcmpi( p.Results.plot , 'yes' )
   h = plot_db( freq , dB , 'freq' , 'FR Magnitude in dB' , 'Spectral comparison' ) ;
end

end

