#############################################
############# Dodgeball library #############
#############################################

# Date: May 28, 2020
# Authors: Perrin Ruth, Jaun Restrepo

# libraries
import numpy as np
import random as rand
import matplotlib.pyplot as plt

####################### Some Probabalistic Functions #######################
# uniform distribution
def U():
    return rand.uniform(0.0,1.0)

# generate an exponential rv with rate r, uses the inverse CDF method
# unnecessary, but it's a classic
def exp(r):
    return -np.log(U())/r



############################ Heuristic strategy ############################
# Heuristic strategy for dodgeball games
# Inputs:
#   -   N  = # players per team, should be a natural number
#   -   X = current number of players on each team as a list
#   -   pe = Probability successfully hit at an enemy. Function of # people in enemy team.
#   -   pj = Probability successfully hit a teammate in jail. Function of # people in jail.
#   -   Team = team that is throwing (1 or 2)
def strat(N,X,pe,pj,Team):
    i = Team - 1  # format as an index, opposing team is 1-i
    # as defined in paper:
    if X[i]/(sum(X)-1)*pe(X[1-i]) >= X[1-i]/(sum(X)+1)*pj(N-X[i]):
        return 1
    else:
        return 0
    


#################################### Dodgeball model ####################################

# Simulate a dodgeball game according to exact model with N players per team.
# Inputs:
#   -   N  = # players per team, should be a natural number
#   -   f1 = Boolean function returns 1 when a player from team 1 targets enemy team,
#               returns 0 otherwise. Takes inputs of X1, X2
#   -   f2 = Same as f1 except for team 2.
#   -   pe = Probability successfully hit at an enemy. Function of # people in enemy team.
#   -   pj = Probability successfully hit a teammate in jail. Function of # people in jail.
#   -   L  = average player throw rate (like lambda)
#   -   Timeout = Optional game length, defaults to no game limit (False)
#   -   Store   = Set to True if all values should be stored in the simulation, 
#               False only stores the final player counts and time (default False)
# Outputs
#   -   X  = Vector/Final value of # of players in each team (See Store).
#   -   T  = Vector of time values at each measured pair of X values.
def Simulate(N, f1, f2, pe, pj, L = 1, Timeout = False, Store = False):
    # store in array notation notation for simpler writing
    f = [f1, f2]
    
    # Initialize team counts and time
    X = [N,N]   # team counts at current time
    T = 0       # current game time
    
    # if the whole game is desired
    if Store:
        XS = [[N], [N]]   # list of player counts
        TS = [0]          # list of times according to each player count
    
    # Begin Simulation:
    # store all new values
    while X[0] > 0 and X[1] > 0:
        # Generate change in players and time
        dx,dt = __step(N,X,L,f,pe,pj)
               
        # update new states
        X[0], X[1] = X[0]+dx[0], X[1]+dx[1]
        T = T+dt
        if Store:
            XS[0].append(X[0])
            XS[1].append(X[1])
            TS.append(T)
            
        # Checkout if time limit passed if available
        if Timeout:
            if T >= Timeout:
                if Store:
                    return XS, TS
                else:
                    return X, T
              
    # done with simulation return data
    if Store:
        return XS, TS
    else:
        return X, T
        
        

# step - steps simulation through to the next throw (private function used for simulate)
# Inputs
#   -   N = total # of players per team
#   -   X = number of players currently in each court as a list
#   -   L = mean player throw rate
#   -   f = probability a team targets the opposing court as a list of functions
#   -   pe = probability a ball tossed at X players in opposing court succeeds
#   -   pj = probability a ball tossed at Y players in jail succeeds
# Outputs
#   -   dx = time to next toss
#   -   dt = change in player counts after toss
def __step(N,X,L,f,pe,pj):
    # generate probability of hitting or state change
    # used to ignore potential no change state.
    P = X[0]/(X[0]+X[1]) * (f[0](X)*pe(X[1]) + (1-f[0](X))*pj(N-X[0]))     # prob. T1 throws & hits
    P = P + X[1]/(X[0]+X[1]) * (f[1](X)*pe(X[0]) + (1-f[1](X))*pj(N-X[1])) # +prob. T2 throws & hits
    
    # generate next throw time
    dt = exp(L*sum(X)*P)
    
    # initialize change vector
    dx = [0,0]
    
    # determine result
    u = U()
    # if tossed by T1 at T2 court
    if u <= X[0]/(X[0]+X[1]) * f[0](X) * pe(X[1])/P:
        # T2 loses a player to jail
        dx[1] = -1
        return dx, dt
    # else remove that probability
    u = u - X[0]/(X[0]+X[1]) * f[0](X) * pe(X[1])/P
    
    
    # if tossed by T2 at T1 court
    if u <= X[1]/(X[0]+X[1]) * f[1](X) * pe(X[0])/P:
        # T1 loses a player
        dx[0] = -1
        return dx, dt
    # else remove that probability
    u = u - X[1]/(X[0]+X[1]) * f[1](X) * pe(X[0])/P
    
    
    # if T1 saved player from jail
    if u <= X[0]/(X[0]+X[1]) * (1-f[0](X)) * pj(N-X[0])/P:
        # T1 gains a player
        dx[0] = 1
    
    # else T2 saved a player from jail
    else:
        dx[1] = 1
    return dx, dt


