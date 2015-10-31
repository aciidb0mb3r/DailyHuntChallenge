//
//  NewsFeedManager.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "NewsFeedManager.h"

static NSString *kNewsURL = @"http://dailyhunt.0x10.info/api/dailyhunt?type=json&query=list_news";

@interface NewsFeedManager()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSArray<NewsArticle *> *results; // Used for live news

@end

@implementation NewsFeedManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static NewsFeedManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[NewsFeedManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if(self = [super init]) {
        _urlSession = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return self;
}

- (NewsArticle *)liveNewsRelatedToArticle:(NewsArticle *)relatedArticle {
    if(!(self.results.count > 0))
        return nil;
    NewsArticle *livearticle;
    int maxTries = 5;
    do {
        int randNum = rand() % (self.results.count);
        livearticle = self.results[randNum];
        maxTries--;
    } while ([livearticle isEqual:relatedArticle] && maxTries > 0);
    return livearticle;
}

- (void)fetchNewsCompletion:(NewsFeedManagerCompletionBlock)completion {
    
    NSURL *url = [NSURL URLWithString:kNewsURL];
    
    [[self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //Network Error
        NSInteger statusCode = ((NSHTTPURLResponse *)response).statusCode;
        if(error || statusCode != 200) {
            completion(nil, [NewsFeedManager errorWithCode:NewsFeedNetworkErrorUnknown]);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        
        //JSON Error
        if(jsonError) {
            completion(nil, [NewsFeedManager errorWithCode:NewsFeedNetworkErrorJSONParsing]);
            return;
        }
        
        NSArray *results = [MTLJSONAdapter modelsOfClass:[NewsArticle class] fromJSONArray:jsonResponse[@"articles"] error:&jsonError];
        
        //Mantle parsing Error
        if(jsonError) {
            completion(nil, [NewsFeedManager errorWithCode:NewsFeedNetworkErrorMantleParsing]);
            return;
        }
        self.results = results;
        completion(results, nil);
    }] resume];
}

+ (NSError *)errorWithCode:(NewsFeedNetworkError)newsFeedError {
    NSString *errorDescription;
    
    switch (newsFeedError) {
        case NewsFeedNetworkErrorUnknown:
            errorDescription = @"Error in connecting. Please try again.";
            break;
        case NewsFeedNetworkErrorJSONParsing:
            errorDescription = @"Something Went Wrong!";
            break;
        case NewsFeedNetworkErrorMantleParsing:
            errorDescription = @"Something Went Wrong!";
            break;
        default:
            errorDescription = @"Unknown error.";
            break;
    }
    
    return [NSError errorWithDomain:kNewsFeedManagerErrorDomain
                               code:newsFeedError
                           userInfo:@{ NSLocalizedDescriptionKey : errorDescription}];
}

@end
