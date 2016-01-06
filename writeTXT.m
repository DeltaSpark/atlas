% MATLAB Script file that will convert fences and impressions matricies to
% Javascript arrays for use by the html/js viewer

% Load fences and impressions from .mat file
load fences.mat
load impressions.mat

% Debug: Notification that geofence processing has begun
disp('Processing geofences...');

% Convert fence coordinates into strings
for i = 1:length(fences)
    stringFences(i) = {sprintf('[%f,%f,%d]',fences(i,1),fences(i,2),fences(i,3))};
end

% Write fence strings as a minified js file
s = strcat('var fences=[',strjoin(stringFences,','),'];');

fenceFileID = fopen('fences.js','w');
fprintf(fenceFileID,s);
fclose(fenceFileID);

% Garbage collection to remove variables local to script
clear i fenceFileID s stringFences



% Debug: Notification that impression processing has begun
disp('Processing impressions...');

% Setup histogram to define a table across Florida and count the number of 
% impressions in each cell of the table

% Defines number of bins in the X and Y axis (or lat, lon)
% Discovered through trial and error, targetting for ~90,000 markers to
% balance between as high of a resolution as possible while still feasible
% to draw on map in Chrome
binX = 3000; binY = 4000;

% Count the number of impressions in each bin, including duplicates
[N,Xedges,Yedges] = histcounts2(impressions(:,1),impressions(:,2),[binX binY]);
numClusters = nnz(N);

% Debug: Displays the number of bins filled with at least 1 impression
fprintf('Impressions clustered into %d markers.\n',numClusters);

% Debug: Notification that impression processing has begun
disp('Extracting nonzero elements from the clustered data...');

% Find nonzero elements in the histogram
[rowIndex, colIndex, values] = find(N);

% Open waitbar with progress bar for impressions clustering
h = waitbar(0,'Converting clustered data into marker strings...');

% Extract values of nonzero elements and convert into strings
for j = 1:numClusters
    xCoordinate = mean([Xedges(rowIndex(j)), Xedges(rowIndex(j)+1)]);
    yCoordinate = mean([Yedges(colIndex(j)), Yedges(colIndex(j)+1)]);
    markerLabel = values(j);
    
    stringClusters(j) = {sprintf('[%.4f,%.4f,%d]',xCoordinate, yCoordinate, markerLabel)};
    debugClusterMatrix(j,:) = [xCoordinate, yCoordinate, markerLabel];
    
    waitbar(j / numClusters, h)
end

% Close waitbar
close(h)

% Debug: Notification that impression processing has begun
disp('Writing data to file...');

% Write impression cluster strings as a minified js file
s = strcat('var impressions=[',strjoin(stringClusters,','),'];');

impressionsFileID = fopen('impressions.js','w');
fprintf(impressionsFileID,s);
fclose(impressionsFileID);

% Garbage collection to remove variables local to script
clear j impressionsFileID h binX binY N colIndex rowIndex values s numClusters stringClusters xCoordinate yCoordinate markerLabel