% Not HSV
function [recs] = detectWhiteBird(vidFrame)
%% Remove bottom half of frame
vidFrameCropped = [vidFrame(1:round(size(vidFrame,1)/2),1:end,:);zeros(round(size(vidFrame,1)/2),size(vidFrame,2),3)];

%% Mask for white feathers

% Convert RGB image to chosen color space
I = rgb2ycbcr(vidFrameCropped);

% Define thresholds for channel 1 based on histogram settings
channel1Min = 207.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 113.000;
channel2Max = 130.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 119.000;
channel3Max = 142.000;

% Create mask based on chosen histogram thresholds
whiteResult = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);


%% Mask for beak colours

% Convert RGB image to chosen color space
I = vidFrameCropped;

% Define thresholds for channel 1 based on histogram settings
channel1Min = 211.000;
channel1Max = 255.000;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.000;
channel2Max = 221.000;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.000;
channel3Max = 168.000;

% Create mask based on chosen histogram thresholds
result = (I(:,:,1) >= channel1Min ) & (I(:,:,1) <= channel1Max) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);

%remove pause button and menu
result(1:60,1:60) = 0; %remove pause button
result(1:60,320:end) = 0; %remove score

se = strel('disk',8);
beakClosed = imclose(result,se);
whiteClosed = imclose(whiteResult,se);
result = beakClosed & whiteClosed;

thresh = 20; 
upThresh = 150;

CC          = bwconncomp(result);
val         = cellfun(@(x) numel(x),CC.PixelIdxList);
birdsFound  = CC.PixelIdxList(val > thresh & val < upThresh);

recs = cell(1,0);

for bird = 1:length(birdsFound)
    pixels = birdsFound{bird};
    [rows, cols] = ind2sub(size(vidFrame), pixels);
    
    topRow = min(rows) - 10;
    topCol = min(cols) - 10;
    pixWid = max(cols) - min(cols) + 20;
    pixHgt = max(rows) - min(rows) + 20;
    
    %Remove objects that don't meet the expected aspect ratio of the
    %bird
    if 8/20 < pixHgt/pixWid && 25/20 > pixHgt/pixWid
        recs{1,end+1} = [topCol topRow  pixWid pixHgt]; 
    end
end

% if ~isempty(recs)
%     keyboard();
% end

end