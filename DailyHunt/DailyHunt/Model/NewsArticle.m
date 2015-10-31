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
    return [NewsArticle categoryForCategoryString:self.categoryString];
}

+ (NSString *)categoryStringForCategory:(NewsArticleCategory)category {
    NSDictionary *enumToStringDict = [NewsArticle categoryDictEnumToString];
    
    if([enumToStringDict.allKeys containsObject:@(category)]) {
        return [enumToStringDict objectForKey:@(category)];
    }
    return nil;
}
+ (NewsArticleCategory)categoryForCategoryString:(NSString *)categoryString {
    
    NSDictionary *stringToEnumDict = [NewsArticle categoryDictStringToEnum];
    
    if([stringToEnumDict.allKeys containsObject:categoryString]) {
        return [[stringToEnumDict objectForKey:categoryString] integerValue];
    }
    return NewsArticleCategoryUnknown;
}

+ (NSArray<NSString *> *)allCategories {
    return [NewsArticle categoryDictStringToEnum].allKeys;
}

+ (NSDictionary<NSString *, NSNumber *> *)categoryDictEnumToString {
    return  @{
              @(NewsArticleCategoryWorld)      :   @"World",
              @(NewsArticleCategoryEducation)  :   @"Education",
              @(NewsArticleCategoryScience)    :   @"Science",
              @(NewsArticleCategoryTechnology) :   @"Technology",
              @(NewsArticleCategoryFood)       :   @"Food",
              @(NewsArticleCategorySports)     :   @"Sports",
              };
}

+ (NSDictionary<NSString *, NSNumber *> *)categoryDictStringToEnum {
    return  @{
               @"World"         :   @(NewsArticleCategoryWorld) ,
               @"Education"     :   @(NewsArticleCategoryEducation),
               @"Science"       :   @(NewsArticleCategoryScience),
               @"Technology"    :   @(NewsArticleCategoryTechnology),
               @"Food"          :   @(NewsArticleCategoryFood) ,
               @"Sports"        :   @(NewsArticleCategorySports)
               };
}

+ (NSArray<NewsArticle *> *)newsArticleForCategory:(NewsArticleCategory)category inArray:(NSArray<NewsArticle *> *)inputArray {
    
    NSMutableArray<NewsArticle *> *outputArray = [@[] mutableCopy];
    
    for(NewsArticle *article in inputArray) {
        if(article.category == category) {
            [outputArray addObject:article.copy];
        }
    }
    
    return outputArray;
}

@end
