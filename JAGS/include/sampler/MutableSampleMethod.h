#ifndef MUTABLE_SAMPLE_METHOD_H_
#define MUTABLE_SAMPLE_METHOD_H_

namespace jags {

struct RNG;

/**
 * @short Abstract class for mutable sampling methods 
 */
class MutableSampleMethod
{
public:
    virtual ~MutableSampleMethod();
    /**
     * Draws another sample from the target distribution
     */
    virtual void update(RNG *rng) = 0;
    /**
     * Indicates whether the sample method has an adaptive mode.
     */
    virtual bool isAdaptive() const = 0;
    /**
     * Turns off adaptive mode
     */
    virtual void adaptOff() = 0;
    /**
     * Checks adaptation 
     */
    virtual bool checkAdaptation() const = 0;
};

} /* namespace jags */
    
#endif /* MUTABLE_SAMPLE_METHOD_H_ */
