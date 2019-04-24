v = VideoReader('../../Angry Birds In-game Trailer.avi');

%% Read all video frames.
% while hasFrame(v)
%     video = readFrame(v);
% end
% whos video

% v.currentTime = 10;

%% Read video starting at a specific time
% currAxes = axes;
% while hasFrame(v)
%     vidFrame = readFrame(v);
%     image(vidFrame, 'Parent', currAxes);
%     currAxes.Visible = 'off';
%     pause(1/v.FrameRate);
% end

%% Read and play back video
vidWidth = v.Width;
vidHeight = v.Height;

mov = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);

k = 1;
while hasFrame(v) % v.CurrentTime <= 0.9
    mov(k).cdata = readFrame(v);
%     if k == 450
%         imshow(mov(k).cdata);
%         hold on
%         rectangle('Position', [60, 80, 30, 30], 'EdgeColor','r', 'LineWidth', 3);
%         F = getframe;
%         mov(k).cdata = F;
%         hold on
%         mov(450).cdata = rectangle('Position', [60, 80, 30, 30], 'EdgeColor','r', 'LineWidth', 3);
%     end
    k = k+1; 
end

%% Draw bounding box of red bird on frame 450
% mov(450).cdata = rectangle('Position', [60, 80, 30, 30], 'EdgeColor','r', 'LineWidth', 3);
% insertShape(mov,'Rectangle',[60, 80, 30, 30],'EdgeColor','r','LineWidth',3);

% hf = figure;
% set(hf,'position',[150 150 vidWidth vidHeight]);
% 
% movie(hf,mov,1,v.FrameRate);

% Resize the current figure and axes based on the video's width and height
% and play at video's rate
set(gcf,'position',[150 150 v.Width v.Height]);
set(gca,'units','pixels');
set(gca,'position',[0 0 v.Width v.Height]);

% F = getframe;
% plot(rand(5))
% movie(mov,1,v.FrameRate);

% close

%% Display frames
%% Frame 450 (or try 460)
% image(mov(450).cdata);
% thisFrame = mov(450).cdata;

%% Frame at 15 secs in video (same as above Frame 450)
v.CurrentTime = 15;
imageData = readFrame(v);

%% RGB of pixel col 1 row 2
zz = impixel(imageData,1,2);
% zzz = impixel(thisFrame,1,2);
%% zz and zzz are equivalent

% imshow(imageData);

rChannel = imageData(:,:,1);
bChannel = imageData(:,:,2);
gChannel = imageData(:,:,3);

% imagesc(rChannel);
% imagesc(bChannel);
% imagesc(gChannel);

%% make copy as grayscale, canny edge detection, compare with original R channel
% grayImage = rgb2gray(imageData);
% tic
% edges_canny = edge(grayImage,'Canny');
% toc
% 
% tic
% edges_prewitt = edge(grayImage,'Prewitt');
% toc
% 
% tic
% edges_roberts = edge(grayImage,'Roberts');
% toc
% 
% tic
% edges_sobel = edge(grayImage,'Sobel');
% toc

% Respectively
% Elapsed time is 0.025429 seconds.
% Elapsed time is 0.005228 seconds.
% Elapsed time is 0.007340 seconds.
% Elapsed time is 0.003549 seconds.

% figure();
% subplot(2,2,1);
% imshow(edges_canny);
% title("Canny Edge");
% 
% subplot(2,2,2);
% imshow(edges_prewitt);
% title("Prewitt Edge");
% 
% subplot(2,2,3);
% imshow(edges_roberts);
% title("Roberts Edge");
% 
% subplot(2,2,4);
% imshow(edges_sobel);
% title("Sobel Edge");

%% "Crop" the bird/pig, get their location (row/col)
bird_rCh = rChannel(80:120,50:100);
% imagesc(bird_rCh);

bird_canny = grayImage(80:120,50:100);
% imagesc(bird_canny);

% measurements = regionprops(logical(bird_canny), 'BoundingBox');
% bBox = measurements.BoundingBox;
% hold on;
% rectangle('Position', bBox, 'EdgeColor', 'r');

figure();
imagesc(imageData);
% hold on
rectangle('Position', [60, 80, 30, 30], 'EdgeColor','r', 'LineWidth', 3)

%% alt: histogram 
%% sliding window
% for loop to identify birds

% pixel of window
% nested for loop
% 	threshold: above a certain intensity
% 	that's where the bird is
% 
% 
% keep checking #red pixels within the box (sliding window) every row 
% 
% for width
% 	for height
% 		sum of total redCh

% redThr = rChannel > 220;

for row = 1 : size(rChannel,1)
    for col = 1 : size(rChannel,2)
        pix = rChannel(row,col);
        
        if pix > redThr
            rectangle('Position', [60, 80, 30, 30], 'EdgeColor','r', 'LineWidth', 3)
        end
    end
end

% imagesc(rChannel)
% [nRows, nCols] = size(rChannel);
% result            = zeros(nRows, nCols);
% halfWinSize       = 2; 
% threshold         = 220;
% 
% for rI = 1:nRows
%     for cI = 1:nCols
%         % These indices specify the start and stop indices of the
%         % window. The window will go from row rILo to rIHi amd column
%         % cILo to cIHi
%         rILo               = rI - halfWinSize; % lower row index of window
%         rIHi               = rI + halfWinSize; % upper row index of window
%         cILo               = cI - halfWinSize; % lower column index of window
%         cIHi               = cI + halfWinSize; % upper column index of window
%         flagConditionMet = false ;
%         count = 1;
% 
%           % while success criteria unmet
%           while( ~ flagConditionMet )
%           % It is important to make sure that your window indices are valid
%           % indices before pulling out the window.            
%               if( rILo >= 1 && rIHi <= nRows && cILo >= 1 && cIHi <= nCols )
% 
%                   % Pull out the window around (rI , cI)
%                   imgWindow = rChannel( (rILo : rIHi) , (cILo : cIHi) ); 
% 
%                   %perform an operation
%                   minVal = min( imgWindow(:) );
% 
%                   %check if successful
%                   flagConditionMet = minVal < threshold;
% 
%                   %increase window bounds if unsuccessful   
%                   if( ~ flagConditionMet )                  
%                       rILo = rILo - 1;
%                       rIHi = rIHi + 1;
%                       cILo = cILo - 1;
%                       cIHi = cIHi + 1;
%                       count = count + 1;
%                   else
%                       %store some result if successful
%                       result( rI , cI ) = count;                    
%                   end
% 
%               else 
%                   % out of bounds break out of while loop
%                   break; 
%               end
%           end
%       end
%   end
% 
% figure;
% imshow(result./max( result(:) ));
% imagesc(result);

% count = 0; % Remembers total count of pixels greater than threshold
% val = 220; % Threshold value
% N = 50; % Radius of neighbourhood
% 
% % Generate 2D grid of coordinates
% [x, y] = meshgrid(1 : size(rChannel, 2), 1 : size(rChannel, 1));
% 
% % For each coordinate to check...
% for kk = 1 : size(coord, 1)
%     a = coord(kk, 1); b = coord(kk, 2); % Get the pixel locations
%     mask = (x - a).^2 + (y - b).^2 <= N*N; % Get a mask of valid locations
%                                            % within the neighbourhood        
%     pix = rChannel(mask); % Get the valid pixels
%     count = count + any(pix(:) > val); % Add either 0 or 1 depending if 
%                                         % we have found any pixels greater
%                                         % than threshold
% end
% imagesc(rChannel)

% 
% ArrayList<Rectangle> objects = new ArrayList<Rectangle>();
% 
% 
% 
% 		%% test for red birds (385, 488, 501)
% 
% 		Boolean ignore[] = new Boolean[_nSegments];
% 
% 		Arrays.fill(ignore, false);
% 
% 
% 
% 		for (int n = 0; n < _nSegments; n++) {
% 
% 			if ((_colours[n] != 385) || ignore[n])
% 
% 				continue;
% 
% 
% 
% 			// dilate bounding box around colour 385
% 
% 			Rectangle bounds = VisionUtils.dialateRectangle(_boxes[n], 1,
% 
% 					_boxes[n].height / 2 + 1);
% 
% 			Rectangle obj = _boxes[n];
% 
% 
% 
% 			// look for overlapping bounding boxes of colour 385
% 
% 			for (int m = n + 1; m < _nSegments; m++) {
% 
% 				if (_colours[m] != 385)
% 
% 					continue;
% 
% 				final Rectangle bounds2 = VisionUtils.dialateRectangle(
% 
% 						_boxes[m], 1, _boxes[m].height / 2 + 1);
% 
% 				if (bounds.intersects(bounds2)) {
% 
% 					bounds.add(bounds2);
% 
% 					obj.add(_boxes[m]);
% 
% 					ignore[m] = true;
% 
% 				}
% 
% 			}


%% time tests
% tic
% toc
% profile on
% profileViewer

% tic
% edge_detector_function_1
% toc
% 
% tic
% edge_detector_function_2
% toc

% Before you run script,
% profile on;
% 
% Run your script
% 
% profile viewer;