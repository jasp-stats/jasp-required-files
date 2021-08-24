#ifndef MONITOR_FACTORY_H_
#define MONITOR_FACTORY_H_

#include <string>
#include <vector>

namespace jags {

class Monitor;
class Node;
class BUGSModel;
class Model;
class Range;

/**
 * @short Factory for Monitor objects
 */
class MonitorFactory {
public:
    virtual ~MonitorFactory();
    /**
     * Creates a monitor of the given type by name and range. If a
     * monitor cannot be created, then a null pointer is returned.
     *
     * @param name Name of the monitored object. This is typically a 
     * node array.  
     *
     * @param range Range describing the subset, if any, to be monitored.
     * A NULL range is used to monitor the whole object
     *
     * @param model Pointer to a BUGSModel
     *
     * @param type String indicating what type of monitor is requested
     *
     * @param msg An error message may be written to this argument on
     * exit if the monitor cannot be created due to an error.  It is
     * not necessary to write an error message if the request for the
     * monitor lies outside the scope of the factory (e.g. the factory
     * cannot create monitors of the requested type). This is not considered
     * an error as all factories will be interrogated in turn until one
     * returns the requested monitor.
     */
    virtual Monitor *getMonitor(std::string const &name, Range const &range,
				BUGSModel *model, std::string const &type,
				std::string &msg) = 0;
    /**
     * Returns the name of the monitor factory
     */
    virtual std::string name() const = 0;
};

} /* namespace jags */

#endif /* MONITOR_FACTORY_H_ */
