% Dichoptic pointing using the Princess graphics

clear all
stereoMode=1; %  1=120Hz shutters; 6=red green anaglyph 9 == Blue-Red anaglyph
AssertOpenGL;
sName='Demo';                 % subject initials
calibsuc=1;
ambEye=0;                   % 0 = left (fellow eye right); 1 = right (fellow eye left)
imSize=256;
targSize=12;
nTestPoints=[4 4];          % m by n array of test points
targCol=[1 1 1]*50;          % color of target dots - black minimizes cross talk
cursorParams=[96 32 3];     % parameters of pointer [gap between lines, line length, line width]
cursorCol=[1 1 1]*50;        % color of cursor lines - black minimizes cross talk
whichScreen = max(Screen('Screens'));
backLum=128;
grnCol=[randi([1 255]) randi([1 255]) randi([1 255])];          % RGB color for green dots
redCol=[255 0 0];           % RGB color for red dots
change=KbName('c'); % for fixation task
%fixAreaTolerancePixels=64; % distance from center of screen that fixation is accepted
%fixFailed=0;

prompt = {'Enter subject name'}; % changes subject name and therefore file id
title = 'Subject name';
lines = 1;
def = {'ABC'};
answer = inputdlg(prompt, title, lines, def);
assignin('base', 'sName', answer{1});

%prompt = {'Enter amblyopic eye 0L 1R'}; % changes amblyopic eye
%title = 'Amblyopic eye';
%lines = 1;
%def = {'0'};
%answer = inputdlg(prompt, title, lines, def);
%answer = str2num('answer');
%assignin('base', 'ambEye', 'answer{1}');

prompt2 = {'Enter amblyopic eye: 0 = left, 1 = right'}; 
title2 = 'Amblyopic eye select';
lines2 = 1;
def2 = {'0'};
answer2 = inputdlg(prompt2, title2, lines2, def2);
                   
if str2num(char(answer2)) == 0  %#ok<ST2NM>
    felEye = 1;
    ambEye = 0;
else
    felEye = 0;
    ambEye = 1;
end

%sif ambEye==0; felEye=1; else felEye=0; end

datafile=sprintf('C:\\toolbox\\Capstone\\DotClicking\\%sDichopticPointing.mat', sName); % data file name

PsychImaging('PrepareConfiguration');
[windowPtr, winRect]=PsychImaging('OpenWindow', whichScreen, backLum, [], [], 4, stereoMode);
HideCursor;

% Set rect sizes

[screenCenterX, screenCenterY] = RectCenter(winRect); % centre of screen
targRect=SetRect(0,0,targSize,targSize);   
fixRect=CenterRect(targRect,winRect);

screenHeight=winRect(4)-winRect(2); % screen height (pixels)
screenWidth=winRect(3)-winRect(1); % screenwidth (pixels)

% ------- End set rect sizes

% if stereoMode==9; % anaglyph glasses
%     SetAnaglyphStereoParameters('LeftGains', windowPtr, [0.0 0.0 1]);
%     SetAnaglyphStereoParameters('RightGains', windowPtr, [1 0.0 0.0]);
% end

Screen(windowPtr,'TextSize',14); % draw text please
Screen(windowPtr,'TextFont','clar screen\Arial');
textToObserver=sprintf('Screen Parameters %d by %d pixels at %3.2f Hz. Click mouse to begin, then click on each target', winRect(3)-winRect(1),winRect(4)-winRect(2), Screen('FrameRate',windowPtr)); % please draw this text in the top left corner of the screen

% separate the two eyes
% one eye
Screen('SelectStereoDrawBuffer', windowPtr, ambEye); % red fixation to amblyopic eye
Screen('FillOval',windowPtr,redCol,fixRect); % draw a circle in the middle of the fixRect rectangle
Screen('DrawText', windowPtr, textToObserver, 100, 100, 255, backLum); % put the textToObserver in white on the screen at 100 x 100 (PTB uses top left of screen as 0,0)

% the other
Screen('SelectStereoDrawBuffer', windowPtr, felEye); % green fixation to fellow eye
Screen('FillOval',windowPtr,grnCol,fixRect);
Screen('DrawText', windowPtr, textToObserver, 100, 100, 255, backLum);

% synch the flipping
vbl=Screen('Flip', windowPtr);% switch to start screen with instructions

 [mx,my,buttons] = GetMouse; % wait for mouse button release before starting trial
while any(buttons) % if already down, wait for release
    [mx,my,buttons] = GetMouse;
end
while ~any(buttons) % wait for new press
    [mx,my,buttons] = GetMouse;
end
[X Y]=meshgrid(round(linspace(1,imSize,nTestPoints(1))),round(linspace(1,imSize,nTestPoints(2))));
targXCentre=X+screenWidth/2-imSize/2;
targYCentre=Y+screenHeight/2-imSize/2;

trialSeq=1:prod(nTestPoints); % test points in random order
trialSeq=Shuffle(trialSeq);
perceivedX=zeros(size(trialSeq));
perceivedY=zeros(size(trialSeq));
nConds=prod(nTestPoints);
nFailedTrials=0;
trialCompleted=zeros(1, nConds);

while any(trialCompleted==0); % this while loop terminates when the trialCompleted matrix is full of 1s
        i = sum(trialCompleted) + 1;
        trialCountText=sprintf('%d',i);
           
        condNo=Randi(nConds); % pick an unfinished condition at random
        while trialCompleted(condNo)>0;
            condNo=Randi(nConds); 
        end
    
        fixCol=grnCol; % put these back to default at start of each trial
        
        while any(buttons) % wait for release of mouse button
            [mx,my,buttons] = GetMouse;
        end
        
       testRect=CenterRectOnPoint(targRect, targXCentre(trialSeq(condNo)),targYCentre(trialSeq(condNo)));
        
        while (1); % this while loop terminates when mouse is clicked.
                 
            %-------------Fixation task - fixation dot changes colour when
            %the letter c is pressed------------------
            
            [keyIsDown, junk1, keyCode, junk2] = KbCheck();
            if keyIsDown
                if keyCode(change) % if c key is pressed
                    grnCol=[randi([1 255]) randi([1 255]) randi([1 255])]; % change colour of central fixation dot
                end
            end
            while KbCheck; end % wait till keypress is finished before reporting event
            
            %--------------End fixation task------

            % Draw fixed point to fellow eye:           
            Screen('SelectStereoDrawBuffer', windowPtr, felEye); % stationary targets to fellow eye 
            Screen('FillOval', windowPtr, targCol, testRect); 
            Screen('FillOval',windowPtr,fixCol,fixRect); % fixation
            Screen('DrawText',windowPtr,trialCountText,1900,1060, 255, backLum); % display i, number of trials successfully completed.
            
            % Draw cursor to amblyopic eye (movement helps minimize suppression):
            Screen('SelectStereoDrawBuffer', windowPtr, ambEye); % moving cursor to amblyopic eye
            Screen('FillOval',windowPtr,fixCol,fixRect); % fixation
            Screen('DrawLine', windowPtr, cursorCol, mx-cursorParams(1)/2-cursorParams(2), my, mx-cursorParams(1)/2, my, cursorParams(3));
            Screen('DrawLine', windowPtr, cursorCol, mx+cursorParams(1)/2, my, mx+cursorParams(1)/2+cursorParams(2), my, cursorParams(3));
            Screen('DrawLine', windowPtr, cursorCol, mx, my-cursorParams(1)/2-cursorParams(2), mx, my-cursorParams(1)/2, cursorParams(3));
            Screen('DrawLine', windowPtr, cursorCol, mx, my+cursorParams(1)/2, mx, my+cursorParams(1)/2+cursorParams(2), cursorParams(3));
            Screen('DrawText',windowPtr,trialCountText,100, 100, 255, backLum); % display i, number of trials successfully completed.
            
            [mx, my, buttons]=GetMouse;
            if buttons(1); break; end
            Screen('Flip', windowPtr); % update screen
        end
         
        perceivedX(trialSeq(condNo))=mx;
        perceivedY(trialSeq(condNo))=my;
    
        trialCompleted(condNo)=1; % otherwise update completed trials matrix
    
end
ShowCursor;
Screen('CloseAll');

xError=reshape(perceivedX, nTestPoints(1),nTestPoints(2))-targXCentre;
yError=reshape(perceivedY, nTestPoints(1),nTestPoints(2))-targYCentre;
trialStart=datestr(now);

datafile=sprintf('C:\\toolbox\\Capstone\\DotClicking\\%sDichopticPointing.mat', sName); % data file name
if exist(datafile,'file') ~= 0 % if data file already exists for this subject - combine new data with old
    newxError=xError; % new data we jsut collected
    newyError=yError;
    load(datafile,'xError', 'yError'); % load the existing data
    oldxError=xError; % assign existing data to old data set
    oldyError=yError;
    dataSize=size(yError); % x*y*nData we already have
    if length(dataSize)<3;
        dataSize(3)=1;
    end
    xError=zeros(dataSize(1), dataSize(2), dataSize(3)+1); % create new data set with 1 extra layer
    yError=zeros(dataSize(1), dataSize(2), dataSize(3)+1);
    xError(:, :, 1:dataSize(3))=oldxError; % in new data set, assign first few layers to odl data
    yError(:, :, 1:dataSize(3))=oldyError;
    xError(:, :, dataSize(3)+1)=newxError; % in new data set, assign first few layers to odl data
    yError(:, :, dataSize(3)+1)=newyError;
end
trialEnd=datestr(now);
save(datafile, 'trialStart', 'trialEnd', 'xError', 'yError', 'perceivedX', 'perceivedY', 'targXCentre', 'targYCentre', 'ambEye', 'nFailedTrials'); % save parameters
clear all

