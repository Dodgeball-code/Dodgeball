function [P1, error] = PWinStalemate(N,f1,f2,pe,pj)
%PWIN Finds the probability of winning for two teams in a dodgeball game
%   using matrix exponentiation. This is good for exceedingly long games
%   but inefficient for games of reasonable length (otherwise sparse vector
%   matrix products through the normal power method is more efficient.
%
% input parameters:
%  - N = number of players per team
%  - fi = function of X1 and X2 that gives the probability team i targets
%       the opposing court
%  - pe = function of X as the probability of success of a ball tossed
%       at X players in the opposing court
%  - pj = function of Y as probability of success against Y players in jail
% output parameters:
%  - P1 = probability team 1 wins
%  - error = boolean for if timeout or significant numerical error reached
    
    % empty transition probability matrix 
    % P(i,j) probability going from state i to j
    % not a sparse operation (repeatedly squaring)
    P = (zeros((N+1)^2));
    
    % fill in single step transition matrix
    % inefficient with sparse matrices but that's ok for now.
    for X1 = 0:N
        for X2 = 0:N
            % row we are filling out entries for
            row = index2(N,X1,X2);
            
            % probability next ball is thrown by T2 and hits a player on T1
            if X1 > 0
                col = index2(N,X1-1,X2);
                P(row,col) = X2/(X1+X2)*f2(X1,X2)*pe(X1);
            end
            % probability next ball is thrown by T1 and hits a player on T2
            if X2 > 0
                col = index2(N,X1,X2-1);
                P(row,col) = X1/(X1+X2)*f1(X1,X2)*pe(X2);
            end
            % probability next ball is thrown by T1 and caught in their
            % jail
            if X1 < N
                col = index2(N,X1+1,X2);
                P(row,col) = X1/(X1+X2)*(1-f1(X1,X2))*pj(N-X1);
            end
            % probability next ball is thrown by T2 and caught in their
            % jail
            if X2 < N 
                col = index2(N,X1,X2+1);
                P(row,col) = X2/(X1+X2)*(1-f2(X1,X2))*pj(N-X2);
            end
            
            % no other states to transition to then set absorbing.
            if(sum(P(row,:))==0)
                P(row, row) = 1;
            end        
            % otherwise ignore returning to the same state by normalizing
        end
    end
    
    % clear first row and set 0,0 absorbing
    % otherwise get Nan for 0/0 from Xi/(X1+X2)
    P(index2(N,0,0),:) = 0;
    P(index2(N,0,0),index2(N,0,0)) = 1;
    
    P = normalize(P);
    
    % find the probability of winning in one step
    PW = PWupdate(N,P);
    
    i = 0;                  % index
    eps = 1e-4;             % tolerance for 
    maxIterations = 256;    % maximum times matrix can be squared
                    
    % iterate matrix exponent until sufficiently close to probability of 1
    while(sum(PW)+eps < 1 && i<maxIterations) 
        P = normalize(P);       % keep a right stochastic matrix
        P = P^2;               
        PW = PWupdate(N,P);     % update win probabilities
        i = i+1;              
    end
    
    eps = 1e-4;             % new tolerance for overshoot
    % if probability of winning is unreasonably large or timeout
    if(sum(PW)-eps > 1 || i>=maxIterations)
        error = true;
    else
        error = false;
    end
    
    % only give probability for Team 1.
    P1 = PW(1);
end




% transform (X1,X2) into a 1D index
function [i] = index2(N,X1,X2)
    i = (N+1)*X1 + X2 + 1;
end




% normalize matrix as a right stochastic matrix
function M = normalize(M)
    M = M./sum(M,2);
end




% check win probability with current matrix
%   P  - probability transition matrix at current step
%   PW - probability of winning as a vector for Team 1 and Team 2
function PW = PWupdate(N,P)
    PW = [0 0];
    
    for i = 1:N
        PW(1) = PW(1) + P(index2(N,N,N),index2(N,i,0));
        PW(2) = PW(2) + P(index2(N,N,N),index2(N,0,i));
    end
    
end