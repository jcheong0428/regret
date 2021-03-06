
% Two circles. Each circle is a gamble. 
% Shown choice of gamble. choose in 1 s
% Choice is highlighted by green square
% Rotating Arrow appears in center of chosen circle 4s
% Complegte feedback - arrow appear in both circle. 

global p; global d;
% Color parameters
p.black = [0 0 0];
p.white = [255 255 255];
p.green = [150 250 50];
p.yellow = [250 250 50];
p.red = [255 50 50];
p.background = [200 200 200];

Screen('Preference', 'SkipSyncTests', 1);
p.WHICH_SCREEN = min(Screen('Screens'));
xres = 1024; yres = 768;
SetResolution(p.WHICH_SCREEN, xres, yres);
[p.w, p.wRect] = Screen('OpenWindow', p.WHICH_SCREEN, p.background);
[p.w2, ~] = Screen('OpenOffscreenWindow', -1, p.background);
Screen('BlendFunction', p.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % add transparency to images
Screen('BlendFunction', p.w2, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[p.xcen, p.ycen]     = RectCenter(p.wRect);

% Various locations for images
p.lCirc= [p.xcen-250 p.ycen-100 p.xcen-50 p.ycen+100];
p.rCirc= [p.xcen+50 p.ycen-100 p.xcen+250 p.ycen+100];
p.lArrow = [p.xcen-250+60 p.ycen-70 p.xcen-50-60 p.ycen+70];
p.rArrow = [p.xcen+50+60 p.ycen-70 p.xcen+250-60 p.ycen+70];
% Load Arrow
[arrow, ~, alpha] = imread('arrow.png','png');
arrow(:,:,4) = alpha(:,:);
p.arrow = Screen('MakeTexture',p.w,arrow);
% Create background texture. 
Screen('FrameArc',p.w2,p.black,p.lCirc,0,360, 20, 20)
Screen('FrameArc',p.w2,p.black,p.rCirc,0,360, 20, 20)
base = Screen('GetImage',p.w2);
p.base = Screen('MakeTexture',p.w,base,1);
Screen('Close',p.w2);

noPC = 4; % disappoint
noPF = 4; % disappoint
noCF = 4; % regret
noCC = 4; % regret
noRuns = 16; 
noTrials = 12; % 6 follow. 6 choose. 
noDummy = 1; 

bgWin = 200; 
smWin = 50;
bgLoss = -200;
smLoss = -50;

choiceTime = 1; 
spinTime = 4;
resultTime = 2;

keycodes = [KbName('1!'),KbName('2@')];

for run = 1:noRuns
    for trial = 1:noTrials
%Show two gambles
left_angle = 90; right_angle = 180; l_win =bgWin; l_loss = bgLoss; r_win=smWin; r_loss=smLoss;
Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
Screen('FrameArc',p.w,p.red,p.lCirc,0,left_angle, 20, 20);
Screen('FrameArc',p.w,p.red,p.rCirc,0,right_angle, 20, 20);
DrawFormattedText(p.w,num2str(l_win),p.lCirc(1),p.lCirc(2));
DrawFormattedText(p.w,num2str(l_loss),p.lCirc(3)-25,p.lCirc(2));
DrawFormattedText(p.w,num2str(r_win),p.rCirc(1),p.rCirc(2));
DrawFormattedText(p.w,num2str(r_loss),p.rCirc(3)-25,p.rCirc(2));
startTime = Screen('Flip',p.w); 
elapsedTime = GetSecs-startTime;
while elapsedTime < choiceTime
        [pressed, secs, kbData] = KbCheck();
        for i = 1:length(keycodes)
            if kbData(keycodes(i)) == 1
                success = 1;
                c = i;
                rt = secs;
                Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
                Screen('FrameArc',p.w,p.red,p.lCirc,0,left_angle, 20, 20);
                Screen('FrameArc',p.w,p.red,p.rCirc,0,right_angle, 20, 20);
                DrawFormattedText(p.w,num2str(l_win),p.lCirc(1),p.lCirc(2));
                DrawFormattedText(p.w,num2str(l_loss),p.lCirc(3)-25,p.lCirc(2));
                DrawFormattedText(p.w,num2str(r_win),p.rCirc(1),p.rCirc(2));
                DrawFormattedText(p.w,num2str(r_loss),p.rCirc(3)-25,p.rCirc(2));
                if c ==1
                    sqLoc = p.lCirc;locArrow = p.lArrow;regretArrow = p.rArrow;
                else
                    sqLoc = p.rCirc;locArrow = p.rArrow;regretArrow = p.lArrow;
                end
                Screen('FrameRect', p.w, p.green, sqLoc+[-15 -15 15 15], 5);
                Screen('Flip',p.w);
                break;
            end
        end
        elapsedTime =GetSecs-startTime;
end
WaitSecs(choiceTime-elapsedTime); % wait until time is up; not self paced

%Spin arrow

startTime = GetSecs; elapsedTime =GetSecs-startTime;angle = -10;
while elapsedTime < spinTime
    angle = angle +11; if angle > 360; angle = 0; end
    Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
    Screen('FrameArc',p.w,p.red,p.lCirc,0,left_angle, 20, 20);
    Screen('FrameArc',p.w,p.red,p.rCirc,0,right_angle, 20, 20);
    DrawFormattedText(p.w,num2str(l_win),p.lCirc(1),p.lCirc(2));
    DrawFormattedText(p.w,num2str(l_loss),p.lCirc(3)-25,p.lCirc(2));
    DrawFormattedText(p.w,num2str(r_win),p.rCirc(1),p.rCirc(2));
    DrawFormattedText(p.w,num2str(r_loss),p.rCirc(3)-25,p.rCirc(2));
    Screen('FrameRect', p.w, p.green, sqLoc+[-15 -15 15 15], 5);
    Screen('DrawTexture',p.w, p.arrow, [],locArrow,angle);
    
    if regretCondition  % Show arrow spinning on the other side
        angle = angle +16; if angle > 360; angle = 0; end
        Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
        Screen('FrameArc',p.w,p.red,p.lCirc,0,left_angle, 20, 20);
        Screen('FrameArc',p.w,p.red,p.rCirc,0,right_angle, 20, 20);
        DrawFormattedText(p.w,num2str(l_win),p.lCirc(1),p.lCirc(2));
        DrawFormattedText(p.w,num2str(l_loss),p.lCirc(3)-25,p.lCirc(2));
        DrawFormattedText(p.w,num2str(r_win),p.rCirc(1),p.rCirc(2));
        DrawFormattedText(p.w,num2str(r_loss),p.rCirc(3)-25,p.rCirc(2));
        Screen('FrameRect', p.w, p.green, sqLoc+[-15 -15 15 15], 5);
        Screen('DrawTexture',p.w, p.arrow, [],regretArrow,angle2);
    end
    
    Screen('Flip',p.w);
    elapsedTime =GetSecs-startTime;
end

%Show result
WaitSecs(resultTime)

% Save data 
d.angle(run,trial) = angle; d.choice(run,trial) = c; d.rt(run,trial) = rt; 

    end
end

Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
Screen('FrameArc',p.w,p.red,p.lCirc,0,90, 20, 20)
Screen('FrameArc',p.w,p.red,p.rCirc,0,90, 20, 20)
Screen('DrawTexture',p.w, p.arrow, [],[0 0 80 160]);
Screen('Flip',p.w);

Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
Screen('DrawTexture',p.w, p.arrow, [],p.rArrow,50);
Screen('Flip',p.w);
