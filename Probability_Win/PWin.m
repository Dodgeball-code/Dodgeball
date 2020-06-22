function [P1, error] = PWin(N,f1,f2,pe,pj)
%PWIN Finds the probability of winning for two teams in a dodgeball game
%   using sparse matrix vector products. This is good for shorter games
%   but inefficient for games in stalemate
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
    
    % generate nonzero entries transition matrix for sparse matrix
    % give more space for initial vectors than needed
    rows = zeros(4*N^2,1);
    cols = zeros(4*N^2,1);
    entries = zeros(4*N^2,1);
    % index
    i = 1;
    for X1 = 0:N
        for X2 = 0:N
            % corner case
            if X1+X2 == 0
                rows(i) = index2(N,0,0);
                cols(i) = index2(N,0,0);
                entries(i) = 1;
                i = i+1;
            else
                
            % probability transition to new state
            PExit = X2/(X1+X2)*(f2(X1,X2)*pe(X1)+(1-f2(X1,X2))*pj(N-X2))+...
                  X1/(X1+X2)*(f1(X1,X2)*pe(X2)+(1-f1(X1,X2))*pj(N-X1));
            % use to ignore returning to same state
              
            if PExit == 0
                rows(i) = index2(N,X1,X2);
                cols(i) = index2(N,X1,X2);
                entries(i) = 1;
                i = i+1;
            else
            % probability next ball is thrown by T2 and hits a player on T1
            if X1 > 0
                rows(i) = index2(N,X1,X2);
                cols(i) = index2(N,X1-1,X2);
                entries(i) = X2/(X1+X2)*f2(X1,X2)*pe(X1) / PExit;
                i = i+1;
            end
            % probability next ball is thrown by T1 and hits a player on T2
            if X2 > 0
                rows(i) = index2(N,X1,X2);
                cols(i) = index2(N,X1,X2-1);
                entries(i) = X1/(X1+X2)*f1(X1,X2)*pe(X2) / PExit;
                i = i+1;
            end
            % probability next ball is thrown by T1 and caught in their
            % jail
            if X1 < N
                rows(i) = index2(N,X1,X2);
                cols(i) = index2(N,X1+1,X2);
                entries(i) = X1/(X1+X2)*(1-f1(X1,X2))*pj(N-X1) / PExit;
                i = i+1;
            end
            % probability next ball is thrown by T2 and caught in their
            % jail
            if X2 < N 
                rows(i) = index2(N,X1,X2);
                cols(i) = index2(N,X1,X2+1);
                entries(i) = X2/(X1+X2)*(1-f2(X1,X2))*pj(N-X2) / PExit;
                i = i+1;
            end
            end
            
            end
        end
    end
    
    % remove extra entries
    rows(i:end) = [];
    cols(i:end) = [];
    entries(i:end) = [];
    
    P = sparse(rows,cols,entries);
    
    v = zeros(1,(N+1)^2);
    v(index2(N,N,N)) = 1;
    
    PW = PWupdate(N,v);
    
    n = 0;                  % number of iterations
    eps = 1e-4;             % tolerance for 
    maxIterations = 500*N^2;  % maximum timesteps
    % this number of iterations should be comparable to the time of the
    % stalemate algorithm...
                    
    % iterate matrix exponent until sufficiently close to probability of 1
    while(sum(PW)+eps < 1 && n<maxIterations) 
        v = normalize(v);       % keep a right stochastic matrix
        v = v*P;               
        PW = PWupdate(N,v);     % update win probabilities
        n = n+1;              
    end
    
    eps = 1e-4;             % new tolerance for overshoot
    % if probability of winning is unreasonably large or timeout
    if(sum(PW)-eps > 1 || n>=maxIterations)
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




% normalize vector to be a probability
function v = normalize(v)
    v = v./sum(v);
end




% check win probability with current matrix
%   v  - distribution of states at current timestep
%   PW - probability of winning as a vector for Team 1 and Team 2
function PW = PWupdate(N,v)
    PW = [0 0];
    
    for i = 1:N
        PW(1) = PW(1) + v(index2(N,i,0));
        PW(2) = PW(2) + v(index2(N,0,i));
    end
    
end