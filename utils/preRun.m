
% Print the Algorithms being used
fprintf(['Running Algorithms: ' vfpAlgorithms{1}]);
for i = 2:length(vfpAlgorithms)
	fprintf([', ' vfpAlgorithms{i}]);
end
fprintf('\n');

% Print the Datasets we are using
fprintf(['Using Datasets: ' vfpDatasets{1}]);
for i = 2:length(vfpDatasets)
	fprintf([', ' vfpDatasets{i}]);
end
fprintf('\n\n');

if ~exist(vfpTempFolder, 'dir')
	mkdir(vfpTempFolder);
end

if ~exist(vfpBackupFolder, 'dir')
	mkdir(vfpBackupFolder);
end

% Stop the scripts recording the memory usage
% Sorry, I think this kills all shell scripts :'(
% vfStopMem % We don't do this because of the pause
if vfpPlatform == LINUX
	system('killall sh');
else
	tmpNonsense = 0;
	save(vfpDoneFile, 'tmpNonsense');
	clear tmpNonsense;
end

% Create the stats folder if it doesn't exist, back it up if it does
if exist(vfpStatsFolder, 'dir')
	% We went to a lot of work to generate these silly results, don't
	% delete them! Just rename them with the current timestamp
	timestamp = datestr(now);
	timestamp(find(timestamp == ':')) = '.';
	
	% This is retarded, but sometimes Matlab thinks the folder exists after
	% it has been deleted or moved. To remedy this, use a try-catch
	try, movefile(vfpStatsFolder, [vfpBackupFolder '/' vfpStatsFolder ' ' timestamp]); catch, end;
	clear timestamp;
end

% Make new stats folder
% mkdir(vfpStatsFolder-);

if ~exist('tmp', 'dir')
	mkdir('tmp');
end