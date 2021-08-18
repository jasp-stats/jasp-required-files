#ifndef LOGICAL_H_
#define LOGICAL_H_

#include <vector>
#include <algorithm>

/**
 * Tests whether all elements of the boolean vector "mask" are true.
 */
inline bool allTrue (std::vector<bool> const &mask)
{
   return std::find(mask.begin(), mask.end(), false) == mask.end();
}

/**
 * Tests whether any elements of the boolean vector "mask" are true.
 */
inline bool anyTrue (std::vector<bool> const &mask)
{
   return std::find(mask.begin(), mask.end(), true) != mask.end();
}

#endif /* LOGICAL_H_ */
