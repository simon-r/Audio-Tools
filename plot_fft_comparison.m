function [ h ] = plot_fft_comparison( ref_fft , com_fft , freq , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

p = inputParser ;
p.addOptional( 'freq_limit' , max_freq() , @(x)isnumeric(x) ) ;
p.parse( varargin{:} );

freq_limit = p.Results.freq_limit ;

r = find ( freq < freq_limit ) ;

sM = size( ref_fft ) ;

m_f = mean( ref_fft ) ;

h = gca ;

for i=1:sM(1)
    
    c_f = mean( com_fft(i,r) ) ;
    
    subplot(sM(1),1,i) ;
    plot( freq(r) , 20*log10( (m_f/c_f)*com_fft(i,r)./ref_fft(r) ) , 'Color' , 'blue' ) ;
    set( gca , 'YScale' , 'lin' , 'XScale' , 'lin' ) ;
    xlabel('Freq [Hz]') ;
    ylabel('dB') ;
    legend('Spectral deviation in dB');
    grid on ;
end


end

