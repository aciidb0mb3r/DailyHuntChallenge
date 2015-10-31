//
//  BookmarksManager.h
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsArticle.h"

@interface BookmarksManager : NSObject

+ (instancetype)sharedInstance;

- (void)addToBookmark:(NewsArticle *)newsArticle;

- (void)removeFromBookmark:(NewsArticle *)newsArticle;

- (NSArray<NewsArticle *> *)bookmarkedArticles;

@end
