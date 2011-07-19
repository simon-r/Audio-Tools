function m = stereo_max( Y )

mv = zeros( size(y,2) , 1 ) ;

for i = 1:size(Y,2)
    mv(i) = max ( abs( Y(:,i) ) ) ;
end

m = max( mv ) ;
end

