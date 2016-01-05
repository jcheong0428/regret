function []=coinmining()
global p;
global d;

try
dir = fileparts(which('gamble.m'));
addpath(genpath(dir));
path(path,'subFX');

% Reset random number generator
rand('twister',sum(100*clock));

%% get subject number;
subNum = 1;
% message = 'Please enter the subject number : ';
% subNum = input(message);
p.savePath = [pwd '/data/'];
p.dataFileName = sprintf([p.savePath 'gamble%02d.mat'],subNum);
while exist(p.dataFileName,'file')==2
    message = 'Data for that subject already exists! \n ';
    fprintf(message);
    message = 'Please enter the subject number : ';
    subNum = input(message);
    p.dataFileName = sprintf([p.savePath 'gamble%02d.mat'],subNum);
end

%%
% Put subject in either high ent first low ent first condition
if mod(subNum,2)==1
    d.condition(1) = 2; % High ent first
    d.condition(2) = 1;
else
    d.condition(1) = 1; %  Low ent first
    d.condition(2) = 2;
end

%Record start time of experiment
d.times(1) = GetSecs; % startime.

% Function to setup task parameters. 
Screen('Preference', 'SkipSyncTests', 1); 
setupTaskp;

% Start saving data
save(p.dataFileName,'p','d');
ListenChar(2); % Restrict output to Matlab command
% HideCursor;
%% Instructions
message = ['Welcome!\n\n This experiment consists of two blocks of a set of tasks.\n\n'...
    'You will perform a %d-back memory task followed by a mining task. \n\n'...
    'You will repeat this set of tasks twice. \n\n'...
    'Press SPACE to see instructions for the memory task'];
message = sprintf(message,3);
showMessage(message);
 
isPractice = 1;
exampleScreen(3); 
tic
nbacktask(isPractice,3);
toc

d.prac3.tacc = mean(d.prac3.acc);
d.accs(1,d.condition(1)) = d.prac3.tacc*90; % show 10% less accuracy
d.accs(1,d.condition(2)) = d.prac3.tacc*110; % show 10% increased accuracy
message = ['You''re accuracy for the practice 3-back task was: \n\n'...
           ' %2.2f percent \n\n'...
           'You will not see the feedback from dots in the actual task \n\n'...
           'Press SPACE to see the instructions for the mining task \n\n'];
message = sprintf(message,d.prac3.tacc*100);
showMessage(message);

message = ['Now we will practice the mining task.\n\n'...
    'Press SPACE to see the instructions for the mining task \n\n'];
showMessage(message);

% exampleScreen Mine
exampleScreen_mine;

% Actual Task 
message = ['Good job! Now you will begin the actual experiment.\n\n'...
    'Please let the experimenter know if you have any questions. \n\n'...
    'When you are ready to begin, press SPACE'];
showMessage(message);

%% Actual task loop. 
for block = 1:2
if block ==1
message = ['...About to begin the first block of the experiment...\n\n'...
    'You will not get feedback during the experiment, \n'...
    'but you will be able to see your accuracy at the end of the block. \n\n'...
    'Press SPACE to begin the 3-back task \n\n'];
else 
    message = ['...About to begin the second block of the experiment...\n\n'...
    'You will not get feedback during the experiment, \n'...
    'but you will be able to see your accuracy at the end of the block. \n\n'...
    'Press SPACE to begin the 3-back task \n\n'];
end
message = sprintf(message,block);
showMessage(message);
isPractice = 0; 
tic
nbacktask(isPractice,d.condition(block));
toc

% Show Accuracy 

if d.accs(1,d.condition(block))>100
    d.accs(1,d.condition(block)) = 100; 
elseif d.accs(1,d.condition(block)) < 0
    d.accs(1,d.condition(block)) = 0; 
end
WaitSecs(1);
message = ['You''re accuracy for the 3-back task was: \n\n'...
           ' %2.2f percent \n\n'...
           'Press SPACE to start the mining task \n\n'];
message = sprintf(message,d.accs(1,d.condition(block)));
showMessage(message);

% Coin Mining Task
message = ['You finished the memory task.\n\n'...
    'You''re accuracy for the 3-back task was: \n\n'...
   ' %2.2f percent \n\n'...
    'Press SPACE when you are ready to start the mining task. \n\n'];
message = sprintf(message,d.accs(1,d.condition(block)));
showMessage(message);

message = ['...About to begin the mining task...\n\n'...
    'Press SPACE to continue \n\n'];
showMessage(message);
tic
% Actual task
coinmine(d.condition(block));
toc

if block ==1
    d.breaktime(1) = GetSecs;
    message =['You finished the first set of the experiments. \n\n'...
        'You may take a short break if you''d like.\n\n'...
        'Press SPACE when you are ready to continue the next set.'];
    showMessage(message);
    d.breaktime(2) = GetSecs;
end

end
d.times(2) = GetSecs; % endtime.
save(p.dataFileName,'p','d');

%% Close up experiment
    d.reward = sprintf('%2.2f',(d.mine1.totalcount + d.mine3.totalcount)/100);
    message = ['Thanks for participating! \n\n You mined $ ' d.reward ' ! \n\n Please press SPACE and return to the experimenter.'];
    showMessage(message);
    disp(d.reward);
    save(p.dataFileName,'p','d');
    
    Screen('CloseAll'); %close screen
    ListenChar(0); %allow keystrokes to Matlab
    Priority(0); %return Matlab's priority level to normal
    ShowCursor(0);
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
