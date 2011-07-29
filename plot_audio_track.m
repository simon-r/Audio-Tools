function [ h ] = plot_audio_track( Y , FS , varargin )
%plot_audio_track plot an audio track
%   Detailed explanation goes here

p = inputParser ;
p.addParamValue('add_clipping', 0 , @(x)isnumeric(x) ) ;
p.addParamValue('add_silence', 0 , @(x)isnumeric(x) ) ;
p.parse(varargin{:});


sY = size( Y ) ;
h = zeros( sY(2) , 1 ) ;

main_plot_audio_track() ;


if p.Results.add_clipping ~= 0
    plot_clipping()
end


    function main_plot_audio_track
        t = 1/FS ;
        
        
        time = t * (0:(sY(1)-1)) ;
        
        max_sam = 20000 ;
        
        if sY(1) > max_sam
            r = find( mod( 1:sY(1) , floor( sY(1) / max_sam ) ) == 1 ) ;
        else
            r = 1:sY(1) ;
        end
        
        for i=1:sY(2)
            subplot( sY(2) , 1 , i ) ;
            plot( time(r) , Y(r,i) ) ;
            h(i) = gca ;
            grid on ;
            ti = sprintf( 'Channel: %1.0f' , i ) ;
            title( ti ) ;
            xlabel('Time: [Sec]') ;
            ylabel('Amplitude') ;
        end
    end

    function plot_clipping
        % Matrix format:
        % C [ channel sample_begin sample_end time_begin time_end clip_sign ]
        sC = size( p.Results.add_clipping ) ;
        
        for i=1:sC(1)
            curr_clip = p.Results.add_clipping(i,:) ;
            axes( h( curr_clip(1) ) ) ;
            
            p_clip = curr_clip(4) + ( curr_clip(5) - curr_clip(4) ) / 2 ;
            Xl = [p_clip p_clip] ;
            Yl = get( h( curr_clip(1) ) , 'YLim' ) ;
            line( Xl , Yl , 'Color' , 'Red' ) ;         
        end
    end


end

