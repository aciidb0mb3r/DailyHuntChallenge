//
//  BookmarksManager.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "BookmarksManager.h"

@interface BookmarksManager ()

@property (nonatomic, strong) NSMutableArray<NewsArticle *> *bookmarks;

@end

@implementation BookmarksManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static BookmarksManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[BookmarksManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if(self = [super init]) {
        _bookmarks = [@[] mutableCopy];
    }
    return self;
}

- (void)addToBookmark:(NewsArticle *)newsArticle {
    
}

- (void)removeFromBookmark:(NewsArticle *)newsArticle {
    
}

- (NSArray<NewsArticle *> *)bookmarkedArticles {
    return self.bookmarks;
}

- (void)save {
    
}

@end
