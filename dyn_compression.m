function [com_music c_fx c_fy]= dyn_compression ( Y , c_x , c_dB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if size (c_x) ~= size(c_dB)
    error( 'the size of c_x and c_dB is not equal!' ) ;
end

[samples channels] = size(Y) ;
if channels > 10
    error( 'too many audio channels' ) ;
end

r_y = c_x .* 10.^(c_dB/20) ;

mc_x = -fliplr( c_x ) ;
c_x = [mc_x 0 c_x] ;

mr_y = -fliplr( r_y ) ;
c_y = [mr_y 0 r_y] ;

spl = spline( c_x , c_y ) ;

com_music = zeros( [samples channels] ) ;

for i=1:channels
    com_music(:,i) = ppval(spl,Y(:,i))' ;
end

Y_mabs = stereo_max( Y ) ;
C_mabs = stereo_max( com_music ) ;

com_music = com_music * ( Y_mabs / C_mabs ) ;

c_fx = [-1:0.01:1] ;
c_fy = ppval(spl,c_fx)' ;

end

% function m = stereo_max( X , channels )
% 
% for i = 1:channels
%     mv(i) = max ( abs( X(:,i) ) ) ;
% end
% 
% m = max( mv ) ;
% end

