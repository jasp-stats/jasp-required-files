#ifndef GRAPH_H_
#define GRAPH_H_

#include <set>
#include <vector>

namespace jags {

class Node;

/**
 * A graph is a container class for (pointers to) Nodes. A Node may
 * belong to several Graphs. Further, if Node N is in graph G, then
 * there is no requirement that the parents or children of N lie in G.
 *
 * @short Container class for nodes
 */
class Graph : public std::set<Node*> {
  /* forbid copying */
  Graph(Graph const &orig);
  Graph &operator=(Graph const &rhs);
public:
  /**
   * Creates an empty graph
   */
  Graph();
  /**
   * Checks to see whether the node is contained in the Graph.
   */
  bool contains(Node const *node) const;
};

} /* namespace jags */

#endif /* GRAPH_H_ */
