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

% Setup histogram to include bins every .005 degrees (approx 56 meters) and
% to count the number of impressions in each bin

% Defines number of bins in the X and Y axis (or lat, lon)
% binX = (max latitude - min latitude) / .005, rounded to nearest integer
% binY = (max long - min long) / .005, rounded to nearest integer
binX = 1391; binY = 1794;

% Count the number of impressions in each bin, including duplicates
[N,Xedges,Yedges] = histcounts2(impressions(:,1),impressions(:,2),[binX binY]);
numClusters = nnz(N);

% Debug: Displays the number of bins filled with at least 1 impression
fprintf('Impressions clustered into %d markers.\n',numClusters);

% Debug: Notification that impression processing has begun
disp('Extracting nonzero elements from the clustered data...');

% Find nonzero elements in the histogram
[rowIndex, colIndex, values] = find(N);

% Update waitbar message with transition to impressions
h = waitbar(0,'Converting clustered data into marker strings...');

% Extract values of nonzero elements and convert into strings
for j = 1:numClusters
    stringClusters(j) = {sprintf('[%.3f,%.3f,%d]',Xedges(rowIndex(j)), Yedges(colIndex(j)), values(j))};
    debugClusterMatrix(j,:) = [Xedges(rowIndex(j)), Yedges(colIndex(j)), values(j)];
    
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
clear j impressionsFileID h binX binY N Xedges Yedges colIndex rowIndex values s numClusters stringClusters