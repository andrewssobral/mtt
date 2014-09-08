%% [matrix int int int] = load_input(inputPath)
% video - 4D matrix
% nFrame - int
% vidWidth - int
% vidHeight - int
% 
function [video nFrame vidWidth vidHeight] = load_input(inputPath)

disp('Checking input file extension...');
input_extension = inputPath(length(inputPath)-2:length(inputPath));

if(strcmp(input_extension,'mat'))
  disp('Loading data...');
  load(inputPath);
else
  disp('Reading movie file...');
  warning('off','all');
  mov = mmreader(inputPath);
  warning('on','all');
  nFrame = mov.NumberOfFrames;
  vidHeight = mov.Height;
  vidWidth = mov.Width;
  video = read(mov);
end
disp('OK');

end