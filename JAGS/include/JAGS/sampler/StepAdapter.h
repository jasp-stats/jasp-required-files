#ifndef STEP_ADAPTER_H_
#define STEP_ADAPTER_H_

#include <sampler/Metropolis.h>

namespace jags {

/**
 * @short Step size for Random Walk Metropolis-Hastings
 *
 * Uses a noisy gradient algorithm to adapt the step size of a random
 * walk Metropolis-Hastings algorithm to reach the target acceptance
 * probability.
 */
class StepAdapter 
{
    const double _prob;
    double _lstep;
    bool  _p_over_target;
    unsigned int _n;
public:
    /**
     * Constructor. 
     *
     * @param step Initial step size for the random walk updates.
     * @param prob Target acceptance probability. The default seems to
     *              be a fairly robust optimal value.
     */
    StepAdapter(double step, double prob = 0.234);
    /**
     * Recalculates the step size.
     * @param p acceptance probability
     */
    void rescale(double p);
    /**
     * Returns the current step size
     */
    double stepSize() const;
    /**
     * Returns the distance, on a logistic scale, between the argument
     * p and the target acceptance probability.
     */
    double logitDeviation(double p) const;
};

} /* namespace jags */

#endif /* STEP_ADAPTER_H_ */
