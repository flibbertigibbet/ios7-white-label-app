//
//  Candidate+API.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  Copyright (c) 2014 Bennet Huber. All rights reserved.
//

#import "Candidate.h"

@interface Candidate (API)

/**
 Create and return an instance of Candidate from a dictionary

 @param attributes NSDictionary of the attributes to set

 @see VIPManagedObject setFromDictionary:
 */
+ (Candidate*) setFromDictionary:(NSDictionary*)attributes;

@end
