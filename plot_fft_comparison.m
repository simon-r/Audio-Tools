function [ h ] = plot_fft_comparison( com_fft , ref_fft , freq , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addParamValue( 'freq_limit' , [min_freq max_freq] , @(x)isnumeric(x) ) ;
p.parse( varargin{:} );

fl = p.Results.freq_limit ;

r = find( freq > fl(1) & freq < fl(2) ) ;

sM = size( com_fft ) ;

com_fft = fit_spectral( com_fft , ref_fft , freq , ... 
    'freq_limit' , fl ) ;

h = gca ;

for i=1:sM(2) 
    
    dB = decibel_u( com_fft(r,i) , ref_fft(r,i) ) ;
    dB = remove_complex( dB ) ;
    
    subplot(sM(2),1,i) ;
    plot( freq(r) , dB , 'Color' , 'blue' ) ;
    set( gca , 'YScale' , 'lin' , 'XScale' , 'lin' ) ;
    xlabel('Freq [Hz]') ;
    ylabel('dB') ;
    legend('Spectral deviation in dB');
    grid on ;
end


end

