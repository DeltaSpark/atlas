% MATLAB Script file that will convert fences and impressions matricies to
% Javascript arrays for use by the html/js viewer

% Load fences and impressions from .mat file
load fences.mat
load impressions.mat

% Draw a waitbar for progress monitoring
h = waitbar(0,'Writing fences to javascript file...');

% Save length of fences and impressions matricies
num_fences = length(fences);
num_impressions = length(impressions);

% Save total loop iterations for waitbar
total_progress = num_fences + num_impressions;

% Write fences matrix as a minified js file
fenceFileID = fopen('fences.js','w');
fprintf(fenceFileID,'var fences=[');

for i = 1:num_fences
    fprintf(fenceFileID,'[%f,%f,%d],',fences(i,1),fences(i,2),fences(i,3));
    waitbar(i / total_progress, h)
end

fprintf(fenceFileID,'];');
fclose(fenceFileID);

% Write impressions matrix as a minified js file
impressionsFileID = fopen('impressions.js','w');
fprintf(impressionsFileID,'var impressions=[');

% Update waitbar message with transition to impressions
waitbar(num_fences / total_progress, h,'Writing impressions to javascript file...')

for i = 1:num_impressions
    fprintf(impressionsFileID,'[%f,%f],',impressions(i,1),impressions(i,2));
    waitbar((num_fences + i) / total_progress, h)
end

fprintf(impressionsFileID,'];');
fclose(impressionsFileID);

% Close waitbar
close(h)

% Garbage collection to remove variables local to script
clear fenceFileID i impressionsFileID num_fences num_impressions total_progress h