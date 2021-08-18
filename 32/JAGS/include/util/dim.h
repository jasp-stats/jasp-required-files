#ifndef DIM_H_
#define DIM_H_

#include <vector>
#include <algorithm>

namespace jags {

    /**
     * @short Test for flat dimensions
     *
     * A vector "dim" representing a dimension is considered "flat" if
     * it is either empty or it includes elements equal to zero. Flat
     * dimensions are unsuitable
     *
     * Note that isFlat, isScalar, isVector and isArray are mutually
     * exclusive. Exactly one of them will return true for any given
     * input vector.
     * 
     * @see isScalar, isVector, isArray
     */
    inline bool isFlat(std::vector<unsigned int> const &dim) 
    {
	return dim.empty() || 
	    std::find(dim.begin(), dim.end(), 0U) != dim.end();
    }
    
    /**
     * @short Test for scalar dimensions
     *
     * Tests whether the dimension represented by the vector "dim"
     * corresponds to a scalar quantity.
     *
     * @see isFlat, isVector, isArray
     */
    inline bool isScalar(std::vector<unsigned int> const &dim)
    {
	return dim.size() == 1 && dim[0] == 1;
    }

    /**
     * @short Test for vector dimensions
     *
     * Tests whether the dimension represented by the vector "dim"
     * corresponds to a vector quantity.
     *
     * @see isFlat, isScalar, isArray
     */
    inline bool isVector(std::vector<unsigned int> const &dim)
    {
	return dim.size() == 1 && dim[0] > 1;
    }

    /**
     * @short Test for array dimensions
     *
     * Tests whether the dimension represented by the vector "dim"
     * corresponds to a matrix or higher-dimensional array.
     *
     * @see isFlat, isScalar, isArray
     */
    inline bool isArray(std::vector<unsigned int> const &dim)
    {
	return dim.size() > 1 && 
	    std::find(dim.begin(), dim.end(), 0U) == dim.end();
    }
     
    /**
     * @short Test for matrices
     *
     * Tests whether the dimension represented by the vector "dim"
     * corresponds to a matrix (i.e. a two-dimensional array).
     */
    inline bool isMatrix(std::vector<unsigned int> const &dim)
    {
	return dim.size() == 2 && dim[0] != 0 && dim[1] != 0;
    }
    
    /**
     * 
     * @short Test for square matrices
     *
     * Tests whether the dimension represented by the vector "dim"
     * corresponds to a square matrix.
     */
    inline bool isSquareMatrix(std::vector<unsigned int> const &dim)
    {
	return isMatrix(dim) && dim[0] == dim[1];
    }
    
    /**
     * Returns the product of the elements of a vector of unsigned
     * integers. The most common usage of this function is to
     * calculate the number of elements in an array given its
     * dimensions.
     */
    unsigned int product(std::vector<unsigned int> const &arg);

    /**
     * @short Drops redundant dimensions
     *
     * Given a vector representing a dimension, returns a reduced
     * vector in which dimensions that have only one level are
     * removed. If the vector consists of only scalar dimensions
     * then the return value is a vector of length 1 and value 1.
     *
     * Flat dimensions (corresponding to elements with value
     * zero) are not removed.
     */
    std::vector<unsigned int> drop(std::vector<unsigned int> const &dims);

    /**
     * @short Gets a constant reference to a unique dimension 
     *
     * Vectors of unsigned integers are frequently repeated objects in
     * the JAGS library, and are typically used to represent
     * dimensions of Nodes and NodeArrays. This function creates a
     * unique constant reference to the requested vector, avoiding
     * redundant copies of the vector taking up memory.
     */
    std::vector<unsigned int> const &
	getUnique(std::vector<unsigned int> const &dim);

    /**
     * @short Getst a constant reference to a unique vector of dimension
     *
     * Vectors of vectors of unsigned integers are frequently repeated
     * objects in the JAGS library (Typically as dimensions of
     * parameters for Functions and Distributions). This function
     * returns a reference to a unique copy of the requested vector in
     * order to save memory.
     */
    std::vector<std::vector<unsigned int> > const & 
	getUnique(std::vector<std::vector<unsigned int> > const &dimvec);
    
}

#endif /* DIM_H_ */
