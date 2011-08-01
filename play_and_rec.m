function [ recTr ] = play_and_rec( Tr , varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


ID = -1 ;

recorder = audiorecorder( Tr.Fs , Tr.nbits , Tr.nchannels , ID ) ;
player = audioplayer( Tr.Y , Fs , Tr.nbits  ) ;

play ( player ) ;

disp('Start recording.')
recordblocking(recorder, Tr.time);
disp('End recording.');

recTr = AudioTrack ;

recTr.Y = getaudiodata( recorder );

recTr.Fs = Tr.Fs ;
recTr.nbits = Tr.nbits ;

end

