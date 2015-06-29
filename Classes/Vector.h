/*******************************************************************************
 *******************************************************************************
 *
 * Copyright (c) 2009 Erik Staats.  All rights reserved.
 * http://www.windjay.com
 *
 *******************************************************************************
 *
 * C header file for the vector services.
 *
 *******************************************************************************
 ******************************************************************************/

#ifndef __VECTOR_H__
#define __VECTOR_H__

/* *****************************************************************************
 *
 * Vector structure defs.
 *
 ******************************************************************************/

/*
 * Vector
 *
 *   v0, v1                     Vector components.
 */

typedef struct
{
    float                       v0, v1;
} Vector;


/* *****************************************************************************
 *
 * Vector services prototypes.
 *
 ******************************************************************************/

Vector VectorSum(
    Vector                      aVector1,
    Vector                      aVector2);

Vector VectorDifference(
    Vector                      aVector1,
    Vector                      aVector2);

float VectorDotProduct(
    Vector                      aVector1,
    Vector                      aVector2);

Vector VectorGetPerpendicular(
    Vector                      aVector);

Vector VectorGetUnit(
    Vector                      aVector);

float VectorGetLength(
    Vector                      aVector);

Vector VectorSetLength(
    Vector                      aVector,
    float                       aLength);

Vector VectorScale(
    Vector                      aVector,
    float                       aScaleFactor);


#endif /* __VECTOR_H__ */


