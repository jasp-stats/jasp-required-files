#ifndef MONITOR_CONTROL_H_
#define MONITOR_CONTROL_H_

#include <sarray/Range.h>

namespace jags {

class Monitor;

/**
 * @short Control a monitor 
 */
class MonitorControl {
    Monitor * _monitor;
    unsigned int _start;
    unsigned int _thin;
    unsigned int _niter;
public:
    /** 
     * Constructor
     * @param monitor Monitor that will be under control
     * @param start   First iteration to be monitored
     * @param thin    Thinning interval for monitor
     */
    MonitorControl(Monitor *monitor, unsigned int start, unsigned int thin);
    /**
     * Updates the monitor. If the iteration number coincides with
     * the thinning interval, then the update function of the Monitor
     * is called function is called.
     *
     * @param iteration The current iteration number.
     */
    void update(unsigned int iteration);
    /**
     * Reserves enough memory for a further niter iterations, taking
     * account of the thinning interval of the monitor.
     * @see Monitor#reserve
     */
    void reserve(unsigned int niter);
    /**
     * Returns the monitor under control.
     */
    Monitor const *monitor() const;
    /**
     * First iteration monitored
     */
    unsigned int start() const;
    /**
     * Last iteration monitored
     */
    unsigned int end() const;
    /**
     * Thinning interval of monitor
     */
    unsigned int thin() const;
    /**
     * Number of iterations
     */
    unsigned int niter() const;
    /**
     * Equality operator
     */
    bool operator==(MonitorControl const &rhs) const;
};

} /* namespace jags */

#endif /* MONITOR_CONTROL_H_ */
