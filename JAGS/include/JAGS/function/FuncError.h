#ifndef FUNC_ERROR_H_
#define FUNC_ERROR_H_

#include <string>
#include <stdexcept>

namespace jags {

class Function;

/**
 * @short Exception class for Functions
 *
 * This is a convenience class used when throwing a runtime error that
 * concerns a Function object.  The error message is synthesized
 * with the name of the function.
 */
class FuncError : public std::runtime_error {
public:
    FuncError(Function const *func, std::string const &msg);
};

} /* namespace jags */

#endif /* FUNC_ERROR_H_ */
