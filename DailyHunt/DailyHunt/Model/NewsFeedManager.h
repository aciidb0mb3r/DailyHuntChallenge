//
//  NewsFeedManager.h
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "MTLModel.h"
#import "NewsArticle.h"

static NSString * const kNewsFeedManagerErrorDomain = @"kNewsFeedManagerErrorDomain";
typedef void (^NewsFeedManagerCompletionBlock)(NSArray<NewsArticle *> *results, NSError *error);

typedef NS_ENUM(NSUInteger, NewsFeedNetworkError) {
    NewsFeedNetworkErrorUnknown,
    NewsFeedNetworkErrorJSONParsing,
    NewsFeedNetworkErrorMantleParsing
};

@interface NewsFeedManager : MTLModel

+ (instancetype)sharedInstance;

- (void)fetchNewsCompletion:(NewsFeedManagerCompletionBlock)completion;

@end
