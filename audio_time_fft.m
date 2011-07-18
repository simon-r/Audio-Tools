function [ time_sf freq time peak samples_nr] = audio_time_fft( Y , FS , time_range , n , smooth )
% [ time_sf freq time peak samples_nr] = audio_time_fft( Y , FS , time_range , n , smooth )
% Aguments:
% Y: audio track 
% time_range: interval of the first alalyzed section.
% n: nr. of analyzed sections
% smooth: smooth ratio of the spectra.
%
% returns:
% time_sf: ( n x sample_nr x channels ) matrix that stores the resulting spectals.
% freq: a vector of size sample_nr that store the fequncies of time_sf
% time: a vector of size n that stores the times for each section.
% peak: absolute maximal amplitude.
% sample_nr: number of saples for easch section
% example: 
% audio_time_fft( Y , 44100 , [0 0.1] , 200 ) ;
%
% see also: plot_audio_time_fft

if time_range(2) < time_range(1)
    error('error: negative time range') ;
end

if time_range(2) < 0 || time_range(1) < 0 
    error('error: the values in time range must be positives') ;
end

t = 1/FS ;

s_begin = floor( time_range(1) / t ) + 1 ;
s_end = floor(  time_range(2) / t ) + 1 ;

start_sample = s_begin ;
samples_nr = s_end - s_begin ;

time =  time_range(1) + (time_range(2) - time_range(1)) * (1:n) ;

ch = size(Y,2) ;
time_sf = zeros(n,samples_nr,ch) ;

p = 1 ;
for j=1:n
    end_sample = start_sample + samples_nr - 1 ;
    s = Y( start_sample:end_sample , : ) ;
    s_f = fft( s ) ;
    s_f = abs( s_f ) ;
    
    for i=1:ch
        s_f(:,i) = fastsmooth( s_f(:,i) , smooth , 1 , 1 ) ;
        m(p) = max( abs(s_f(:,i) ) ) ;
        p = p + 1 ;
    end
    
    time_sf(j,:,:) = s_f ;
    start_sample = start_sample + samples_nr ;
end

peak = max( m ) ;
freq = ( FS / samples_nr ) * [0:(samples_nr-1)] ;

end

