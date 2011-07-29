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
    play_line(i) = line( [0 0] , [-st_m st_m] , 'Color' , 'magenta' ) ;
end

axes( h(1) ) ;
legend( leggend_titles , 'Location' , 'NorthEast') ;

% Adding toolbar icons and callback
ht = uitoolbar;

[X map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','greenarrowicon.gif'));

% Convert indexed image and colormap to truecolor
icon = ind2rgb(X,map);
play_button = uipushtool(ht,'CData',icon,...
    'TooltipString','Play',...
    'ClickedCallback', @start_play ) ;

[X map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','greencircleicon.gif'));

icon = ind2rgb(X,map);
stop_button =  uipushtool(ht,'CData',icon,...
    'TooltipString','Stop',...
    'ClickedCallback', @stop_play ) ;

[X map] = imread(fullfile(...
    matlabroot,'toolbox','matlab','icons','greencircleicon.gif'));

icon = ind2rgb(X,map);
pause_button =  uipushtool(ht,'CData',icon,...
    'TooltipString','Pause',...
    'ClickedCallback', @pause_play ) ;


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
        set( player , 'TimerPeriod' , play_delta_time , 'TimerFcn' , @timer_play ) ;
        play ( player ) ;
        set( play_button , 'Enable' , 'off' ) ;
        play_state = true ;
    end

    function timer_play(varargin)
        play_time = play_time + play_delta_time ;
        Xl = [play_time play_time] ;
        for i=1:sY(2)
            set( play_line(i) , 'XData' , Xl );
        end
        disp(play_time) ;
    end

    function stop_play(varargin)        
        stop( player ) ;
        play_time = 0 ;
        set( play_button , 'Enable' , 'on' ) ;
        play_state = false ;
    end

    function pause_play(varargin)
        if play_state
            pause( player ) ;
            play_state = false ;
        else
            resume( player ) ;
            play_state = true ;
        end
    end
end

