#ifndef LINEAR_H_
#define LINEAR_H_

#include<vector>

namespace jags {

class GraphView;
class SingletonGraphView;
class Graph;
class StochasticNode;

/**
 * Helper function to check additivity. The function returns true if
 * all deterministic descendants within the given SingletonGraphView
 * are additive functions of the sampled node.
 *
 * @param gv GraphView to be tested.
 *
 * @param fixed Boolean flag. If true, the function checks for 
 * additive functions with a fixed intercept.
 *
 * @see Node#isClosed
 */
bool checkAdditive(SingletonGraphView const *gv, bool fixed);

/**
 * Helper function to check additivity. The function returns true if
 * all deterministic descendants of the nodes within the graph are
 * additive functions.
 *
 * @param snodes Vector of nodes to be tested.
 *
 * @param graph Enclosing graph for gv
 *
 * @param fixed Boolean flag. If true, the function checks for 
 * additive functions with a fixed intercept.
 *
 * @see Node#isClosed
 */
bool checkAdditive(std::vector<StochasticNode*> const &snodes,
		   Graph const &graph, bool fixed);

/**
 * Helper function to check linearity. The function returns true if
 * all deterministic descendants within the given GraphView are linear
 * functions.
 *
 * @param gv GraphView to be tested.
 *
 * @param fixed Boolean flag. If true, the function checks for fixed
 * linear functions.
 *
 * @param link Boolean flag. If true, then the function tests for a
 * generalized linear model, allowing the last deterministic
 * descendants (i.e. those with no deterministic children) to be link
 * functions.
 *
 * @see Node#isClosed
 */
bool checkLinear(GraphView const *gv, bool fixed, bool link=false);

/**
 * Helper function to check for scale transformations. The function
 * returns true if all deterministic children within the given
 * GraphView are scale transformations or scale-mixture
 * transformations.
 *
 * @param gv GraphView to be tested.
 *
 * @param fixed Boolean flag. If true, the function checks for fixed
 * scale transformations.
 *
 * @see Node#isClosed
 */
bool checkScale(GraphView const *gv, bool fixed);

/**
 * Helper function to check for power transformations. The function
 * returns true if all deterministic descendants of the given node
 * (within the given graph) are power transformations.
 *
 * @param gv GraphView to be tested.
 *
 * @param fixed Boolean flag. If true, the function checks for fixed
 * power transformations.
 *
 * @see Node#isClosed
 */
bool checkPower(GraphView const *gv, bool fixed);

} /* namespace jags */

#endif /* LINEAR_H_ */
