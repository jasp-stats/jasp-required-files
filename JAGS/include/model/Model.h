#ifndef MODEL_H_
#define MODEL_H_

#include <model/MonitorControl.h>

#include <vector>
#include <list>
#include <string>

namespace jags {

class Sampler;
class SamplerFactory;
struct RNG;
class RNGFactory;
class MonitorFactory;
class Node;
class StochasticNode;
class DeterministicNode;
class ConstantNode;

/**
 * @short Graphical model 
 *
 * The purpose of the model class is to collect together all the
 * elements necessary to run an MCMC sampler on a graphical model.
 */
class Model {
protected:
  std::vector<Sampler*> _samplers;
private:
  unsigned int _nchain;
  std::vector<RNG *> _rng;
  unsigned int _iteration;
  std::vector<Node*> _nodes;
  std::vector<Node*> _extra_nodes;
  std::vector<Node*> _sampled_extra;
  std::list<MonitorControl> _monitors;
  std::vector<StochasticNode*> _stochastic_nodes;
  bool _is_initialized;
  bool _adapt;
  bool _data_gen;
  void initializeNodes();
  void chooseRNGs();
  void chooseSamplers();
  void setSampledExtra();
public:
  /**
   * @param nchain Number of parallel chains in the model.
   */
  Model(unsigned int nchain);
  virtual ~Model();
  /**
   * Initializes the model.  Initialization takes place in three steps.
   *
   * Firstly, random number generators are assigned to any chain that
   * doesn not already have an RNG.
   * 
   * Secondly, all nodes in the graph are initialized in forward
   * sampling order. 
   *
   * Finally, samplers are chosen for informative nodes in the graph.
   *
   * @param datagen Boolean flag indicating whether the model should
   * be considered a data generating model. If false, then
   * non-informative nodes will not be updated unless they are being
   * monitored.  This makes sampling more efficient by avoiding
   * redundant updates.  If true, then all nodes in the graph will be
   * updated in each iteration.
   *
   * @see Node#initialize, Model#rngFactories
   */
  void initialize(bool datagen);
  /** Returns true if the model has been initialized */
  bool isInitialized();
  /**
   * Updates the model by the given number of iterations. A
   * logic_error is thrown if the model is uninitialized.
   *
   * @param niter Number of iterations to run
   */
  void update(unsigned int niter);
  /**
   * Returns the current iteration number 
   */
  unsigned int iteration() const;
  /**
   * Adds a monitor to the model so that it will be updated at each
   * iteration.  This can only be done if Model#adaptOff has been
   * successfully called. Otherwise, a logic_error is thrown.
   */
  void addMonitor(Monitor *monitor, unsigned int thin);
  /**
   * Clears the monitor from the model, so that it will no longer
   * be updated. If the monitor has not previously been added to the
   * model, this function has no effect.
   */
  void removeMonitor(Monitor *monitor);
  /**
   * Returns the list of Monitors 
   */
  std::list<MonitorControl> const &monitors() const;
  /**
   * Adds a stochastic node to the model.  The node must be
   * dynamically allocated.  The model is responsible for memory
   * management of the added node and will delete the node when it is
   * destroyed.
   */
  void addNode(StochasticNode *node);
  /**
   * Adds a deterministc node to the model.  The node must be
   * dynamically allocated.  The model is responsible for memory
   * management of the added node and will delete the node when it is
   * destroyed.
   */
  void addNode(DeterministicNode *node);
  /**
   * Adds a constant node to the model.  The node must be dynamically
   * allocated.  The model is responsible for memory management of the
   * added node and will delete the node when it is destroyed.
   */
  void addNode(ConstantNode *node);
  /**
   * Access the list of sampler factories, which is common to all
   * models. This is used during initialization to choose samplers.
   * Each sampler factory is paired with a boolean flag which is used
   * to determine whether the factory is active or not
   */
  static std::list<std::pair<SamplerFactory *, bool> > &samplerFactories();
  /**
   * Access the list of RNG factories, which is common to all models.
   * Each factory is paired with a boolean flag which is used to determine
   * whether the factory is active or not.
   */
  static std::list<std::pair<RNGFactory *, bool> > &rngFactories();
  /**
   * Access the list of monitor factories, which is commmon to all models
   * Each factory is paired with a boolean flag which is used to determine
   * whether the factory is active or not.
   */
  static std::list<std::pair<MonitorFactory *, bool> > &monitorFactories();
  /**
   * Returns the number of chains in the model
   */
  unsigned int nchain() const;
  /**
   * Returns the RNG object associated with the given chain. If no RNG
   * has been assigned, then a NULL pointer is returned.
   */
  RNG *rng(unsigned int nchain) const;
  /**
   * Assigns a new RNG object to the given chain. The list of
   * RNGFactory objects is traversed and each factory is requested to
   * generate a new RNG object of the given name.
   *
   * @return success indicator.
   */
  bool setRNG(std::string const &name, unsigned int chain);
  /**
   * Assigns an existing RNG object to the given chain
   *
   * @return success indicator
   */
  bool setRNG(RNG *rng, unsigned int chain);
  /**
   * Tests whether all samplers in adaptive mode have passed the
   * efficiency test that allows adaptive mode to be switched off
   *
   * @see Sampler#checkAdaptation
   */
  bool checkAdaptation() const;
  /**
   * Turns off adaptive phase of all samplers.
   *
   * @see Sampler#adaptOff
   */
  void adaptOff();
  /**
   * Indicates whether the model is in adaptive mode (before the
   * adaptOff function has been called).
   */
  bool isAdapting() const;
  /**
   * Returns a vector of all stochastic nodes in the model
   */
  std::vector<StochasticNode*> const &stochasticNodes() const;
  /**
   * Returns a vector of all nodes in the model
   */ 
  std::vector<Node*> const &nodes() const;
};

} /* namespace jags */

#endif /* MODEL_H_ */
