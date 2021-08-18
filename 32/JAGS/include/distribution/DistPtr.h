#ifndef DIST_POINTER_H_
#define DIST_POINTER_H_

#include <distribution/ScalarDist.h>
#include <distribution/VectorDist.h>
#include <distribution/ArrayDist.h>

namespace jags {

/**
 * @short Polymorphic pointer to Distribution
 *
 * A DistPtr holds a pointer to one of the three sub-classes of
 * Distribution: ScalarDist, VectorDist, or ArrayDist.  The pointers
 * can be extracted using the extractor functions SCALAR, VECTOR, and
 * ARRAY, respectively .
 */
class DistPtr
{
    ScalarDist const * sdist;
    VectorDist const * vdist;
    ArrayDist const * adist;
public:
    DistPtr();
    DistPtr(ScalarDist const *);
    DistPtr(VectorDist const *);
    DistPtr(ArrayDist const *);
    bool operator==(DistPtr const &rhs) const;
    std::string const &name() const;
    friend ScalarDist const *SCALAR(DistPtr const &p);
    friend VectorDist const *VECTOR(DistPtr const &p);
    friend ArrayDist const *ARRAY(DistPtr const &p);
    friend bool isNULL(DistPtr const &p);
};

} /* namespace jags */

#endif /* DIST_POINTER_H_ */
