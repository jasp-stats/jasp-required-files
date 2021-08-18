#ifndef GRAPH_MARKS_H_
#define GRAPH_MARKS_H_

#include <map>
#include <set>
#include <vector>

namespace jags {

class Node;
class Graph;

enum LogicalMark {MARK_NULL=0, MARK_TRUE=1, MARK_FALSE=2};

/**
 * @short Annotates the Nodes in a Graph with integer values.
 * 
 * A GraphMarks object associates each node in the graph with an
 * integer mark.  It is used by algorithms that traverse a graph,
 * and which need to keep track of previously visited nodes.
 *
 * For all member functions of the GraphMarks class that take a Node
 * as an argument, the supplied node must belong to the marked graph,
 * or a logic_error exception is thrown.
 *
 * @see Graph
 */
class GraphMarks {
    Graph const &_graph;
    std::map<Node const*,int> _marks;
  public:
    /**
     * Constructor. Each node in the graph initially has mark zero 
     */
    GraphMarks(Graph const &graph);
    ~GraphMarks();
    /**
     * Returns a reference to the marked graph 
     */
    Graph const &graph() const;
    /**
     * Sets the mark of a given node to m. 
     */
    void mark(Node const *node, int m);
    /**
     * Returns the mark of a given node.
     */
    int mark(Node const *node) const;
    /**
     * Resets the mark of all nodes in the graph to zero.
     */
    void clear();
    /**
     * Sets the mark of all parents of the given node in the graph to
     * m.
     */
    void markParents(Node const *node, int m);
    /**
     * Marks the parents of a node in the graph obtained by
     * marginalizing over all nodes for which the test function
     * returns false.
     */
    void markParents(Node const *node, bool (*test)(Node const*), int m);
    /**
     * Marks the ancestors of the node in the graph, i.e. every node N
     * for which there is a directed path from N to node within the
     * graph.
     */
    void markAncestors(std::vector<Node const *> const &nodes, int m);
};

} /* namespace jags */

#endif /* GRAPH_MARKS_H_ */
