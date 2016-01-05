function [rpe, regret,choice]=checkorthogonal(payoff);

%% Get reward prediction errors
ev = nan(length(payoff),2);
choice = size(length(payoff),1);
rpe = zeros(length(payoff),2);
lr = 1; % learning rate

for i = 1:length(payoff)
    if i ==1; 
        cc=1; nc=2;
        choice(1) = cc; % choose first choice at random
        ev(1,cc) = payoff(1,cc);
        ev(1,nc) = payoff(1,nc);
        ev(i+1,cc) = payoff(1,cc);
        ev(i+1,nc) = payoff(1,nc);
    else
        ev(i,cc) = ev(i-1,cc)+lr*rpe(i-1,cc); 
        ev(i,nc) = ev(i-1,nc);
        if ev(i,1) > ev(i,2) 
            choice(i) = 1; cc = 1; nc = 2; 
            rpe(i,cc) = payoff(i,cc)-ev(i,cc);
        elseif ev(i,1) < ev(i,2)
            choice(i) = 2; cc =2; nc = 1;
            rpe(i,cc) = payoff(i,cc)-ev(i,cc);
        end
    %% Get Counterfactual errors
    regret(i) = max(payoff(i,nc)-payoff(i,cc),0);
    end
end
end
