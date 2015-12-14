function [ distance ] = haversine( lat_1, lon_1, lat_2, lon_2 )
%HAVERSINE returns distance between two lat,lon points
%   Uses the haversine formula to calculate the great-circle distance
%   between two latitude, longitude points

    % radius of the earth in meters
    radius_earth = 6371000;
    
    dlat = lat_2 - lat_1;
    dlon = lon_2 - lon_1;
    
    a = sind(dlat/2)^2 + cosd(lat_1)*cosd(lat_2)*(sind(dlon/2)^2);
    c = 2*atan2(sqrt(a),sqrt(1-a));
    
    distance = radius_earth * c;
end