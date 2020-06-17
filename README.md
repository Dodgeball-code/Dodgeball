# Dodgeball
Dodgeball
======
Supplimentary material for the paper "Randomness and Dynamics of Dodgeball". Contains Python and Matlab code according to a stochastic description of the game dodgeball. In particular this code uses Matlab R2018a and Python 3. Specifically, this project contains files for simulating dodgeball in Python and for finding the probability of winning a game in Matlab.

Brief Description of Game
------
In the dodgeball model enclosed there are two evenly matched teams each with N players, where every player has the same throwing rate. Each team has a court and a jail. A player in the Court for Team i has probability `f[i]` of throwing at players in the opposing court, sending an opponent to jail with probability `pe`. Otherwise they throw to their jail, saving a player from jail with probability `pj`. The values `pe` and `pj` are functions of the number of players in the targetted court and jail, respectively. For example a ball tossed from a player on Team i when that player has `Y` teammates of jail has probability `(1-f[i])pj[Y]` of saving a player from jail.
