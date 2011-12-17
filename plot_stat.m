function plot_stat( t_stat )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    bar(t_stat.xout,t_stat.n)
    grid on 
    xlabel( 'dB' ) ;
    ylabel( 'bins' ) ;
end

