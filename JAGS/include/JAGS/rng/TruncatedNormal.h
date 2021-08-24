#ifndef TRUNCATED_NORMAL_H_
#define TRUNCATED_NORMAL_H_

namespace jags {

struct RNG;

/**
 * Draws a random sample from a left-truncated normal distribution.
 *
 * @param left Left limit of the truncated distribution
 * @param rng Pointer to a Random Number Generator
 * @param mu Mean of untruncated distribution
 * @param sigma Standard deviation of untruncated distribution
 */
double lnormal(double left, RNG *rng, double mu = 0, double sigma = 1);

/**
 * Draws a random sample from a right-truncated normal distribution.
 *
 * @param right Right limit of the distribution
 * @param rng Pointer to a Random Number Generator
 * @param mu Mean of untruncated distribution
 * @param sigma Standard deviation of untruncated distribution
 */
double rnormal(double right, RNG *rng, double mu = 0, double sigma = 1);

/**
 * Draws a random sample from an interval-truncated normal distribution.
 *
 * @param left Left limit of the distribution
 * @param right Right limit of the distribution
 * @param rng Pointer to a Random Number Generator
 * @param mu Mean of untruncated distribution
 * @param sigma Standard deviation of untruncated distribution
 */
double inormal(double left, double right, RNG *rng, 
	       double mu = 0, double sigma = 1);

} /* namespace jags */

#endif /* TRUNCATED_NORMAL_H_ */
