#ifndef NODE_ERROR_H_
#define NODE_ERROR_H_

#include <stdexcept>
#include <iostream>

namespace jags {

    class Node;
    class SymTab;

    /**
     * @short Exception class for Nodes
     */
    class NodeError : public std::runtime_error {
	Node const * _node;
    public:
	NodeError(Node const *node, std::string const &msg);
	void printMessage(std::ostream &out, SymTab const &symtab) const;
    };

} /* namespace jags */

#endif /* NODE_ERROR_H_ */
