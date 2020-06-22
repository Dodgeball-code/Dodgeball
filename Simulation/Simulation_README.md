Simulation
=====
This folder contains functions for simulating dodgeball in Python 3.

DBLibrary.py
-----
`heuristicStrat`: Function for the heuristic strategy described by a local optimization problem. Takes in game state information and estimates what proportion of balls should be thrown at the opposing court to optimize victory. Inputs are:
* `N`: Number of players
* `X`: Current state (X1,X2)
* `pe`: Function of a team's state `X[i]` that gives the probability of a successful throw at jail
* `pj`: Function of a team's state `X[i]` that gives the probability of a successful throw at an opposing court
* `Team`: Team throwing either (1 or 2)

`Simulate`: Simulate a game of dodgeball and return the state information of the game, i.e. the number of players `X` and the corresponding time values `T`.
* `N`: Number of players
* `f1`: Probability a player from Team 1 targets the opposing court as a function of the state `X`
* `f2`: Probability a player from Team 2 targets the opposing court
* `pe`: probability a ball thrown at an opposing player hits as a function of the number of opposing players
* `pj`: Probability a ball thrown at jail is caught as a function of the number of teammates in jail
* `L`: Throw rate of each player, default 1
* `Timeout`: Optional input for maximal game time, defaults to False or no time limit
* `Store`: Optional boolean input for whether game data should be returned for each time step (True), defaults to False or only return the final state.
