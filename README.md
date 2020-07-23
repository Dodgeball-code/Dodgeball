# Dodgeball
Dodgeball
======
Supplimentary material for the paper "Dodge and survive:  modeling the predatory nature of dodgeball". Contains Python and Matlab code according to a stochastic description of the game dodgeball. Specifically, this project contains files for simulating a game of dodgeball using Python version 3 and for finding the probability of winning a game in stalemate using Matlab version R2018a.

Brief Description of Game
------
In the dodgeball model enclosed, there are two evenly matched teams of N players, where each player has the same throwing rate. Each team has a court and a jail. A player in the Court for Team i has probability `f[i]` of throwing at `X` players in the opposing court, sending an opponent to jail with probability `pe(X)`. Otherwise they throw to `Y` players their jail, saving a player from jail with probability `pj(Y)`. For example, a ball tossed from a player on Team i when that player has `Y` teammates of jail has probability `(1-f[i])pj[Y]` of saving a player from jail. Team i wins the game when they send all opposing players to their respective jail while some players on Team i are still in their Court.
