//
//  NewsArticle.h
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "Mantle.h"

typedef NS_ENUM(NSUInteger, NewsArticleCategory) {
    NewsArticleCategoryWorld,
    NewsArticleCategoryEducation,
    NewsArticleCategoryScience,
    NewsArticleCategoryTechnology,
    NewsArticleCategoryFood,
    NewsArticleCategorySports,
    NewsArticleCategoryUnknown
};

@interface NewsArticle : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *source;
@property (nonatomic, assign, readonly) NewsArticleCategory category;
@property (nonatomic, copy, readonly) NSString *categoryString;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) NSURL *newsURL;

+ (NSArray<NewsArticle *> *)newsArticleForCategory:(NewsArticleCategory)category inArray:(NSArray<NewsArticle *> *)inputArray;

@end
