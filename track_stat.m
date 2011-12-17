function [ t_stat ] = track_stat( Y , FS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sY = size( Y ) ;
delta_t = 0.1 ;

p = fix( FS * delta_t ) ;

r = 1:p ;

steps = fix( sY(1) / p ) ;
v_rms_db = zeros( steps + 1 , sY(2) ) ;

for i = 1:steps
    [foo v_rms_db(i,:)] = u_rms( Y(r,:) , FS ) ;
    r = (i*p+1):((i+1)*p) ;
end

    uc_indx = not( isinf( v_rms_db ) ) ;
    
    u_indx = uc_indx(:,1) ;
    
    for i = 2:size(u_indx,2)
        u_indx = and( u_indx , uc_indx(:,i) ) ;
    end
    
    [t_stat.n t_stat.xout] = hist( v_rms_db(u_indx,:) , 100 ) ;
    
    t_stat.avg = mean( v_rms_db(u_indx,:) ) ;
    t_stat.std = std( v_rms_db(u_indx,:) ) ;
end

