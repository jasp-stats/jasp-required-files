#ifndef PARENT_ERROR_H_
#define PARENT_ERROR_H_

#include <stdexcept>
#include <iostream>

namespace jags {

    class Node;
    class SymTab;

    /**
     * @short Exception class for invalid parent values
     */
    class ParentError : public std::runtime_error {
	Node const * _node;
	unsigned int _chain;
    public:
	ParentError(Node const *node, unsigned int chain);
	void printMessage(std::ostream &out, SymTab const &symtab) const;
    };

} /* namespace jags */

#endif /* PARENT_ERROR_H_ */
