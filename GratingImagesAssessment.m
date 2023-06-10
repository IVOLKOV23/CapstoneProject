% Grating progrmme
% Ivan Volkov
% 12/05/22
 
%%%% SCREEN CONFIGURATION %%%%
% base values
clear all                                   %#ok<CLSCR>
stereoMode = 1;                             % 1=120Hz shutters; 6=red green anaglyph 9 == Blue-Red anaglyph
AssertOpenGL;
sName = 'Demo';                             % subject initials
calibsuc = 1;   
imSize = 256;
whichScreen = max(Screen('Screens'));       % find out how many screens and use largest
backLum = 128;


%%%% EXPERIMENTAL SETUP %%%%
% subject details
prompt = {'Enter subject name'}; 
title = 'Subject name';
lines = 1;
def = {'FNLN'};
answer = inputdlg(prompt, title, lines, def);

% select the amblyopic eye/non-dominant eye
% which ones sees the grating
% 0 = left
% 1 = right
prompt2 = {'Enter amblyopic eye: 0 = left, 1 = right'}; 
title2 = 'Amblyopic eye select';
lines2 = 1;
def2 = {'0'};
answer2 = inputdlg(prompt2, title2, lines2, def2);
                   
if str2num(char(answer2)) == 0  %#ok<ST2NM>
    felEye = 1;
    domEye = 0;
else
    felEye = 0;
    domEye = 1;
end

% buffering
if domEye == 0
    buffer = 'frontRightBuffer';
else
    buffer = 'frontLeftBuffer';
end

% prepare windows
PsychImaging('PrepareConfiguration');
[win, winRect] = PsychImaging('OpenWindow', whichScreen, backLum, [], [], 4, stereoMode);

% prepare glasses
if stereoMode == 9; % anaglyph glasses
    SetAnaglyphStereoParameters('LeftGains', win, [0.0 0.0 1]);
    SetAnaglyphStereoParameters('RightGains', win, [1 0.0 0.0]);
end


%%%% GRATINGS CONFIGURATION 1 OF 3 %%%%
% grating parameters
% note: no rotation
% the only parameter to be changed
targcpd = 2;                                    % set how many cycles per degree (spatial frequency) you want the grating to be

viewdist = 0.435;                               % viewing distance in m
pxheight = 0.0003;                              % height in m of 1 pixel on 1920 x 1080 screen
tiltInDegrees = 0;                              % The tilt of the grating in degrees.
tiltInRadians = tiltInDegrees * pi / 180;       % The tilt of the grating in radians.
pxangle = 2*(atand (pxheight/2)/viewdist);      % calculate degrees of visual angle subtended by 1 pixel
pxperdeg = 1/pxangle;                           % calculate number of pixels per degree of visual angle
pixelsPerPeriod = pxperdeg/targcpd;             % How many pixels will each period/cycle occupy based on the viewing distance and desired spatial frequency? 
                                                % Divide the pixels contained in one degree of visual angle by desired cycles per degree
spatialFrequency = 1 / pixelsPerPeriod;         % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi);  % = (periods per pixel) * (2 pi radians per period)

% apply Gaussian mask
periodsCoveredByOneStandardDeviation = 6;                                   % smaller = more blur
gaussianSpaceConstant = periodsCoveredByOneStandardDeviation * pxperdeg;    %* pixelsPerPeriod

% meshgrid creation
widthOfGrid = 600;
halfWidthOfGrid = widthOfGrid / 2;
widthArray = (-halfWidthOfGrid) : halfWidthOfGrid;  % widthArray is used in creating the meshgrid.

% Retrieves color codes for black and white and gray.
black = 0;                     % Retrieves the CLUT color code for black.
white = 255;                    % Retrieves the CLUT color code for white.
gray = (black + white) / 2;     % Computes the CLUT color code for gray.
if round(gray) == white
    gray = black;
end
absoluteDifferenceBetweenWhiteAndGray = abs(white - gray); % keep the grating consistent

% grating creation
% square grid
[x y] = meshgrid(widthArray, widthArray);   %#ok<NCOMMA>

% orientation in space
a = cos(tiltInRadians)*radiansPerPixel;
b = sin(tiltInRadians)*radiansPerPixel;

% convert into sinusoidal grating
gratingMatrix = sin(a*x + b*y);

% masking the image
circularGaussianMaskMatrix = exp(-((x .^ 2) + (y .^ 2)) / (gaussianSpaceConstant ^ 2));
imageMatrix = gratingMatrix .* circularGaussianMaskMatrix;

% grayscale
grayscaleImageMatrix = gray + absoluteDifferenceBetweenWhiteAndGray * imageMatrix;


%%%% GRATINGS CONFIGURATION 2 OF 3 %%%%
% REPEAT OF THE ABOVE SECTION FOR DIFFERENT SPATIAL FREQUENCY
% PART OF THE CODE NOT ALTERED IS NOT PRESENT 
% grating parameters
targcpd2 = 4;                                     % set how many cycles per degree (spatial frequency) you want the grating to be
pixelsPerPeriod2 = pxperdeg/targcpd2;             % How many pixels will each period/cycle occupy based on the viewing distance and desired spatial frequency? 
                                                  % Divide the pixels contained in one degree of visual angle by desired cycles per degree
spatialFrequency2 = 1 / pixelsPerPeriod2;         % How many periods/cycles are there in a pixel?
radiansPerPixel2 = spatialFrequency2 * (2 * pi);  % = (periods per pixel) * (2 pi radians per period)

% grating creation
% orientation in space
a2 = cos(tiltInRadians)*radiansPerPixel2;
b2 = sin(tiltInRadians)*radiansPerPixel2;

% convert into sinusoidal grating
gratingMatrix2 = sin(a2*x+b2*y);

% masking the image
imageMatrix2 = gratingMatrix2 .* circularGaussianMaskMatrix;

% grayscale
grayscaleImageMatrix2 = gray + absoluteDifferenceBetweenWhiteAndGray * imageMatrix2;


%%%% GRATINGS CONFIGURATION 3 OF 3 %%%%
% REPEAT OF THE ABOVE SECTION FOR DIFFERENT SPATIAL FREQUENCY
% PART OF THE CODE NOT ALTERED IS NOT PRESENT 
% grating parameters
targcpd3 = 1;                                     % set how many cycles per degree (spatial frequency) you want the grating to be
pixelsPerPeriod3 = pxperdeg/targcpd3;             % How many pixels will each period/cycle occupy based on the viewing distance and desired spatial frequency? 
                                                  % Divide the pixels contained in one degree of visual angle by desired cycles per degree
spatialFrequency3 = 1 / pixelsPerPeriod3;         % How many periods/cycles are there in a pixel?
radiansPerPixel3 = spatialFrequency3 * (2 * pi);  % = (periods per pixel) * (2 pi radians per period)

% grating creation
% orientation in space
a3 = cos(tiltInRadians)*radiansPerPixel3;
b3 = sin(tiltInRadians)*radiansPerPixel3;

% convert into sinusoidal grating
gratingMatrix3 = sin(a3*x+b3*y);

% masking the image
imageMatrix3 = gratingMatrix3 .* circularGaussianMaskMatrix;

% grayscale
grayscaleImageMatrix3 = gray + absoluteDifferenceBetweenWhiteAndGray * imageMatrix3;

%%%% GRATINGS CONFIGURATION PRACTICE %%%%
% REPEAT OF THE ABOVE SECTION FOR DIFFERENT SPATIAL FREQUENCY
% PART OF THE CODE NOT ALTERED IS NOT PRESENT 
% grating parameters
targcpd4 = 0.5;                                     % set how many cycles per degree (spatial frequency) you want the grating to be
pixelsPerPeriod4 = pxperdeg/targcpd4;             % How many pixels will each period/cycle occupy based on the viewing distance and desired spatial frequency? 
                                                  % Divide the pixels contained in one degree of visual angle by desired cycles per degree
spatialFrequency4 = 1 / pixelsPerPeriod4;         % How many periods/cycles are there in a pixel?
radiansPerPixel4 = spatialFrequency4 * (2 * pi);  % = (periods per pixel) * (2 pi radians per period)

% grating creation
% orientation in space
a4 = cos(tiltInRadians)*radiansPerPixel4;
b4 = sin(tiltInRadians)*radiansPerPixel4;

% convert into sinusoidal grating
gratingMatrix4 = sin(a4*x+b4*y);

% masking the image
imageMatrix4 = gratingMatrix4 .* circularGaussianMaskMatrix;

% grayscale
grayscaleImageMatrix4 = gray + absoluteDifferenceBetweenWhiteAndGray * imageMatrix4;


%%%% RANDOMLY CHOOSE A GRATNG TO SHOW %%%%
% first grating randomisation
randGrating = randi([1, 3], 1);

if randGrating == 1
    firstGrating = grayscaleImageMatrix;
    firstname = num2str(targcpd);
    
    % have only grating 2 or 3 left
    randGrating = randi([2, 3], 1);
    if randGrating == 2
        secondGrating = grayscaleImageMatrix2;
        thirdGrating = grayscaleImageMatrix3;
        secondname = num2str(targcpd2);
        thirdname = num2str(targcpd3);
    else
        secondGrating = grayscaleImageMatrix3;
        thirdGrating = grayscaleImageMatrix2;
        secondname = num2str(targcpd3);
        thirdname = num2str(targcpd2);
    end
elseif randGrating == 2
    firstGrating = grayscaleImageMatrix2;
    firstname = num2str(targcpd2);
    
    % have only grating 1 or 3 left
    randGrating = randi(2);
    if randGrating == 1
        secondGrating = grayscaleImageMatrix;
        thirdGrating = grayscaleImageMatrix3;
        secondname = num2str(targcpd);
        thirdname = num2str(targcpd3);
    else
        secondGrating = grayscaleImageMatrix3;
        thirdGrating = grayscaleImageMatrix;
        secondname = num2str(targcpd3);
        thirdname = num2str(targcpd);
    end
else
    firstGrating = grayscaleImageMatrix3;
    firstname = num2str(targcpd3);
    
    % have only grating 1 or 2 left
    randGrating = randi([1, 2], 1);
    if randGrating == 1
        secondGrating = grayscaleImageMatrix;
        thirdGrating = grayscaleImageMatrix2;
        secondname = num2str(targcpd);
        thirdname = num2str(targcpd2);
    else
        secondGrating = grayscaleImageMatrix2;
        thirdGrating = grayscaleImageMatrix;
        secondname = num2str(targcpd2);
        thirdname = num2str(targcpd);
    end
end

% save matrices into a cell array
matrices = {firstGrating, secondGrating, thirdGrating};


%%%% DISPLAY SET-UP %%%%    
% display set-up
% separate the images to remove some degree of cross-talk
% set-up a rect for the fellow eye oval
ovalRect = SetRect(0, 0, widthOfGrid/4, widthOfGrid/4);   
fixOvalRect = CenterRectOnPoint(ovalRect, 480, 540);

% set-up a rect for the dominant eye gratings
gratingRect = SetRect(0, 0, widthOfGrid/2, widthOfGrid/2);   
fixGratingRect = CenterRectOnPoint(gratingRect, 1440, 540);

% supporting text
Screen(win,'TextSize',20); 
Screen(win,'TextFont','clar screen\Arial');
text = sprintf('Click mouse to begin a test run'); 

% display supporting text
% dominant eye
Screen('SelectStereoDrawBuffer', win, domEye);
DrawFormattedText(win, text, 'center', 'center');           % instruction to start the test

% fellow eye
Screen('SelectStereoDrawBuffer', win, felEye);
DrawFormattedText(win, text, 'center', 'center');           % instruction to start the test

% show the changes on the screen
Screen('Flip', win);


%%%% THE ACTUAL DRAWING PART %%%%
% mouse set-up
% restart the position
[mx, my, buttons] = GetMouse;       % wait for mouse button release before starting trial
while any(buttons)                  % if already down, wait for release
    [mx, my, buttons] = GetMouse;
end
while ~any(buttons)                 % wait for new press
    [mx, my, buttons] = GetMouse;
end

% major loop set-up
thirdcomplete = false;
count = 1;

% practice loop set-up
practicecomplete = false;

% practice loop
% terminate when the practice grating has been completed
while practicecomplete == false
    
    % wait for a mouse to be released
    % from the screen promt one is asked to press a button
    while any(buttons)
        [mx, my, buttons] = GetMouse; %#ok<ASGLU>
    end
    
    % display the practice grating
    % separate the two eyes
    % dominant eye
    Screen('SelectStereoDrawBuffer', win, domEye);
    Screen('PutImage', win, grayscaleImageMatrix4, fixGratingRect);
    ShowCursor('Arrow', win);
    
    % fellow eye
    Screen('SelectStereoDrawBuffer', win, felEye);
    Screen('FrameOval', win, [1 1 1]*50, fixOvalRect);
    
    % show the changes on the screen
    Screen('Flip', win, 0, 1);
    
    % drawing set-up
    [X,Y] = GetMouse;
    Points = [X Y];
    Screen('SelectStereoDrawBuffer', win, felEye);
    Screen('DrawLine', win, [1 1 1]*50, X, Y, X, Y);
    
    % drawing
    while (1)
        
        [x,y,buttons] = GetMouse; % wait for new press
        if ~buttons(1)
            break;
        end
        
        % loop the line drawing
        if (x ~= X || y ~= Y)
            Points = [Points; x y];         %#ok<AGROW>
            [numPoints, two] = size(Points);
            Screen('SelectStereoDrawBuffer', win, felEye);
            Screen('DrawLine', win, [1 1 1]*50, Points(numPoints-1,1), Points(numPoints-1, 2), Points(numPoints, 1), Points(numPoints, 2));
            Screen('Flip', win, 0, 1);
            X = x; Y = y;
        end
        
    end
    
    % terminate the programme
    [keyIsDown, junk1, keyCode, junk2] = KbCheck();
    
    if keyIsDown
        practicecomplete = true;
        Screen('Flip', win);                                % refresh the screen
    end
    
    while KbCheck; end                                      % wait till keypress is finished before reporting event
    
end

% supporting text
Screen(win,'TextSize',20); 
Screen(win,'TextFont','clar screen\Arial');
text2 = sprintf('Click mouse to begin the actual test'); 

% display supporting text
% dominant eye
Screen('SelectStereoDrawBuffer', win, domEye);
DrawFormattedText(win, text2 , 'center', 'center');           % instruction to start the test

% fellow eye
Screen('SelectStereoDrawBuffer', win, felEye);
DrawFormattedText(win, text2 , 'center', 'center');           % instruction to start the test

% show the changes on the screen
Screen('Flip', win);

[mx, my, buttons] = GetMouse;       % wait for mouse button release before starting trial
while any(buttons)                  % if already down, wait for release
    [mx, my, buttons] = GetMouse;
end
while ~any(buttons)                 % wait for new press
    [mx, my, buttons] = GetMouse;
end 

% major loop
% terminate when the final grating has been completed
while thirdcomplete == false
    
    % wait for a mouse to be released
    % from the screen promt one is asked to press a button
    while any(buttons)
        [mx, my, buttons] = GetMouse;
    end
    
    % display the first grating
    % separate the two eyes
    % dominant eye
    Screen('SelectStereoDrawBuffer', win, domEye);
    Screen('PutImage', win, matrices{count}, fixGratingRect);
    ShowCursor('Arrow', win);
    
    % fellow eye
    Screen('SelectStereoDrawBuffer', win, felEye);
    Screen('FrameOval', win, [1 1 1]*50, fixOvalRect);
    
    % show the changes on the screen
    Screen('Flip', win, 0, 1);
    
    % drawing set-up
    [X,Y] = GetMouse;
    Points = [X Y];
    Screen('SelectStereoDrawBuffer', win, felEye);
    Screen('DrawLine', win, [1 1 1]*50, X, Y, X, Y);
    
    % drawing
    while (1)
        
        [x,y,buttons] = GetMouse; % wait for new press
        if ~buttons(1)
            break;
        end
        
        % loop the line drawing
        if (x ~= X || y ~= Y)
            Points = [Points; x y];         %#ok<AGROW>
            [numPoints, two] = size(Points);
            Screen('SelectStereoDrawBuffer', win, felEye);
            Screen('DrawLine', win, [1 1 1]*50, Points(numPoints-1,1), Points(numPoints-1, 2), Points(numPoints, 1), Points(numPoints, 2));
            Screen('Flip', win, 0, 1);
            X = x; Y = y;
        end
        
    end
    
    % terminate the programme
    [keyIsDown, junk1, keyCode, junk2] = KbCheck();
    if keyIsDown && count == 1
        
        % save the first grating shown
        imarray = Screen('GetImage',win, fixOvalRect, buffer);      % write contents of screen to array
        cd('C:\\toolbox\\Capstone\\Gratings\\');
        filename = [char(answer) firstname 'cpd' 'Grating.png'];
        imwrite(imarray, filename);
        count = count + 1;                                  % update counter
        Screen('Flip', win);                                % refresh the screen
        
    elseif keyIsDown && count == 2
    
        % save the second grating shown
        imarray = Screen('GetImage',win, fixOvalRect, buffer);      % write contents of screen to array
        cd('C:\\toolbox\\Capstone\\Gratings\\');
        filename = [char(answer) secondname 'cpd' 'Grating.png'];
        imwrite(imarray, filename);
        count = count + 1;                                  % update counter
        Screen('Flip', win);                                % refresh the screen
        
    elseif keyIsDown 
        
        % save the third(final) grating shown
        imarray = Screen('GetImage', win, fixOvalRect, buffer);      % write contents of screen to array
        cd('C:\\toolbox\\Capstone\\Gratings\\');
        filename = [char(answer) thirdname 'cpd' 'Grating.png'];
        imwrite(imarray, filename);
        thirdcomplete = true;                                % update while loop condition
        Screen('Flip', win);
        
    end
    while KbCheck; end % wait till keypress is finished before reporting event
    
end

% finish display
Screen('CloseAll');

% left eye = frontRightBuffer
% right eye = fromtLeftBuffer
