function m = stereo_max( Y )

mv = zeros( size(Y,2) , 1 ) ;

for i = 1:size(Y,2)
    mv(i) = max ( set_gather( abs( Y(:,i) ) ) ) ;
end

m = max( mv ) ;

end

