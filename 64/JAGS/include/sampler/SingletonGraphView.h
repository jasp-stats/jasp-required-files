#ifndef SINGLETON_GRAPH_VIEW_H_ 
#define SINGLETON_GRAPH_VIEW_H_

#include <sampler/GraphView.h>

namespace jags {

    /**
     * @short GraphView for a single stochastic node.
     *
     * The SingletonGraphView class provides a simplified interface to
     * the GraphView class when there is only a single node to be
     * sampled.  It should be used in preference to GraphView by any
     * Sampler that acts on a single node.
     *
     * Note that this class is not just syntactic sugar: it provides a
     * compile-time guarantee that only one StochasticNode is being
     * sampled.
     */
    class SingletonGraphView : public GraphView {
      public:
	/**
	 * Constructor
	 *
	 * @param node Node to be sampled 
	 *
	 * @param graph Graph within which sampling is to take place. 
	 */
        SingletonGraphView(StochasticNode * node, Graph const &graph)
	    : GraphView(std::vector<StochasticNode *>(1, node), graph, false) 
	    {} 
	/**
	 * Returns the sampled node.
	 */
	inline StochasticNode * node() const
	{
	    return nodes()[0];
	}
    };
    
} /* namespace jags */

#endif /* SINGLETON_GRAPH_VIEW_H_ */
