function checkorthogonal(payoff)

%% Get reward prediction errors

for i = 1:length(payoff)
    if payoff(i,1) > payoff(i,2) 
    
    elseif payoff(i,1) < payoff(i,2)
        
    else
        
    end
end


%% Get Counterfactual errors

regret(i) = max(choicepayoff-missedpayoff,0);

end
