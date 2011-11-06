function [ path f ] = locate_unix_cmd( cmd )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

whereis = sprintf( 'whereis -b %s' , cmd ) ;

[f s1] = system(whereis) ;
c1 = regexp(s1,' ','split') ;

if size(c1,2) == 1
    path = '' ;
    f = false ;
    return ;
end

f = true ;
path = strrep( c1{2} , sprintf('\n') , '' ) ;

end

