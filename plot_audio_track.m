function [ h ] = plot_audio_track( Y , FS , varargin )
%plot_audio_track plot an audio track
%   Detailed explanation goes here

p = inputParser ;
p.addParamValue('add_clipping', 0 , @(x)isnumeric(x) ) ;
p.addParamValue('add_silence', 0 , @(x)isnumeric(x) ) ;
p.parse(varargin{:});


sY = size( Y ) ;
h = zeros( sY(2) , 1 ) ;
player = [] ;
st_m = [] ;
play_line = [] ;

play_time = 0 ;
play_delta_time = 0.25 ;
play_state = false ;

max_time = sY(1) * (1/FS) ;

% Add tracks
ln = 1 ;
main_plot_audio_track() ;
leggend_titles{ln} = 'Track' ;

% Add clipping signs if required 
if p.Results.add_clipping ~= 0
    plot_line_sign( p.Results.add_clipping , 'Red' ) ;
    ln = ln + 1 ;
    leggend_titles{ln} = 'Clipping' ;
end

% Add silence signs if required 
if p.Results.add_silence ~= 0
    plot_line_sign( p.Results.add_silence , 'Green' ) ;
    ln = ln + 1 ;
    leggend_titles{ln} = 'Silence' ;
end

% init player cursor
for i=1:sY(2)
    axes( h(i) ) ;
    play_line(i) = line( [0 0] , [-st_m st_m] , 'Color' , 'magenta' , ... 
        'ButtonDownFcn' , @player_drag_begin ) ;
end

axes( h(1) ) ;
legend( leggend_titles , 'Location' , 'NorthEast') ;


% Adding toolbar icons and callback
ht = uitoolbar;

play_button = add_toolbar_icon( ht , 'play.png' , 'Play' , @start_play ) ;

add_toolbar_icon( ht , 'stop.png' , 'Stop' , @stop_play ) ;

add_toolbar_icon( ht , 'pause.png' , 'Pause' , @pause_play ) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks & functions 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function main_plot_audio_track 
        t = 1/FS ;
        
        
        time = t * (0:(sY(1)-1)) ;
        
        max_sam = 20000 ;
        
        if sY(1) > max_sam
            r = find( mod( 1:sY(1) , floor( sY(1) / max_sam ) ) == 1 ) ;
        else
            r = 1:sY(1) ;
        end
        
        st_m = stereo_max( Y ) ;
        st_m = ( floor( st_m * 10 ) ) / 10 ;
        
        for i=1:sY(2)
            subplot( sY(2) , 1 , i ) ;
            plot( time(r) , Y(r,i) ) ;
            h(i) = gca ;
            set( h(i) , 'YLim' , [-st_m st_m] ) ;
            grid on ;
            ti = sprintf( 'Channel: %1.0f' , i ) ;
            title( ti ) ;
            xlabel('Time: [Sec]') ;
            ylabel('Amplitude') ;
        end
    end

    function plot_line_sign( sg , s_color ) 
        % Matrix format:
        % C [ channel sample_begin sample_end time_begin time_end ]
        sC = size( sg ) ;
        ch = max( sg(:,1) ) ;
        
        for j=1:ch
            indx = find ( sg(:,1) == j ) ;
            axes( h( j ) ) ;
            Yl = get( h( j ) , 'YLim' ) ;
            
            XD = zeros( 2 , size(indx,1) ) ;
            YD = XD ;
            
            for i=1:size(indx,1)
                curr_clip = sg(indx(i),:) ;
                p_clip = curr_clip(4) + ( curr_clip(5) - curr_clip(4) ) / 2 ;
                Xl = [p_clip p_clip] ;
                XD(:,i) = Xl ;
                YD(:,i) = Yl ;
                
            end
            hSLines = line( XD , YD , 'Color' , s_color ) ;
            hSGroup = hggroup;
            set(hSLines,'Parent',hSGroup) ;
            set(get(get(hSGroup,'Annotation'),'LegendInformation'),...
                'IconDisplayStyle','on');
                     
            
        end
    end

    function start_play(varargin) 
        player = audioplayer( Y , FS ) ; 
        set( player , 'TimerPeriod' , play_delta_time , 'TimerFcn' , ...
            @timer_play , 'StopFcn' , @stop_play ) ;
        start_sample = floor(play_time*FS ) + 1 ;
        stop_sample = floor( max_time*FS ) ;
        play ( player , [start_sample stop_sample] ) ;
        set( play_button , 'Enable' , 'off' ) ;
        play_state = true ;
    end

    function timer_play(varargin) 
        play_time = play_time + play_delta_time ;
        Xl = [play_time play_time] ;
        for i=1:sY(2)
            set( play_line(i) , 'XData' , Xl );
        end
        %disp(play_time) ;
    end

    function stop_play(varargin) 
        stop( player ) ;
        play_time = 0 ;
        set( play_button , 'Enable' , 'on' ) ;
        for i=1:sY(2)
            set( play_line(i) , 'XData' , [play_time play_time] );
        end
        play_state = false ;
        
        % disp('stop') ;
    end

    function pause_play(varargin) 
        if play_state
            set( player , 'StopFcn' , [] ) ;
            pause( player ) ;
            play_state = false ;
        else
            set( player , 'StopFcn' , @stop_play ) ;
            resume( player ) ;
            play_state = true ;
        end
        
        %disp('pause') ;
    end

    function player_drag_begin(varargin) 
        set( gcf , 'WindowButtonMotionFcn' , @dragging_player_fcn ) ;
        set( gcf , 'WindowButtonUpFcn' , @stop_player_drag_fcn ) ;
    end

    function dragging_player_fcn( varargin ) 
        pt = get( h(1) , 'CurrentPoint' ) ;
        if  pt(1) < 0 || pt(1) > max_time
            return ;
        end
        
        for i=1:sY(2)
            set( play_line(i) , 'XData' , pt(1)*[1 1] );
            play_time = pt(1) ;
        end
    end

    function stop_player_drag_fcn(varargin) 
        set( gcf , 'WindowButtonMotionFcn' , '' ) ;
        if play_state
            stop_play ;
            dragging_player_fcn ;
            start_play ;
        end
    end

    function button_h = add_toolbar_icon( ht , icon_name , tooltip_string , callback ) 
        X = imread( fullfile( '.' , 'icons' , icon_name ) );
        
        icon = imresize( X , [16 16] ) ;
        
        button_h =  uipushtool(ht,'CData',icon,...
            'TooltipString', tooltip_string , ...
            'ClickedCallback', callback ) ;
    end
end

