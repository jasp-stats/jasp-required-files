#ifndef DIST_ERROR_H_
#define DIST_ERROR_H_

#include <string>
#include <stdexcept>

namespace jags {

class Distribution;

/**
 * @short Exception class for Distributions
 *
 * This is a convenience class used when throwing a runtime error that
 * concerns a Distribution object.  The error message is synthesized
 * with the name of the distribution.
 */
class DistError : public std::runtime_error {
public:
    DistError(Distribution const *dist, std::string const &msg);
};

} /* namespace jags */

#endif /* DIST_ERROR_H_ */
