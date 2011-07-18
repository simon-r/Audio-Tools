in_file = 'r_o.mp3' ;
out_file = 'r_e.wav' ;

[Y,FS,NBITS,OPTS] = mp3read( in_file );

%Y = equalizer( Y , FS , [0 500 1000 2000 5000 8000 12000 17000 20000 22100] , [-0 0 -2 -3 -3 -3 -4 -5 -5 -5] );
% clear;
% return ;
%
%
%
%
%c_x = [0.1:0.1:1] ;
%c_dB = [ 0 0 -0.5 -1.5 -2.5   -3.5   -4.5   -5.5   -6.5   -7.2];

c_x = [0.01:0.01:1] ;
c_dB = ( 1*(exp(2.05*c_x)-1) );

c_x = [0.1:0.1:1] ;
c_dB = 1.5*[0  1  2  3  4  5  6   7   8   9];

%
[com_music c_fx c_fy] = dyn_compression ( Y , c_x , c_dB ) ;
%
 plot( c_fx , c_fy ) ; grid on ;
% grid on ;

wavwrite( com_music , FS , NBITS , out_file ) ;

%clear ;
