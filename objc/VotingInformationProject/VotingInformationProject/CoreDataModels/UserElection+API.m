//
//  UserElection+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 1/31/14.
//  
//

#import "UserElection+API.h"
#import "AppSettings.h"

@implementation UserElection (API)


- (NSArray*)getUniqueParties
{
    NSMutableDictionary *parties = [NSMutableDictionary dictionary];
    for (Contest *contest in self.contests) {
        NSString *party = contest.primaryParty;
        if ([party length] > 0) {
            parties[party] = party;
        }
    }
    // Sort alphabetically to avoid appearing partisan by certain parties appearing first
    return [[parties allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray*)filterPollingLocations:(VIPPollingLocationType)type
{
    if (type == VIPPollingLocationTypeAll) {
        return [self.pollingLocations arrayByAddingObjectsFromArray:self.earlyVoteSites];
    } else if (type == VIPPollingLocationTypeNormal) {
        return self.pollingLocations;
    } else if (type == VIPPollingLocationTypeEarlyVote) {
        return self.earlyVoteSites;
    } else {
        return @[];
    }
}

/*
 A set of parsed data is unique on (electionId, UserAddress).
*/
/*
 // TODO: Rewrite for v2
 */

@end
