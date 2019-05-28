function [recs, worldPoints] = Draw(prompt, currFrame, prevFrame, fHand, worldPoints)

    recs = [];

    if strcmp(prompt, 'All')
        set(fHand,'Cdata',currFrame);
        recs = DrawAllBoxes(currFrame);
        
    elseif strcmp(prompt, 'None')
        set(fHand,'Cdata',currFrame);
        
    else
        [recs, worldPoints] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, fHand, worldPoints);
        
    end
    
%     [ssf, ssl] = detectSlingshot(currFrame);
%     if ssf
%         recs = DrawRectangles(ssl, 'magenta', recs);
%     end
    
end


function [recs] = DrawAllBoxes(currFrame)

recs = [];

hold on;

redBirds = detectRedBird(currFrame);
recs = DrawRectangles(redBirds, 'red', recs);

bluBirds = detectBlueBird(currFrame);
recs = DrawRectangles(bluBirds, 'blu', recs);

yelBirds = detectYellowBird(currFrame);
recs = DrawRectangles(yelBirds, 'yellow', recs);
        
blkBirds = detectBlackBird(currFrame);
recs = DrawRectangles(blkBirds, 'black', recs);

whtBirds = detectWhiteBird(currFrame);
recs = DrawRectangles(whtBirds, 'white', recs);

grenPigs = detectGreenPigs(currFrame);
recs = DrawRectangles(grenPigs, 'green', recs);


end

function [recs, worldPoints] = DrawBoxesAndTraj(prompt, currFrame, prevFrame, fHand, worldPoints)
    
    recs = [];

    %Reset the figure
    set(fHand,'Cdata',currFrame);

    %Find the flying bird and draw its bounding box
    if      strcmp(prompt, 'Red')
        bird = detectRedBird(currFrame);
        recs = DrawRectangles(bird, 'red', recs);
        
    elseif  strcmp(prompt, 'Yellow')
        bird = detectYellowBird(currFrame);
        recs = DrawRectangles(bird, 'yellow', recs);
        
    elseif  strcmp(prompt, 'White')
        bird = detectWhiteBird(currFrame);
        recs = DrawRectangles(bird, 'white', recs);
        
    elseif  strcmp(prompt, 'Blue')
        bird = detectBlueBird(currFrame);
        recs = DrawRectangles(bird, 'blue', recs);
        
    elseif  strcmp(prompt, 'Black')
        bird = detectBlackBird(currFrame);
        recs = DrawRectangles(bird, 'black', recs);
        
    end
    
    %pigs
    grenPigs = detectGreenPigs(currFrame);
    recs = DrawRectangles(grenPigs, 'green', recs);

    
    %Draw bird trajectories
    if ~isempty(bird)
        bird = bird{1};
        
        [movingReg, TBetter] = FindBetterCorrespondences(prevFrame, currFrame);
        if isa(movingReg.Transformation,'affine2d')
            [trajX, trajY, worldPoints] = FindQuadratic(bird, TBetter, 0.1, worldPoints);
            trajLine = plot(trajX, trajY, 'r', 'Linewidth', 3);
            trajLine.Color(4) = 0.7;

            recs = [recs, trajLine];
        end

    end

    
end