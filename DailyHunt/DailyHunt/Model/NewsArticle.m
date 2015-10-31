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
             @"category"        :   @"category",
             @"categoryString"  :   @"category",
             @"content"         :   @"content",
             @"imageURL"        :   @"image",
             @"newsURL"         :   @"url"
             };
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
