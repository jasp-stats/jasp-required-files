#ifndef OBS_FUNC_TAB_H_
#define OBS_FUNC_TAB_H_

#include <list>
#include <string>

#include <function/FunctionPtr.h>
#include <distribution/DistPtr.h>

namespace jags {

/**
 * @short Look-up table for observable functions 
 *
 * Obs functions may behave like either a distribution or a
 * function, depending on the context, so must be represented by both
 * a Distribution object and a Function object. 
 *
 * The ObsFuncTab class provides a means of storing these
 * Distribution/Function pairs and looking up Functions from their
 * matching distribution.
 *
 * @see FuncTab DistTab 
 */
class ObsFuncTab
{
    std::list<std::pair<DistPtr,FunctionPtr> >  _flist;
    FunctionPtr const _nullfun;
public:
    /**
     * Constructs a new empty table
     */
    ObsFuncTab();
    /**
     * Inserts an observable function into the table. The distribution
     * and function must have the same name in the BUGS language.  A
     * given pair can only be inserted into the table once
     *
     * @param dist Polymorphic distribution pointer
     * @param func Polymorphic function pointer
     */
    void insert(DistPtr const &dist, FunctionPtr const &func);
    /**
     * Finds a Function from its matching Distribution.  If a
     * Distribution matches more than one Function, then the Function
     * corresponding to the last pair inserted into the table is
     * returned.
     *
     * @return a polymorphic function pointer. If the function cannot
     * be found, then the pointer is a null FunctionPtr object.
     */
    FunctionPtr const &find(DistPtr const &dist) const;
    /**
     * Removes a distribution/function pair from the table. 
     *
     * @param dist Polymorphic distribution pointer
     * @param func Polymorphic function pointer
     */
    void erase(DistPtr const &dist, FunctionPtr const &func);
};

} /* namespace jags */

#endif /* OBS_FUNC_TAB_H_ */
