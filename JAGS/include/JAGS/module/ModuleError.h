#ifndef MODULE_ERROR_H_
#define MODULE_ERROR_H_

#include <string>

namespace jags {

class Node;
class Distribution;
class Function;

void throwRuntimeError(std::string const &message);
void throwLogicError(std::string const &message);
void throwNodeError(Node const *node, std::string const &message);
void throwDistError(Distribution const *dist, std::string const &message);
void throwFuncError(Function const *func, std::string const &message);

} /* namespace jags */

#endif /* MODULE_ERROR_H_ */
