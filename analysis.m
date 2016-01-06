% Load fences and impressions from .mat file
load fences.mat
load impressions.mat

% Debug: 
disp('Calculating box boundaries for geofences...');

numFences = length(fences);
fences(:,4:6) = zeros(numFences,3);

for i = 1:numFences
    [dlat, dlon] = proximity(fences(i,1), fences(i,2), fences(i,3));
    fences(i,4) = dlat; fences(i,5) = dlon;
end

numImpressions = length(impressions);
impressions(:,3) = zeros(numImpressions,1);

h = waitbar(0,'Checking impressions for each geofence...');

for j = 1:numFences
    minLat = fences(j,1) - fences(j,4); maxLat = fences(j,1) + fences(j,4);
    minLon = fences(j,2) - fences(j,5); maxLon = fences(j,2) + fences(j,5);
    
    rowBool = (impressions(:,1) >= minLat & impressions(:,1) <= maxLat & impressions(:,2) >= minLon & impressions(:,2) <= maxLon);
    
    rowIndex = find(rowBool);
    
    % fprintf('Geofence %d is pulling %d impressions. ',j,length(rowIndex));
    
    for k = 1:length(rowIndex)
        if haversine(fences(j,1),fences(j,2),impressions(rowIndex(k),1),impressions(rowIndex(k),2)) <= fences(j,3)
            fences(j,6) = fences(j,6) + 1;
            impressions(rowIndex(k),3) = impressions(rowIndex(k),3) + 1;
        end
    end
    
    % fprintf('Confirmed for %d impressions.\n',fences(j,6));
    waitbar(j / numFences, h)
end

close(h)