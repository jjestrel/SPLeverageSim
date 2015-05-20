# SPLeverageSim
A simulation made in R to run possible outcomes in being able to guess the daily direction of the S&amp;P 500 with particular odds and determining success based being able to use 2x (SSO/SDS), 3x (UPRO/SPXU) leveraged ETFs

# Inspiration
The inspiration to make this was brought on by a discussion with a friend claiming he could successfully predict the direction of the market with 60% success (and also knows when he should not participate, i.e knows when he doesn't know the direction). Being able to predict the direction of the market in general is something that is seemingly simpler than predicting the movements of a particular stock. The simulation is intended as a proof that if one were to be able to determine the direction of the market with a 60% success rate they should employ this strategy and see exceedingly high returns.

# Limitations and Assumptions
This simulation makes some assumptions that leave room for improvement. 
* We assume our stock picker begins with $100,000.00
* We assume that market movement is a [random walk](http://en.wikipedia.org/wiki/Random_walk_hypothesis)
* We also assume that on the days that the simulated stock-picker chooses to buy they go all-in with their current amount of money, we also allow for fractional shares. 
* We assume the stock picker is paying a flat ($6.95 * 2) on the sell side of their trade.
* We assume that the stock picker will hold until the end of each day 
* For the sake of example, only 2x leverage will be simulated (but can be extended to 3x by a change of constants)
* Cost of future heart medication required from increased stress of playing daily market movement is ignored
* Only the trailing 10 years of daily market movement could be retrieved, thus the results may be further skewed.
* Each simulation is run over 365 days (365 possible buying periods)
* We assume that the leveraged ETFs would pay *no* cost to maintain their leverage (borrowing/other instruments) which is not true. This will lead to higher returns than what would be possible employing this strategy in real life.

# Conclusions
Ultimately the purpose of this program was to convince someone that if they truly believe they could predict the market's direction with 60% accuracy they should buy 2x and 3x leveraged ETFs on days where they believed they could predict the market movement.

Running the simulation 1000 times lead to the following results:
```
[1] "Successes: 920"
[1] "Greatest Success: $ 511132.699408"
[1] "-------------"
[1] "Failures: 80"
[1] "Worst Failure: $ 46340.775260"
[1] "-------------"
```
Where a `success = currentMoney >= START_MONEY`

and a `failure = currentMoney < START_MONEY`

The following is a histogram where START_MONEY was set to $10,000 for the sake of clarity in reading the histogram. Note the histogram is mislabelled, this does not occur in the running version of the program.
![Results](https://raw.githubusercontent.com/jjestrel/SPLeverageSim/master/sim_results.png)
