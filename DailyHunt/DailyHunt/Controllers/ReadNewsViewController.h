//
//  ReadNewsViewController.h
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsArticle.h"

@interface ReadNewsViewController : UIViewController

@property (nonatomic, weak) NewsArticle *newsArticle;

@end
