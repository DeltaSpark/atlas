% Include a waitbar for progress monitoring

h = waitbar(0,'Writing fences to javascript file...');

num_fences = length(fences);
num_impressions = length(impressions);

total_progress = num_fences + num_impressions;

% Write Fences to txt file
fenceFileID = fopen('fences.js','w');
fprintf(fenceFileID,'var fences=[');

for i = 1:num_fences
    fprintf(fenceFileID,'[%f,%f,%d],',fences(i,1),fences(i,2),fences(i,3));
    
    waitbar(i / total_progress, h)
end

fprintf(fenceFileID,'];');
fclose(fenceFileID);


% Write Impressions to txt file
impressionsFileID = fopen('impressions.js','w');
fprintf(impressionsFileID,'var impressions=[');

waitbar(num_fences / total_progress, h,'Writing impressions to javascript file...')

for i = 1:num_impressions
    fprintf(impressionsFileID,'[%f,%f],',impressions(i,1),impressions(i,2));
    
    waitbar((num_fences + i) / total_progress, h)
end

fprintf(impressionsFileID,'];');
fclose(impressionsFileID);

close(h)