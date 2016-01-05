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