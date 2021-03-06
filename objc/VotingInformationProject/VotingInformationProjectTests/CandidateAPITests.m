//
//  CandidateAPITests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "Candidate+API.h"

SPEC_BEGIN(CandidateAPITests)

/**
 Helper function to create a contest with two candidates
 */
Candidate* (^createMockCandidate) () = ^Candidate* () {
    NSDictionary *attributes = @{
        @"name": @"Jon Snow",
        @"photoUrl": @"https://votinginfoproject.org/a/img/logo-vip.png",
        @"email": @"test.email@somedomain.com",
        @"candidateUrl": @"http://test.com"
    };

    NSError *error = nil;
    Candidate* candidate = [[Candidate alloc] initWithDictionary:attributes error:&error];
    return candidate;
};

describe(@"CandidateAPITests", ^{
    
    beforeEach(^{
    });
    
    afterEach(^{
    });

    it(@"should ensure that getCandidatePhotoData sets data", ^{
        Candidate* candidate = createMockCandidate();
        [[candidate.photo should] beNil];
        [candidate getCandidatePhotoData];
        [[expectFutureValue(candidate.photo) shouldEventuallyBeforeTimingOutAfter(2.0)] beNonNil];
    });

    it(@"should ensure that getLinksDataArray results have hte proper dict keys", ^{
        Candidate *candidate = createMockCandidate();

        NSMutableArray *linksData = [candidate getLinksDataArray];
        // should only get data for website since phone is null and email cannot be opened on simulator
        [[theValue([linksData count]) should] equal:theValue(1)];
        NSDictionary *websiteData = linksData[0];
        [[websiteData should] beKindOfClass:[NSDictionary class]];
        [[websiteData[@"description"] should] beNonNil];
        [[websiteData[@"buttonTitle"] should] beNonNil];
        [[websiteData[@"url"] should] beNonNil];
        [[websiteData[@"urlScheme"] should] beNonNil];

        // ensure websiteData urlScheme is of type kCandidateLinkTypeEmail as well
        [[theValue([websiteData[@"urlScheme"] integerValue]) should]
         equal:theValue(kCandidateLinkTypeWebsite)];
    });
   
});

SPEC_END
