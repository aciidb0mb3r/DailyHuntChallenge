//
//  NewsArticle.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "NewsArticle.h"

@implementation NewsArticle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title"           :   @"title",
             @"source"          :   @"source",
             @"categoryString"  :   @"category",
             @"content"         :   @"content",
             @"imageURL"        :   @"image",
             @"newsURL"         :   @"url"
             };
}

- (NewsArticleCategory)category {
    NewsArticleCategory category = NewsArticleCategoryUnknown;
    
    if([self.categoryString isEqualToString:@"World"]) {
        category = NewsArticleCategoryWorld;
        
    } else if([self.categoryString isEqualToString:@"Education"]) {
        category = NewsArticleCategoryEducation;
        
    } else if([self.categoryString isEqualToString:@"Science"]) {
        category = NewsArticleCategoryScience;
        
    } else if([self.categoryString isEqualToString:@"Technology"]) {
        category = NewsArticleCategoryTechnology;
        
    } else if([self.categoryString isEqualToString:@"Food"]) {
        category = NewsArticleCategoryFood;
        
    } else if([self.categoryString isEqualToString:@"Sports"]) {
        category = NewsArticleCategorySports;
        
    }
    
    return category;
}

+ (NSArray<NewsArticle *> *)newsArticleForCategory:(NewsArticleCategory)category inArray:(NSArray<NewsArticle *> *)inputArray {
    
    NSMutableArray<NewsArticle *> *outputArray = [@{} mutableCopy];
    
    for(NewsArticle *article in inputArray) {
        if(article.category == category) {
            [outputArray addObject:article.copy];
        }
    }
    
    return outputArray;
}

@end
