function [ dB freq h ] = test_speaker_response( varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

test_t = AudioTrack ;
test_t.noise( 15 , test_t.Fs , 'pink' , 1 ) ;

res_t = play_and_rec( test_t ) ;

res_t.Y = res_t.Y * u_rms( test_t.Y , 44100 ) /  u_rms( test_t.Y , 44100 ) ;

d = find_tracks_shifting( test_t.Y , res_t.Y , 330000 , 50000 , 70000 ) ;
res_t.Y = shift_track( res_t.Y , d ) ;

[ dB freq h ] = spectral_comparison( res_t.Y , test_t.Y , test_t.Fs , [0 15] , 'plot' , 'yes' ) ;

end
 
