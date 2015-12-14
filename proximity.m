function [ dlat, dlon ] = proximity( lat, lon, radius_fence )
%PROXIMITY returns the delta lat, lon of a geofence
%   returns the delta lat, lon of possible impressions that would fall in
%   the geofence
%   aka the degrees from center of the box that surrounds the geofence

    % radius of the earth in meters
    radius_earth = 6371000;
    
    delta = radius_fence/radius_earth;

    % calculate delta lat
    [new_lat,~] = calculate_newpoint(lat, lon, delta, 0);
    dlat = abs(new_lat - lat);
    
    % calculate delta lon
    [~, new_lon] = calculate_newpoint(lat, lon, delta, 90);
    dlon = abs(new_lon - lon);

end

function [ lat_new, lon_new ] = calculate_newpoint( lat, lon, delta, bearing )
% CALCULATE_NEWPOINT returns a new lat, lon for a bearing and distance 
%   subfunction to help support the calculation

    lat_new = asind(sind(lat)*cos(delta) + cosd(lat)*sin(delta)*cosd(bearing));
    lon_new = lon + atan2(sind(bearing)*sin(delta)*cosd(lat), cos(delta)-sind(lat)*sind(lat_new));
    
end