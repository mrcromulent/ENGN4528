close all;
clearvars();
v = VideoReader("Angry Birds In-game Trailer.avi");
w = warning ('off','all');

%% Variables
test = false;

%time
time = 55;
dt = 0.1;
slingshotTimeout = 7;
slingshotDetectTime = -9999;

slingshotFound = false;
birdFlying = false;
stitch = false;

watchBoxStruct = struct('Location', NaN(1,4), 'Memory', NaN(10,10));
prevFrame = NaN;
prompt = 'None';
plotOverlays = [];
movingRegs = [];

memory = cell(1,0);

%% Main Loop

figure();
h = imshow(readFrame(v));

while time < 66.1
    %% Setup
    currFrame = readFrame(v);
    %draw watchbox in a separate figure
    if exist('watchBoxNow')
    if ~isnan(watchBoxNow)
        figure(2)
        imshow(watchBoxNow)
        drawnow
        figure(1)
    end
    end
    %% Mode Identifiaction
    if (time - slingshotDetectTime) > slingshotTimeout
        
        %Detect slingshot
        [slingshotFound, slingshotLoc] = detectSlingshot(currFrame);
        
        %If slingshot found, declare Watch Box.
        if slingshotFound
            birdFlying = false;
            slingshotDetectTime = time;
            watchBoxStruct = GetWatchBoxFromSlingshot(slingshotLoc, currFrame);
            prompt = 'All';
        else
            if ~birdFlying
                prompt = 'None';
            end
        end
          
    else %If less than timeout period
        
        if ~birdFlying
            
            [patchesMatch, watchBoxNow] = ...
                CompareWatchPatchWithMemory(currFrame, watchBoxStruct);
            
            if patchesMatch
                prompt = 'All';
                
            else
                
                mainBird = FindMainBird(watchBoxNow);                
                birdFlying = true;
                prompt = mainBird;
                disp(mainBird);
                
            end
            
        end
        
        
    end
    
    
    %% Draw New Frame
    if time > 60
       prompt = 'None'; 
    end
    
    delete(plotOverlays);
    [plotOverlays, memory] = Draw(prompt, currFrame, prevFrame, h, time, memory);
    
    %% Tidy Up
    time = time + dt;
    if time < 62
        v.CurrentTime = time;
    end
    prevFrame = currFrame;

end

delete(plotOverlays);