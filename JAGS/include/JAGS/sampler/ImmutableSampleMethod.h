#ifndef IMMUTABLE_SAMPLE_METHOD_H_
#define IMMUTABLE_SAMPLE_METHOD_H_

namespace jags {

    struct RNG;

    /**
     * @short Abstract class for immutable sampling methods 
     */
    class ImmutableSampleMethod
    {
      public:
	virtual ~ImmutableSampleMethod();
	/**
	 * Draws another sample from the target distribution
	 */
	virtual void update(unsigned int chain, RNG *rng) const = 0;
    };

} /* namespace jags */
    
#endif /* IMMUTABLE_SAMPLE_METHOD_H_ */
