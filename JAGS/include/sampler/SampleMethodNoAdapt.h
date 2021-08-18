#ifndef SAMPLE_METHOD_NO_ADAPT_H_
#define SAMPLE_METHOD_NO_ADAPT_H_

#include <sampler/MutableSampleMethod.h>

namespace jags {

    /**
     * @short Sampling methods with no adaptive phase
     *
     * Provides trivial implementations of member functions concerned
     * with adaptation for sample methods that have no adaptive phase.
     */
    class SampleMethodNoAdapt : public MutableSampleMethod
    {
      public:
	bool isAdaptive() const { return false; };
	void adaptOff() {};
	bool checkAdaptation() const { return true; };
    };

} /* namespace jags */
    
#endif /* SAMPLE_METHOD_NON_ADAPT_H_ */
