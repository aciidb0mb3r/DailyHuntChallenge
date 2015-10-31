//
//  BookmarksManager.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "BookmarksManager.h"

static NSString *kBookmarksPersistenceKey = @"kBookmarksPersistenceKey";

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
        NSData *savedData = [[NSUserDefaults standardUserDefaults] objectForKey:kBookmarksPersistenceKey];
        if(savedData) {
            _bookmarks = [NSKeyedUnarchiver unarchiveObjectWithData:savedData];
        }
    }
    return self;
}

- (void)addToBookmark:(NewsArticle *)newsArticle {
    [self.bookmarks addObject:newsArticle.copy];
    [self save];
}

- (void)removeFromBookmark:(NewsArticle *)newsArticle {
    NewsArticle *article = nil;
    for(NewsArticle *bookmarkArticle in self.bookmarks) {
        if([bookmarkArticle isEqual:newsArticle]) {
            article = bookmarkArticle;
            break;
        }
    }
    if(article) {
        [self.bookmarks removeObject:article];
    }
    [self save];
}

- (BOOL)isBookmarked:(NewsArticle *)newsArticle {
    for(NewsArticle *article in self.bookmarks) {
        if([article.newsURL isEqual:newsArticle.newsURL])
            return YES;
    }
    return NO;
}

- (NSArray<NewsArticle *> *)bookmarkedArticles {
    return self.bookmarks;
}

- (void)save {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.bookmarks];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kBookmarksPersistenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
