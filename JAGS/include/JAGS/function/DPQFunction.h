#ifndef DPQ_FUNCTION_H_
#define DPQ_FUNCTION_H_

#include <function/ScalarFunction.h>

namespace jags {

    class RScalarDist;

    /**
     * @short Functions derived from R Scalar distributions
     *
     * The DPQFunction class exposes member functions of the class
     * RScalarDist as BUGS functions so that they can be called by the
     * user. These are the density (D), cumulative probability (P),
     * and quantile (Q) functions.
     *
     * D-P-Q functions are generated automatically when an
     * RScalarFunction is inserted into the Module.
     *
     * @seealso Module#insert
     */
    class DPQFunction : public ScalarFunction
    {
	RScalarDist const *_dist;
    public:
	DPQFunction(std::string const &name, RScalarDist const *dist);
	/**
         * Returns the distribution from which the function is derived
         */
	RScalarDist const *dist() const;
	/**
	 * If an RScalarDist has m parameters, then a DPQFunction
	 * derived from it will have (m+1) arguments. To check the
	 * validity of the arguments, we strip off the first one and
	 * then pass the rest to ScalarDist#checkParameterValue
         */
	bool checkArgs(std::vector<double const *> const &args) const;
    };

}

#endif /* DPQ_FUNCTION_H_ */
