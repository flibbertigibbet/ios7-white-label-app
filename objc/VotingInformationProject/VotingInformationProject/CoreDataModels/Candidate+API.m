//
//  Candidate+API.m
//  VotingInformationProject
//
//  Created by Andrew Fink on 2/6/14.
//  
//

#import "Candidate+API.h"
#import "VIPPhoneNumber.h"

@implementation Candidate (API)

- (void)getCandidatePhotoData
{
    if (!self.photoUrl) {
        return;
    }

    NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURL *url = [NSURL URLWithString:self.photoUrl];

    // Create URL request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";

    // Create data task
    NSURLSessionDataTask *getPhotoDataTask =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error) {
            NSLog(@"Candidate %@ error getting photo: %@", self.name, error);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            @try {
                self.photo = data;
            } @catch (NSException *e) {
                NSLog(@"Unable to save candidate photo data: %@", e.name);
            }
        });
    }];

    // Execute request
    [getPhotoDataTask resume];
}

- (NSMutableArray*)getLinksDataArray
{
    NSMutableArray *links = [[NSMutableArray alloc] initWithCapacity:3];
    if ([[self class] canOpenLink:self.candidateUrl asType:kCandidateLinkTypeWebsite]) {
        [links addObject:@{
                           @"buttonTitle": NSLocalizedString(@"Website", @"Button name for candidate's website"),
                           @"description": NSLocalizedString(@"Website", @"Link description for candidate's website"),
                           @"url": [[self class] makeWebsiteURL:self.candidateUrl],
                           @"urlScheme": @(kCandidateLinkTypeWebsite)
                           }];
    }
    if ([[self class] canOpenLink:self.phone asType:kCandidateLinkTypePhone]) {
        [links addObject:@{
                           @"buttonTitle": NSLocalizedString(@"Call", @"Button name for candidate's phone number"),
                           @"description": NSLocalizedString(@"Phone", @"Link description for candidate's phone number"),
                           @"url": [[self class] makePhoneURL:self.phone],
                           @"urlScheme": @(kCandidateLinkTypePhone)
                           }];
    }
    if ([[self class] canOpenLink:self.email asType:kCandidateLinkTypeEmail]) {
        [links addObject:@{
                           @"buttonTitle": NSLocalizedString(@"Email", @"Button name for candidate's email address"),
                           @"description": NSLocalizedString(@"Email", @"Link description for candidate's email address"),
                           @"url": [[self class] makeEmailURL:self.email],
                           @"urlScheme": @(kCandidateLinkTypeEmail)
                           }];
    }
    return links;
}

+ (BOOL)canOpenLink:(NSString*)link asType:(int)type
{
    if ([link length] == 0) {
        return NO;
    }

    NSURL *url = nil;
    if (type == kCandidateLinkTypeWebsite) {
        url = [[self class] makeWebsiteURL:link];
    } else if (type == kCandidateLinkTypePhone) {
        url = [[self class] makePhoneURL:link];
    } else if (type == kCandidateLinkTypeEmail) {
        url = [[self class] makeEmailURL:link];
    } else {
        url = nil;
    }
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+ (NSURL*)makePhoneURL:(NSString*)phone
{
    return [VIPPhoneNumber makeTelPromptLink:phone];
}

+ (NSURL*)makeWebsiteURL:(NSString*)website
{
    return [NSURL URLWithString:website];
}

+ (NSURL*)makeEmailURL:(NSString*)email
{
    NSLog(@"Candidate Email: %@", email);
    NSString *urlString = [NSString stringWithFormat:@"mailto:%@", email];
    return [NSURL URLWithString:urlString];
}

+ (Candidate*) setFromDictionary:(NSDictionary *)attributes
{
    NSMutableDictionary *mutableAttributes = [attributes mutableCopy];

    NSString *channelsKey = @"channels";
    NSArray* channels = attributes[channelsKey];
    [mutableAttributes removeObjectForKey:channelsKey];

    Candidate *candidate = [Candidate MR_createEntity];
    // Set attributes
    [candidate updateFromDictionary:mutableAttributes];

    // Set Social Channels
    for (NSDictionary* channel in channels) {
        SocialChannel *sc = (SocialChannel*)[SocialChannel setFromDictionary:channel];
        [candidate addSocialChannelsObject:sc];
    }

    // Download photo from url
    [candidate getCandidatePhotoData];

    return candidate;
}

/**
 *  Temporary method for stubbing a bit of candidate data for testing
 *  Sets social channels and an email/phone
 *  @warning Remove for final release
 */
- (void) stubCandidateData
{
#if DEBUG
        SocialChannel *twitter =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"Twitter", @"id": @"VotingInfo"}];
        [self addSocialChannelsObject:twitter];

        SocialChannel *facebook =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"Facebook", @"id": @"VotingInfo"}];
        [self addSocialChannelsObject:facebook];

        SocialChannel *youtube =
        (SocialChannel*)[SocialChannel setFromDictionary:@{@"type": @"YouTube", @"id": @"pew"}];
        [self addSocialChannelsObject:youtube];

        self.email = @"info@azavea.com";
        self.phone = @"(123)456-7890";
#endif
}

@end
