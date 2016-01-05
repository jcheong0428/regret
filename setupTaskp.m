 function setupTaskp()
% Make variables global. 
 global p;

% Skip sync test.
Screen('Preference', 'SkipSyncTests', 1);

if exist('PsychtoolboxVersion', 'file')
    p.WHICH_SCREEN = max(Screen('Screens'));
else
    p.WHICH_SCREEN = NaN;
end

% devices
if IsWin || IsLinux
    p.D = 0;
else    % mac
    devices = PsychHID('devices');
    p.D = [];
    for i = 1:length(devices)
        if strcmp(devices(i).usageName,'Keyboard')
            p.D = [p.D i];
        end
    end
end

% response buttons
p.keycodes = [KbName('1!'),KbName('2@')];


p.dur_cue = 3.2;                % text duration
p.dur_target = 2.5;             % image duration
p.ISI = [4 6 8];                % interstimulus intervals
p.ITI = [4 6 8];                % intertrial intervals
p.trigger = [KbName('5%') KbName('+') KbName('space')];   % the latter is for computer trigger
nTrials = 13;

% constuct randomized ISIs
B = length(p.ISI);
K = ceil(nTrials/B);
ISI = []; for b = 1:B; ISI=[ISI zeros(1,K)+p.ISI(b)]; end
ISI = ISI(1:nTrials);
ISI = ISI(randperm(nTrials));


% Color parameters
p.black = [0 0 0];
p.white = [255 255 255];
p.green = [150 250 50];
p.yellow = [250 250 50];
p.red = [255 50 50];
p.background = [200 200 200];

% Initialize Psychtoolbox window object.
xres = 1024; yres = 768;
SetResolution(p.WHICH_SCREEN, xres, yres);
[p.w, p.wRect] = Screen('OpenWindow', p.WHICH_SCREEN, p.background);
[p.w2, ~] = Screen('OpenOffscreenWindow', -1, p.background);
Screen('BlendFunction', p.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % add transparency to images
Screen('BlendFunction', p.w2, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[p.xcen, p.ycen]     = RectCenter(p.wRect);
% priorityLevel=MaxPriority(p.w);
% Priority(priorityLevel);

% Various locations for images
p.lCirc= [p.xcen-250 p.ycen-100 p.xcen-50 p.ycen+100];
p.rCirc= [p.xcen+50 p.ycen-100 p.xcen+250 p.ycen+100];
p.lArrow = [p.xcen-250+60 p.ycen-70 p.xcen-50-60 p.ycen+70];
p.rArrow = [p.xcen+50+60 p.ycen-70 p.xcen+250-60 p.ycen+70];

% Timing parameters
p.ansTime = 1.5;
p.ISI = 0.5;
p.textSize=20;
p.ArrowDuration = 4;

Screen('FrameArc',p.w,p.red,[p.xcen p.ycen p.xcen+200 p.ycen+200],0,-180, 20, 20)
Screen('FrameArc',p.w,p.black,[p.xcen p.ycen p.xcen+200 p.ycen+200],0,90, 20, 20)
Screen('Flip',p.w);

p.backLocation = [0 0 xres yres];
p.leftLoc = [p.xcen-250 p.ycen-100 p.xcen-50 p.ycen+100];
p.rightLoc = [p.xcen+50 p.ycen-100 p.xcen+250 p.ycen+100];
p.centerLoc = [p.xcen-100 p.ycen-100 p.xcen+100 p.ycen+100];

% Keyboard parameters
p.Left = KbName('f');
p.Right = KbName('j');

% Parameters for Texts
Screen('TextFont',p.w,'Arial');
Screen('TextSize',p.w,p.textSize);
Screen('TextStyle',p.w,1);
Screen('TextColor',p.w,p.black);
p.wrap = 70;
p.line_spacing = 1.5;
p.ytext = round(4.5*yres/5);

% Use common key naming scheme.
KbName('UnifyKeyNames');
p.fontColor = p.white;

%% Load Arrow
[arrow, ~, alpha] = imread('arrow.png','png');
arrow(:,:,4) = alpha(:,:);
p.arrow = Screen('MakeTexture',p.w,arrow);

%% Setup base background
Screen('FrameArc',p.w2,p.black,p.lCirc,0,360, 20, 20)
Screen('FrameArc',p.w2,p.black,p.rCirc,0,360, 20, 20)
base = Screen('GetImage',p.w2);
p.base = Screen('MakeTexture',p.w,base,1);
Screen('Close',p.w2);
 end



