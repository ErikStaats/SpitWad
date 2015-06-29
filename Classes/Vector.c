/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * C source file for the vector services.
 *
 *******************************************************************************
 ******************************************************************************/

/* *****************************************************************************
 *
 * Vector imported services.
 *
 ******************************************************************************/

/* Self import. */
#include "Vector.h"

/* Standard C imports. */
#include <math.h>


/* *****************************************************************************
 *
 * Vector services.
 *
 ******************************************************************************/

/*
 * VectorSum
 *
 *   ==> aVector1,              Vectors for which to compute sum.
 *       aVector2
 *
 *   <==                        Vector sum.
 *
 *   This function computes and returns the sum of the two vectors specified by
 * aVector1 and aVector2.
 */

Vector VectorSum(
    Vector                      aVector1,
    Vector                      aVector2)
{
    /* Compute the vector sum. */
    Vector vector;
    vector.v0 = aVector1.v0 + aVector2.v0;
    vector.v1 = aVector1.v1 + aVector2.v1;

    return vector;
}


/*
 * VectorDifference
 *
 *   ==> aVector1,              Vectors for which to compute difference.
 *       aVector2
 *
 *   <==                        Vector difference.
 *
 *   This function computes and returns the difference of the two vectors
 * specified by aVector1 and aVector2.  This function returns aVector1 -
 * aVector2.
 */

Vector VectorDifference(
    Vector                      aVector1,
    Vector                      aVector2)
{
    /* Compute the vector difference. */
    Vector vector;
    vector.v0 = aVector1.v0 - aVector2.v0;
    vector.v1 = aVector1.v1 - aVector2.v1;

    return vector;
}


/*
 * VectorDotProduct
 *
 *   ==> aVector1,              Vectors for which to compute dot product.
 *       aVector2
 *
 *   <==                        Vector dot product.
 *
 *   This function computes and returns the dot product of the two vectors
 * specified by aVector1 and aVector2.
 */
float VectorDotProduct(
    Vector                      aVector1,
    Vector                      aVector2)
{
    return aVector1.v0*aVector2.v0 + aVector1.v1*aVector2.v1;
}


/*
 * VectorGetPerpendicular
 *
 *   ==> aVector                Vector for which to compute perpendicular
 *                              vector.
 *
 *   <==                        Perpendicular vector.
 *
 *   This function computes and returns a vector perpendicular to the vector
 * specified by aVector.
 */
Vector VectorGetPerpendicular(
    Vector                      aVector)
{
    /* Get the perpendicular vector. */
    Vector vector;
    vector.v0 = -aVector.v1;
    vector.v1 = aVector.v0;

    return vector;
}


/*
 * VectorGetUnit
 *
 *   ==> aVector                Vector for which to get unit vector.
 *
 *   <==                        Unit vector.
 *
 *   This function computes and returns the unit vector for the vector specified
 * by aVector.
 */

Vector VectorGetUnit(
    Vector                      aVector)
{
    float vectorLength = VectorGetLength(aVector);
    return VectorScale(aVector, 1.0 / vectorLength);
}


/*
 * VectorGetLength
 *
 *   ==> aVector                Vector for which to get length.
 *
 *   <==                        Vector length.
 *
 *   This function computes and returns the length of the vector specified by
 * aVector.
 */

float VectorGetLength(
    Vector                      aVector)
{
    return sqrt(aVector.v0*aVector.v0 + aVector.v1*aVector.v1);
}


/*
 * VectorSetLength
 *
 *   ==> aVector                Vector for which to set length.
 *   ==> aLength                Length of vector.
 *
 *   <==                        Vector with specified length.
 *
 *   This function produces and returns a vector with the same direction as the
 * vector specified by aVector and with the length specified by aLength.
 */

Vector VectorSetLength(
    Vector                      aVector,
    float                       aLength)
{
    float vectorLength = VectorGetLength(aVector);
    return VectorScale(aVector, aLength / vectorLength);
}


/*
 * VectorScale
 *
 *   ==> aVector                Vector to scale.
 *   ==> aScaleFactor           Factor by which to scale vector.
 *
 *   <==                        Scaled vector.
 *
 *   This function scales the vector specified by aVector by the factor
 * specified by aScaleFactor and returns the result.
 */

Vector VectorScale(
    Vector                      aVector,
    float                       aScaleFactor)
{
    /* Scale the vector. */
    Vector vector;
    vector.v0 = aScaleFactor * aVector.v0;
    vector.v1 = aScaleFactor * aVector.v1;

    return vector;
}


