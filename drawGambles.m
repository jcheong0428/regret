function [angle]=drawGambles(left_angle,right_angle,showArrow,ArrowLocation)
global p;
left_angle = 15; 
right_angle = 90;
Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
Screen('FrameArc',p.w,p.red,p.lCirc,0,left_angle, 20, 20);
Screen('FrameArc',p.w,p.red,p.rCirc,0,right_angle, 20, 20);

%% spin arrow
if ArrowLocation == 0
    locArrow = p.lArrow;
elseif ArrowLocation ==1;
    locArrow = p.rArrow;
end

if showArrow
    startTime = GetSecs();
    elapsedTime = GetSecs - startTime;
    while elapsedTime < p.ArrowDuration
        for angle = 0:15:360
            Screen('DrawTexture',p.w,p.base);   % Background with the two circles. 
            Screen('FrameArc',p.w,p.red,p.lCirc,0,left_angle, 20, 20);
            Screen('FrameArc',p.w,p.red,p.rCirc,0,right_angle, 20, 20);
            Screen('DrawTexture',p.w, p.arrow, [],locArrow,angle);
            Screen('Flip',p.w);
        end
    elapsedTime = GetSecs - startTime;
    end
end
end