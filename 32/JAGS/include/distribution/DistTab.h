#ifndef DIST_TAB_H_
#define DIST_TAB_H_

#include <list>
#include <string>

#include <distribution/DistPtr.h>

namespace jags {

/**
 * @short Look-up table for Distribution objects
 *
 * The DistTab class provides a means of looking up Distributions by
 * their name in the BUGS language.
 *
 * @see Dist DistTab 
 */
class DistTab
{
    std::list<DistPtr> _dlist;
    DistPtr const _nulldist;
public:
    DistTab();
    /**
     * Inserts a dist into the table. 
     */
    void insert (DistPtr const &dist);
    /**
     * Finds a distribution by name.
     *
     * @return a polymorphic dist pointer. If the distribution cannot
     * be found, then the pointer is a null DistPtr object.
     */
    DistPtr const &find(std::string const &name) const;
    /**
     * Removes a distribution from the table. 
     */
    void erase(DistPtr const &dist);
};

} /* namespace jags */

#endif /* DIST_TAB_H_ */
