#ifndef MONITOR_INFO_H_
#define MONITOR_INFO_H_

#include <string>
#include <sarray/Range.h>

namespace jags {

class Monitor;

/**
 * @short Info a monitor 
 */
class MonitorInfo {
    Monitor * _monitor;
    std::string _name;
    Range _range;
    std::string _type;
public:
    /** 
     * Constructor
     * @param monitor Monitor 
     
     */
    MonitorInfo(Monitor *monitor, std::string const &name,
		Range const &range, std::string const &type);
    Monitor *monitor() const;
    std::string const &name() const;
    std::string const &type() const;
    Range const &range() const;
    bool operator==(MonitorInfo const &rhs) const;
};

}

#endif /* MONITOR_INFO_H_ */
