#ifndef SLICER_H_
#define SLICER_H_

#include <sampler/MutableSampleMethod.h>

namespace jags {

/**
 * Enumerates different states of the sampler, SLICER_OK means there has
 * been no error, SLICER_POSINF means that the Slicer is stuck at a
 * point of infinite density. SLICER_NEGINF means that current value of
 * the slicer has zero density (or -Inf on the log scale).
 */
enum SlicerState {SLICER_OK, SLICER_POSINF, SLICER_NEGINF};

/**
 * @short Slice Sampling method
 * 
 * The slice sampler is defined by Neal R (2003) Slice Sampling,
 * Ann. Statist.  31; 3: 705-767.
 *
 * This class provides basic infrastructure for slice sampling. 
 *
 * The Slicer class provides no update method. A subclass must provide
 * an update method that calls either updateStep or updateDouble,
 * depending on whether the "stepping out" or "doubling" method is
 * used. The subclass must also provide member functions value,
 * setValue, getLimits and logDensity.
 */
class Slicer : public MutableSampleMethod 
{
    double _width;
    bool _adapt;
    unsigned int _max;
    double _sumdiff;
    unsigned int _iter;
    SlicerState _state;
    bool accept(double xold, double xnew, double z, double L, double R,
		double lower, double upper);
public:
    /**
     * Constructor for Slice Sampler
     *
     * @param width Initial width of slice
     *
     * @param max Maximum number of times initial width of slice will
     * increase at each iteration.
     */
    Slicer(double width, unsigned int max);
    /**
     * Update the current value using the "stepping" method. A Sampler
     * that uses a Slicer can implement Sampler#update by calling this
     * function.
     *
     * @return Success indicator. If the return value is false, then
     * the slicer state is set to show the error that occurred.
     */
    bool updateStep(RNG *rng);
    /**
     * Update the current value using the "doubling" method. A Sampler
     * that uses a Slicer can implement Sampler#update by calling this
     * function.
     *
     * @return Success indicator. If the return value is false, then
     * the Slicer state is set to show the error that occurred.
     */
    bool updateDouble(RNG *rng);
    /**
     * Returns the current value of the Slicer. 
     */
    virtual double value() const = 0;
    /**
     * Sets the value of the Slicer.
     *
     * @param x value to set
     */
    virtual void setValue(double x) = 0;
    /**
     * Gets the lowest and highest possible values of the Slicer
     */
    virtual void getLimits(double *lower, double *upper) const = 0;
    /**
     * Turns off adaptive mode.  
     */
    void adaptOff();
    /**
     * The current adaptation test is very basic, and will return true
     * if a minimum number of iterations (50) have taken place.
     */
    bool checkAdaptation() const;
    /**
     * The slicer method is adaptive.  The step size adapts to the
     * mean distance between consecutive updates
     */
    bool isAdaptive() const;
    /**
     * Returns the log probability density function of the target
     * distribution.
     */
    virtual double logDensity() const = 0;
    /**
     * Returns the state of the sampler.
     */
    SlicerState state() const;
};

} /* namespace jags */

#endif /* SLICER_H_ */
