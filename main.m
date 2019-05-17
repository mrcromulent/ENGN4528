close all;
clearvars();

v = VideoReader("Angry Birds In-game Trailer.avi");


%% Variables
time = 10;

flagSlingshotDetected = 0;
flagTimeSlingshot = 0;
flagBirdLaunched = 0;
currFrame = readFrame(v);
prevFrame = readFrame(v);
newScene = false;


%% Main Loop

figure();

while hasFrame(v)
    
    currFrame = readFrame(v);
    
    %% Slingshot detection
    [flagSlingshotDetected,slingshotLoc] = detectSlingshot(currFrame); 
    %need to keep updating position as slingshot moves in initial pan
    if flagSlingshotDetected
        newScene = true;
        %Define the watch path
        rec = slingshotLoc{1};
        topRight = [rec(1) + rec(3), rec(2)];
%         watchMe = currFrame(topRight(1)-20:topRight(1), topRight(2)-rec(4):topRight(2)+rec(4));

    else
        flagTimeSlingshot = time;
        [flagSlingshotDetected,slingshotLoc] = detectSlingshot(currFrame);
    end
    
    
    
    if flagSlingshotDetected && newScene 
        checkArea = currFrame( rec(2)-80:rec(2) -20,rec(1) + rec(3) :rec(1) + rec(3) + 75,:);
        if ~isempty(detectRedBird(checkArea))
%         watchPatch = currFrame(topRight(1)-20:topRight(1), topRight(2)-rec(4):topRight(2)+rec(4));
%         if sum(abs(watchMe - watchPatch).^2,'all') > 1
            flagBirdlaunched = true;
            "RED BIRD DETECTED"
            %Find bird type
            %birdType = ;
        end
    end
    
    
    if flagSlingshotDetected && ~flagBirdLaunched
        draw = 'all';
    elseif flagSlingshotDetected && flagBirdLaunched
        draw = birdType;
    else
        draw = 'none';
    end
    
    DrawThem(draw, currFrame);
    
    %Update current time
    time = time + 0.1;
    v.CurrentTime = time;
    prevFrame = currFrame;
    
    
%     if flagSlingshotDetected
%         currentRec = rectangle('Position',rec,'EdgeColor','magenta', 'LineWidth',2);
%         pause(0.1);
%         delete(currentRec);
%     end
    
end

function [] = DrawThem(prompt, currFrame)

if strcmp(prompt,'all')
    imshow(currFrame);
    DrawThemAll(currFrame);
    
elseif strcmp(prompt, 'none')
    
    imshow(currFrame)
    
else %Specific colour
    keyboard;
    
end

end