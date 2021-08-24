#ifndef VECTOR_LOG_DENSITY_H_
#define VECTOR_LOG_DENSITY_H_

#include <function/VectorFunction.h>

namespace jags {
    
    class VectorDist;

    /**
     * @short Log density function for a vector-valued Distribution
     */
    class VectorLogDensity : public VectorFunction
    {
	VectorDist const *_dist;
    public:
	VectorLogDensity(VectorDist const *dist);
	unsigned int length(std::vector<unsigned int> const &lengths,
			    std::vector<double const *> const &values) const;
	bool checkParameterLength(std::vector<unsigned int> const &lens) const;
	bool checkParameterValue(std::vector<double const *> const &args,
				 std::vector<unsigned int> const &lens) const;
	void evaluate(double *value,
		      std::vector <double const *> const &args,
		      std::vector<unsigned int> const &lens) const;
    };

}

#endif /* VECTOR_LOG_DENSITY_H_ */
