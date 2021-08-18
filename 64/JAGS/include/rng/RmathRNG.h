#ifndef RMATH_RNG_H_
#define RMATH_RNG_H_

#include <rng/RNG.h>

namespace jags {

enum NormKind {AHRENS_DIETER, BOX_MULLER, KINDERMAN_RAMAGE};

/**
 * @short RNG object based on the R math library
 * 
 * An RmathRNG object implements the normal and exponential functions
 * using code from the R math library.  
 */
class RmathRNG : public RNG
{
    NormKind _N01_kind;
    double _BM_norm_keep;
public:
    /**
     * @param norm_kind Defines the algorithm for producing normal random
     * variables
     */
    RmathRNG(std::string const &name, NormKind norm_kind);
    double normal();
    double exponential();
};

} /* namespace jags */

#endif /* RMATH_RNG_H_ */
