function [A,Chi]=magnetization(Mp,h,J,b,sn,dn)
    [r,c]= size(Mp);
    F=zeros(r,c,sn);
    for j = 1:sn
        for i = 1:r
            for k=1:c
                Mn = Mp;
                Ep = -J*circlesum(Mp) - h * sum(Mp(:)); % Energy of the current state                               
                % Flip the i-th spin
                if Mp(i,k) == 1
                    Mn(i,k) = -1;
                else
                    Mn(i,k) = 1;
                end
                En = -J*circlesum(Mn) - h * sum(Mn(:)); % Energy of the new state
                dE = En - Ep;
                % Metropolis criterion
                if dE <= 0
                    Mp = Mn;
                else
                    P = exp(-b * dE);
                    if rand < P
                        Mp = Mn;
                    end
                end
            end
        end
        
        F(:,:,j)=Mp;
    end
    
    % Calculate the magnetization
    Mag = sum(F, [1, 2]);  % Sum over rows and columns
    Mag = squeeze(Mag);   % Remove singleton dimensions
    Mag = Mag(dn+1:end);  % Discard the initial transient phase
    A = mean(Mag(:));        % Mean magnetization
   
    % Calculate the susceptibility
    Mag2 = sum(F.^2, [1, 2]);  % Sum over rows and columns of squared magnetization
    Mag2 = squeeze(Mag2);      % Remove singleton dimensions
    Mag2 = Mag2(dn+1:end);     % Discard the initial transient phase
    M2 = mean(Mag2(:));        % Mean of the squared magnetization
    Chi = (M2-A^2)*b; % Susceptibility
end

