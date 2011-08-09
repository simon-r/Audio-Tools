function  plot_audio_fft( Y , FS , time_range , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


p = inputParser ;
p.addParamValue('min_freq', min_freq , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('max_freq', max_freq , @(x)isnumeric(x) && x > 0 ) ;
p.addParamValue('XScale', 'linear' , @(x)strcmpi(x,'linear') || ... 
    strcmpi(x,'log') ) ;
p.addParamValue('YScale', 'log' , @(x)strcmpi(x,'linear') || ... 
    strcmpi(x,'log') ) ;
p.addParamValue('phase', 'no' , @(x)strcmpi(x,'yes') || ... 
    strcmpi(x,'no') ) ;

p.parse(varargin{:});


[ s_f phase freq mm ] = audio_fft( Y , FS , time_range , 'smooth_lin' , 30 ) ;

% r = 1:floor(size(s_f,1)/2) ;

mx_freq = p.Results.max_freq ;
mn_freq = p.Results.min_freq ;

r = find( freq <= mx_freq & freq >= mn_freq ) ;

ch = size(s_f,2) ;

if strcmpi( p.Results.phase , 'no' )
    
    for j = 1:ch
        subplot( ch , 1 , j ) ;
        plot( freq(r) , s_f(r,j)/mm ) ;
        set( gca ,  'XScale' , p.Results.XScale , 'YScale' , p.Results.YScale ) ;
        ti = sprintf( 'Channel: %1.0f' , j ) ;
        title( ti ) ;
        xlabel('Freq: [Hz]') ;
        ylabel('Amplitude') ;
        
        grid on ;
    end
    
else
    
    for j = 1:ch
        subplot( ch , 1 , j ) ;
        [ax,h1,h2] = plotyy( freq(r) , s_f(r,j)/mm  , freq(r) , phase(r) ) ;
        set( ax(1) , 'XScale' , p.Results.XScale ) ;
        set( ax(2) , 'YScale' , p.Results.YScale ) ;
        
        set( ax(2) , 'YScale' , 'linear' ) ;
        
        set(get(ax(1),'Ylabel'),'String','Amplitude') 
        set(get(ax(2),'Ylabel'),'String','phase') 
        
        ti = sprintf( 'Channel: %1.0f' , j ) ;
        title( ti ) ;
        xlabel('Freq: [Hz]') ;
        ylabel('Amplitude') ;
        
        grid on ;
    end
    
end

end

