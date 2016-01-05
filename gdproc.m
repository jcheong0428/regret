function self = gdproc(self,param,dims)
        %
        % -----------------------------------------------------------------        
        % 
        % Generates a gaussian decaying process with dims(1) instances and
        % dims(2) arms, and prameters set to param, composed of:
        %
        %  lambda;
        %  theta;
        %  sigma_d;
        %  nu;
        %
        % -----------------------------------------------------------------        
        %
 
        % Set some default values
        if nargin == 1
            param = [0.99,50.0,4.0,2.0];
            dims  = [100,4];
        elseif nargin == 2
            dims  = [100,4];
        end
        
        param  = repmat(param(:),[1,dims(2)]);  
        R = normrnd(zeros(dims),repmat(param(4,:),[dims(1),1]));
        mpg = zeros(dims);
        mpg(1,:) = param(2);
        % Loop on the progress observation
        for i=2:dims(1)
            mpg(i,:) = param(1,:).*mpg(i-1,:) + (1 - param(1,:)).*mpg(1,:) + R(i,:);
        end
        % store information
        self.simInfo.process = normrnd(mpg, repmat(param(3,:),[dims(1),1]));
        self.simInfo.gparam  = mat2dataset(param(:,1)','VarNames',{'l','t','s','n'});
        
        end
