function payoff = payoffdraw(meanpayoff)
% take in mean payoff, probably from function gdproc()
% generates rewards drawn from a Gaussian with standard deviation 4, 
% the mean from the gdproc random walk. 

s = size(meanpayoff);
rows = s(1); columns=s(2);

payoff = nan(rows,columns);
sigma = 4; % standard deviation used in (Daw et al., 2006 Nature)

for c = 1:columns
    for r = 1:rows
        mu = round(meanpayoff(r,c)); % average rounded to nearest integer
        payoff(r,c) = normrnd(mu,sigma);
    end
end

end