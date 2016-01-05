function []=gamble()
    % Neural signatures of regret study
    % For 2s TR: 226 acquisitions.
    %
    % USAGE: gamble(subNum, runNum)
    %   
    % INPUTS:
    %   subNo - subject ID
    %   runNo - Run number
    %
    % datafile contains a structure called 'd' containing the following
    % fields:
    %   .p - options structure
    %   .response - [1 x T] vector of responses for each target (1=true, 2=false)
    %   .rt - [1 x T] vector response times
    %   .cue_onset - [1 x T] vector of cue onset times relative to start of the run
    %   .target_onset - [1 x T] vector of target onset times relative to start of the run
    %   .cue_type - [1 x T] cue type (1=text, 2=image)
    %   .target_type - [1 x T] cue type (1=text, 2=image)
    %
    % Jin Hyun Cheong, Dec 15, 2015
try
global p; global d;
dir = fileparts(which('gamble.m'));
addpath(genpath(dir));
path(path,'subFX');
% Reset random number generator
rand('twister',sum(100*clock));

%% get subject number;
subNum = 1; runNum =1;
p.savePath = [pwd '/data/'];
p.dataFileName = sprintf([p.savePath 'gamble_s%02d_r%02d.mat'],subNum,runNum);
while exist(p.dataFileName,'file')==2
    message = 'Data for that subject already exists! \n ';
    fprintf(message);
    message = 'Please enter the subject number : ';
    subNum = input(message);
    message = 'Please enter the run number : ';
    runNum = input(message);
    p.dataFileName = sprintf([p.savePath 'gamble_s%02d_r%02d.mat'],subNum, runNum);
end
%% ############ setup Params
% Initialize screen
Screen('Preference', 'SkipSyncTests', 1);
if exist('PsychtoolboxVersion', 'file')
%     p.WHICH_SCREEN = max(Screen('Screens'));
    p.WHICH_SCREEN = min(Screen('Screens'));
else
    p.WHICH_SCREEN = NaN;
end
% Initialize Psychtoolbox window object.
xres = 1024; yres = 768;
SetResolution(p.WHICH_SCREEN, xres, yres);
[p.w, p.wRect] = Screen('OpenWindow', p.WHICH_SCREEN, p.background);
[p.w2, ~] = Screen('OpenOffscreenWindow', -1, p.background);
Screen('BlendFunction', p.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % add transparency to images
Screen('BlendFunction', p.w2, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[p.xcen, p.ycen]     = RectCenter(p.wRect);

% devices
if IsWin || IsLinux
    p.D = 0;
else    % mac
    devices = PsychHID('devices');
    p.D = [];
    for i = 1:length(devices)
        if strcmp(devices(i).usageName,'Keyboard')
            p.D = [p.D i]; % get the keyboards.Scanner should be registered as keyboard
        end
    end
end

% response buttons
KbName('UnifyKeyNames');
p.keycodes = [KbName('1!'),KbName('2@')];

% Timing parameters
p.ansTime = 1.5;
p.ISI = 0.5;
p.textSize=20;
p.ArrowDuration = 4;
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
p.fontColor = p.white;
% Various locations for images
p.lCirc= [p.xcen-250 p.ycen-100 p.xcen-50 p.ycen+100];
p.rCirc= [p.xcen+50 p.ycen-100 p.xcen+250 p.ycen+100];
p.lArrow = [p.xcen-250+60 p.ycen-70 p.xcen-50-60 p.ycen+70];
p.rArrow = [p.xcen+50+60 p.ycen-70 p.xcen+250-60 p.ycen+70];
p.backLocation = [0 0 xres yres];
% Parameters for Texts
Screen('TextFont',p.w,'Arial');
Screen('TextSize',p.w,p.textSize);
Screen('TextStyle',p.w,1);
Screen('TextColor',p.w,p.black);
p.wrap = 70;
p.line_spacing = 1.5;
p.ytext = round(4.5*yres/5);
% Use common key naming scheme.

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


%############ RUN EXPERIMENT #################
        
        % wait for trigger
        Screen('FillRect',p.w,opts.black);
        DrawFormattedText(p.w,'waiting for scanner','center','center',p.white,60);
        Screen('Flip',p.w);
        getchoice(opts,inf,trigger);
        run_start = GetSecs;
        
        % loop through trials
        for t = 1:nTrials
            
            % ITI
            Screen('FillRect',opts.window,opts.black);
            DrawFormattedText(opts.window,'+','center','center',opts.white,60);
            Screen('Flip',opts.window);
            getchoice(opts,ITI(t),[]);
            
            % display cue
            Screen('FillRect',opts.window,opts.black);
            if cue_type(t) == 1
                DrawFormattedText(opts.window,cue{t},'center','center',opts.white,60);
            else
                Screen('DrawTexture',opts.window,cue{t});
            end
            Screen('Flip',opts.window);
            dat.cue_onset(t) = GetSecs - run_start;
            getchoice(opts,opts.dur_cue,[]);
            Screen('Flip',opts.window);
            
            % ISI
            Screen('FillRect',opts.window,opts.black);
            DrawFormattedText(opts.window,'+','center','center',opts.white,60);
            Screen('Flip',opts.window);
            getchoice(opts,ISI(t),[]);
            
            % display target
            if target_type(t) == 1
                DrawFormattedText(opts.window,target{t},'center','center',opts.white,60);
            else
                Screen('DrawTexture',opts.window,target{t});
            end
            Screen('Flip',opts.window);
            dat.target_onset(t) = GetSecs - run_start;
            [dat.response(t) dat.rt(t)] = getchoice(opts,opts.dur_target);
            getchoice(opts,opts.dur_target-dat.rt(t));
            Screen('Flip',opts.window);
            
            save(datafile,'dat');
        end
        
        % buffer time at end
        Screen('FillRect',opts.window,opts.black);
        DrawFormattedText(opts.window,'+','center','center',[250 0 0],60);
        Screen('Flip',opts.window);
        WaitSecs(median(opts.ITI));
        getchoice(opts,inf,[]);
        Screen('Flip',opts.window);




catch
    % This "catch" section executes in case of an error in the "try" section []
    % above.  Importantly, it closes the onscreen window if it's open.
    ShowCursor;
    ListenChar(1);
    Screen('CloseAll');
    fclose('all');
    psychrethrow(psychlasterror);
    clear all;
end
end

function [c,rt] = getchoice(opts,timeout,k)
    % c - response
    % rt - response time
    
    if nargin > 2; opts.keycodes = k; end
    
    D = opts.D;
    while KbCheck(D); WaitSecs(0.002); end      %make sure no keys depressed
    
    start_time = GetSecs;
    timeout = timeout + start_time;           %set timeout relative to current time
    escape = KbName('escape');
    
    success = 0; c = 0;
    while success == 0 && GetSecs < timeout
        pressed = 0;
        while pressed == 0 && GetSecs < timeout
            [pressed, ~, kbData] = KbCheck(D);
        end
        if kbData(escape) == 1;
            Screen('CloseAll');
            ShowCursor;
            error('escape!')
        else
            for i = 1:length(opts.keycodes)
                if kbData(opts.keycodes(i)) == 1
                    success = 1;
                    c = i;
                    break;
                end
            end
        end
    end
    
    rt = GetSecs - start_time;
end
