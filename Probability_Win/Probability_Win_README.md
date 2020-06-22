Probability Win
=====
Finds the probability of winning a game using matrix arithmetic in Matlab R2018a.

Functions
-----
`PWin`: Finds `P1`, the probability that Team 1 wins a game given parameters for a dodgeball game. Uses sparse matrix vector products where the vector denotes the current state and the matrix represents the transition matrix for the Markovian description of dodgeball. Returns the probability that a game is won and a boolean error value (True if the calculation runs too long or there is significant numerical error). Parameters included are
* `N`: Number of players per team,
* `f1`: Probability a player on Team 1 targets a player on the opposing court as a function of the state `X1` and `X2`
* `f2`: Probability a player on Team 2 targets a player on the opposing court
* `pe`: probability a ball tossed at `X` players in a court hits (as a function of `X`)
* `pj`: probability a ball tossed at `Y` players in a jail is caught (as a function of `Y`)

`PWinStalemate`: Finds `P1`, the probability that Team 1 wins a game for a given set of parameters. Implemented by repeatedly squaring the probability transition matrix to create large timesteps. This algorithm is generally slower than `PWin` unless a game's parameters lead to stalemate. Returns the probability that a game is won and a boolean error value (True if the calculation runs too long or there is significant numerical error). Parameters included are
* `N`: Number of players per team,
* `f1`: Probability a player on Team 1 targets a player on the opposing court as a function of the state `X1` and `X2`
* `f2`: Probability a player on Team 2 targets a player on the opposing court
* `pe`: probability a ball tossed at `X` players in a court hits (as a function of `X`)
* `pj`: probability a ball tossed at `Y` players in a jail is caught (as a function of `Y`)
