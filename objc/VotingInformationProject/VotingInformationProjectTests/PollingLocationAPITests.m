//
//  CoreDataModelTests.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/3/14.
//

#import <XCTest/XCTest.h>
#import "Kiwi.h"

#import "PollingLocation+API.h"
#import "EarlyVoteSite.h"
#import "Election+API.h"

SPEC_BEGIN(PollingLocationAPITests)

describe(@"PLAPITests", ^{
    
    beforeEach(^{
    });
    
    afterEach(^{
    });

    it(@"should ensure that setDictionary sets valid keys of PollingLocation", ^{

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource", @"official": @"true"}]
                                     };
        NSError *error = nil;
        PollingLocation *pl = [[PollingLocation alloc] initWithDictionary:attributes error:&error];
        [[theValue([pl.sources count]) should] equal:theValue(1)];
        [[pl.address.locationName should] equal:@"123 Test Drive"];
        [[pl.notes should] equal:notesvalue];
        [[pl.name should] equal:namevalue];
    });

    it(@"should ensure that isAvailable returns YES if startDate or endDate are nil", ^{
        NSDate *now = [NSDate date];
        int daysPast = 3;
        int daysFuture = 3;
        NSDate *startDate = [now dateByAddingTimeInterval:-1*60*60*24*daysPast];
        NSDate *endDate = [now dateByAddingTimeInterval:60*60*24*daysFuture];
        NSDateFormatter *yyyymmddFormatter = [Election getElectionDateFormatter];
        NSString *endDateString = [yyyymmddFormatter stringFromDate:endDate];
        NSString *startDateString = [yyyymmddFormatter stringFromDate:startDate];

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource", @"official": @"true"}],
                                     @"endDate": endDateString
                                     };

        NSError *error = nil;
        PollingLocation *pl = [[PollingLocation alloc] initWithDictionary:attributes error:&error];
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
        pl.startDate = startDate;
        pl.endDate = nil;
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
    });

    it(@"should ensure that isAvailable returns NO if today is after endDate", ^{
        NSDate *now = [NSDate date];
        int daysPast = 8;
        int daysFuture = -3;
        NSDate *startDate = [now dateByAddingTimeInterval:-1*60*60*24*daysPast];
        NSDate *endDate = [now dateByAddingTimeInterval:60*60*24*daysFuture];
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endDateString = [yyyymmddFormatter stringFromDate:endDate];
        NSString *startDateString = [yyyymmddFormatter stringFromDate:startDate];

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource", @"official": @"true"}],
                                     @"startDate": startDateString,
                                     @"endDate": endDateString
                                     };
        NSError *error = nil;
        PollingLocation *pl = [[PollingLocation alloc] initWithDictionary:attributes error:&error];
        [[theValue([pl isAvailable]) should] equal:theValue(NO)];
        // Shouldnt matter if earlyVoteSite or not
        EarlyVoteSite *evs = [[EarlyVoteSite alloc] initWithDictionary:attributes error:&error];
        [[theValue([evs isAvailable]) should] equal:theValue(NO)];
    });

    it(@"should ensure that isAvailable returns YES if today is before endDate", ^{
        NSDate *now = [NSDate date];
        int daysPast = -3;
        int daysFuture = 8;
        NSDate *startDate = [now dateByAddingTimeInterval:-1*60*60*24*daysPast];
        NSDate *endDate = [now dateByAddingTimeInterval:60*60*24*daysFuture];
        NSDateFormatter *yyyymmddFormatter = [[NSDateFormatter alloc] init];
        [yyyymmddFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endDateString = [yyyymmddFormatter stringFromDate:endDate];
        NSString *startDateString = [yyyymmddFormatter stringFromDate:startDate];

        NSString *notesvalue = @"blanknotes";
        NSString *namevalue = @"site 1";
        NSDictionary *attributes = @{
                                     @"notes": notesvalue,
                                     @"name": namevalue,
                                     @"address": @{@"locationName": @"123 Test Drive"},
                                     @"sources": @[@{@"name": @"Test DataSource", @"official": @"true"}],
                                     @"startDate": startDateString,
                                     @"endDate": endDateString
                                     };

        NSError *error = nil;
        PollingLocation *pl = [[PollingLocation alloc] initWithDictionary:attributes error:&error];
        [[theValue([pl isAvailable]) should] equal:theValue(YES)];
        // Shouldnt matter if earlyVoteSite or not
        EarlyVoteSite *evs = [[EarlyVoteSite alloc] initWithDictionary:attributes error:&error];
        [[theValue([evs isAvailable]) should] equal:theValue(YES)];
    });

});

SPEC_END
