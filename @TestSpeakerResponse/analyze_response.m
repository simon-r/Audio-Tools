function [ dB freq h ] = analyze_response( obj , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

time = obj.RefT.time ;
Fs = obj.RefT.Fs ;

obj.ResT.Y = obj.ResT.Y * u_rms( obj.RefT.Y , Fs ) /  u_rms( obj.RefT.Y , Fs ) ;

test_center = floor( time * 1/3 * Fs ) ;
max_sh = 50000 ;

if max_sh > test_center / 2 
    max_sh = floor( test_center / 2.1 ) ;
end
    
test_size = floor( test_center / 2 ) ;

d = find_tracks_shifting( obj.RefT.Y , obj.ResT.Y , test_center , ...
    test_size , max_sh ) ;

res_t.Y = shift_track( obj.ResT.Y , d ) ;

[ dB freq h ] = spectral_comparison( obj.ResT.Y , obj.RefT.Y , Fs , ...
    [0  obj.RefT.time] , 'plot' , 'yes' ) ;

end

