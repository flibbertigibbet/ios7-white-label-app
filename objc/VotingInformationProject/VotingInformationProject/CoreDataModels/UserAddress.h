//
//  UserAddress.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/4/14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Election;

@interface UserAddress : VIPManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSSet *elections;
@end

@interface UserAddress (CoreDataGeneratedAccessors)

- (void)addElectionsObject:(Election *)value;
- (void)removeElectionsObject:(Election *)value;
- (void)addElections:(NSSet *)values;
- (void)removeElections:(NSSet *)values;

@end