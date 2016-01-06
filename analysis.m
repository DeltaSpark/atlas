% MATLAB Script file that will compare each geofence to the entire array of
% impressions to check if they're within their boundaries

% Load fences and impressions from .mat file
load fences.mat
load impressions.mat

% Debug: Notification that script is calculating box boundaries for the
% geofence
disp('Calculating box boundaries for geofences...');

% Expands the fence matrix to get ready for insertion of delta latitude
% (col 4), delta longitude (col 5), and number of matched impressions (col
% 6)
numFences = length(fences);
fences(:,4:6) = zeros(numFences,3);

% Loops to calculate the delta latitude and longitude based on geofence
% radius using a reversed Haversine formula (the proximity function)
for i = 1:numFences
    [dlat, dlon] = proximity(fences(i,1), fences(i,2), fences(i,3));
    fences(i,4) = dlat; fences(i,5) = dlon;
end

% Expands the impressions matrix to get ready for insertion of the number
% of matched geofences (col 3)
numImpressions = length(impressions);
impressions(:,3) = zeros(numImpressions,1);

% Opens waitbar with progress bar for geofence/impression matching
h = waitbar(0,'Checking impressions for each geofence...');

% Test each geofence against the entire set of impressions
for j = 1:numFences
    % Defines the min/max latitude/longitude that could match to the fence
    minLat = fences(j,1) - fences(j,4); maxLat = fences(j,1) + fences(j,4);
    minLon = fences(j,2) - fences(j,5); maxLon = fences(j,2) + fences(j,5);
    
    % Returns a boolean array of 1:length(fences) whether row matches the
    % min/max latitude/longitude
    rowBool = (impressions(:,1) >= minLat & impressions(:,1) <= maxLat & impressions(:,2) >= minLon & impressions(:,2) <= maxLon);
    
    % Returns just the indexes of all rows in rowBool that are true (i.e.
    % matched the min/max latitude/longitude
    rowIndex = find(rowBool);
    
    % Loops through each of the available indexes and uses the Haversine
    % formula to confirm that the coordinate is within the radius of the
    % geofence, increments counters for geofences and impressions
    for k = 1:length(rowIndex)
        if haversine(fences(j,1),fences(j,2),impressions(rowIndex(k),1),impressions(rowIndex(k),2)) <= fences(j,3)
            fences(j,6) = fences(j,6) + 1;
            impressions(rowIndex(k),3) = impressions(rowIndex(k),3) + 1;
        end
    end
    
    % Updates waitbar
    waitbar(j / numFences, h)
end

% Closes waitbar
close(h)

% Calculates the percent of impressions that matched w/ >= 1 geofence
impressionsMatched = length(find(impressions(:,3))) / length(impressions);
fprintf('%.4f of impressions matched at least 1 geofence.\n',impressionsMatched);

% Calculates the percent of geofences that matched w/ >= 1 impression
fencesMatched = length(find(fences(:,6))) / length(fences);
fprintf('%.4f of geofences matched at least 1 impression.\n',fencesMatched);

% Garbage collection to remove variables local to script
clear dlat dlon h i j k maxLat maxLon minLat minLon numFences numImpressions rowBool rowIndex