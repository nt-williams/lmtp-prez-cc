
# Nick Williams
# Research Biostatistician
# Department of Population Health Sciences
# Weill Cornell Medicine

# packages ----------------------------------------------------------------

library(lmtp)
library(sl3)
library(future)
library(progressr)

# writing shift functions -------------------------------------------------

# How do we communicate an intervention of interest to lmtp? 
# We will use a concept called a shift function. Shift functions
# are user defined R functions with 2 parameters. The first for the 
# name of the data set and the second for the name of the current treatment 
# variable

# the general form is: 
shift.function <- function(data, trt) {
  # some code that modifies the treatment
}

# the shift function should return a vector the same length and type 
# as the observed treatment but modified according the intervention 
# of interest

# For example, a shift function for an intervention that decreases 
# the natural value of the exposure by 5 units would just be: 
down.5 <- function(data, trt) {
  data[[trt]] - 5
}

# this is a general purpose framework that will allow us to work 
# with multiple variable types and implement complex interventions
# We will go over more complex functions throughout

# using sl3 ---------------------------------------------------------------

# the sl3 package is used to implement the Super Learner algorithm
# the analyst must first create sl3 learner stacks which contain the 
# individual models that are to be combined
# this can be done in a couple of ways, but the easiest is to use the 
# make_learner_stack() function

# For example, an ensemble of an intercept only model, a GLM, and a random 
# forest could be created using: 
lrnrs <- make_learner_stack(Lrnr_mean, Lrnr_glm, Lrnr_ranger)

# we can adjust hyperparameters by using a list within make_learner_stack()
# for example, lets adjust the number of trees in that random forest: 
lrnrs <- make_learner_stack(Lrnr_mean, 
                            Lrnr_glm, 
                            list(Lrnr_ranger, num.trees = 1000))

# parallel processing -----------------------------------------------------

# computation time can take a while with lots of time points and observations
# lmtp is setup to use parallel processing based on the future package
# the simplest invocation of this is to use plan(multiprocess) before calling an 
# lmtp estimator

plan(multiprocess)

# progress bars -----------------------------------------------------------

# whats more annoying than long computation time? long computation time 
# with zero user feedback. Don't fret, lmtp is also setup to use progress bars
# through the progressr package
# all you have to do is wrap estimators in with_progress()
with_progress({
  fit <- ...
})
