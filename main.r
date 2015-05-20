# Load daily price movements of S&P
sp500 <- read.csv("SP500.csv")
sp500 <- sp500[sp500$VALUE != ".",]

values <- as.numeric(as.character(sp500$VALUE))
histo_probs <- hist(values, breaks=1000, plot=FALSE)
histo_probs$counts=histo_probs$counts/sum(histo_probs$counts)

# sum(histo_probs$counts) == 1

get_daily_move <- function() {
  return (sample(histo_probs$mids, 1, prob=histo_probs$counts))
}

##
# We make the assumption that our hypothetical stock picker has the
# following ability to call the daily market moves
##

# Our stock picker is able to predict with 50% accuracy that they will be UNABLE
# to pick the direction of the S&P 500 on a given day, thus they will sit
# out of the market for the day
# The probability our stock picker skips a day when his guess is incorrect
PREDICT_SKIP_CORRECT_PERCENT = 40

# The probability our stock picker skips a day when his guess is correct
PREDICT_SKIP_INCORRECT_PERCENT = 60

# Our stock picker, once they have decided to enter the market
# is able to guess with 60% accuracy which direction the market will move
PREDICT_DIRECTION_PERCENT = 60

# Our stock picker will repeat their strategy of optionally purchasing
# and selling the S&P every day for 365 days
TRIAL_RUNTIME = 365

# The amount of times this should be simulated
SIMULATION_COUNT = 1000

# The amount of money our stock picker begins with
MONEY=10000

# The commission fee the stock picker pays for each direction of the transaction
COMMISSION_FEE = 6.95

run <- function() {
  successes <- 0
  failures <- 0
  
  greatest_success <- -999999
  worst_failure <- 999999
  
  amounts <- c()
  
  for (sim_index in 1:SIMULATION_COUNT) {
    current_money <- MONEY
    for (day in 1:TRIAL_RUNTIME) {
      
      percent_move = get_daily_move()
      percent_direction = if (percent_move >= 0) 1 else -1
      
      direction_guess <- if(sample(1:100, 1) <= PREDICT_DIRECTION_PERCENT) percent_direction else -percent_direction
      
      # We assume if our stock picker has made the correct decision
	  # then they will not doubt themselves, if they make an incorrect decision there is a chance
	  # that they may abstain from buying that day. This does not reflect reality very well
      will_buy <- if (percent_direction != direction_guess) sample(1:100, 1) <= PREDICT_SKIP_CORRECT_PERCENT else !(sample(1:100, 1) <= PREDICT_SKIP_INCORRECT_PERCENT)
      
      if (will_buy) {
        current_money <- current_money * (1 + direction_guess * 2 * percent_move / 100) - 2 * COMMISSION_FEE
      }
    }
	
	# Count failures, and successes
    if (current_money < MONEY) {
      failures <- failures + 1
    } else {
      successes <- successes + 1
    }
    if (current_money > greatest_success) {
      greatest_success <- current_money
    }
    if (current_money < worst_failure) {
      worst_failure <- current_money
    }
    
    amounts <- c(amounts, current_money)
    
    # Logging
    print(sprintf("On Simulation %d", sim_index))
  }
  print(sprintf("Successes: %d", successes))
  print(sprintf("Greatest Success: $ %f", greatest_success))
  print("-------------")
  print(sprintf("Failures: %d", failures))
  print(sprintf("Worst Failure: $ %f", worst_failure))
  print("-------------")
  print(sprintf("Average Final Amount: $%f", mean(amounts)))
  
  hist(amounts)
  return(amounts)
}
