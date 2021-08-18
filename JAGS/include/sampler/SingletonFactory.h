#ifndef SINGLETON_FACTORY_H_
#define SINGLETON_FACTORY_H_

#include <sampler/SamplerFactory.h>

namespace jags {

/**
 * @short Factory object for a Sampler that samples a single node
 *
 * Many Sampler objects update a singe StochasticNode (and its
 * deterministic descendants).  This is a convenience class designed
 * to make it easier to create a factory object for such samplers.
 */
class SingletonFactory : public SamplerFactory
{
public:
    /**
     * Determines whether the factory can produce a Sampler for the
     * given node, within the given graph. This function is called
     * by SingletonFactory#makeSamplers
     */
    virtual bool canSample(StochasticNode *node, Graph const &graph) 
	const = 0;
    /**
     * Returns a dynamically allocated Sampler for a given node. This
     * function is called by SingletonFactory#makeSamplers.
     */
    virtual Sampler *makeSampler(StochasticNode *node,
				 Graph const &graph) const = 0;
    /**
     * This traverses the list of available nodes, creating a Sampler,
     * when possible, for each individual StochasticNode.
     */
    std::vector<Sampler*> makeSamplers(std::list<StochasticNode*> const &nodes, 
				       Graph const &graph) const;
};

} /* namespace jags */

#endif /* SINGLETON_FACTORY_H */
