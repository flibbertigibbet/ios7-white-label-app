//
//  Contest.h
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Candidate, DataSource, District, Election;

@interface Contest : VIPManagedObject

@property (nonatomic, retain) NSNumber * ballotPlacement;
@property (nonatomic, retain) NSString * contestId;
@property (nonatomic, retain) NSString * electorateSpecifications;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSNumber * numberElected;
@property (nonatomic, retain) NSNumber * numberVotingFor;
@property (nonatomic, retain) NSString * office;
@property (nonatomic, retain) NSString * primaryParty;
@property (nonatomic, retain) NSString * referendumSubtitle;
@property (nonatomic, retain) NSString * referendumTitle;
@property (nonatomic, retain) NSString * referendumUrl;
@property (nonatomic, retain) NSString * special;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *candidates;
@property (nonatomic, retain) NSSet *dataSources;
@property (nonatomic, retain) District *district;
@property (nonatomic, retain) Election *election;
@end

@interface Contest (CoreDataGeneratedAccessors)

- (void)addCandidatesObject:(Candidate *)value;
- (void)removeCandidatesObject:(Candidate *)value;
- (void)addCandidates:(NSSet *)values;
- (void)removeCandidates:(NSSet *)values;

- (void)addDataSourcesObject:(DataSource *)value;
- (void)removeDataSourcesObject:(DataSource *)value;
- (void)addDataSources:(NSSet *)values;
- (void)removeDataSources:(NSSet *)values;

@end