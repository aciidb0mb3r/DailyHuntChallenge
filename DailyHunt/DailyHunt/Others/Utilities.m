//
//  Utilities.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

@implementation Utilities

+ (UIImage *)bookmarksImageWithBadgeCount:(NSUInteger)badgeCount {
    UIImage *bookmarkImage = [UIImage imageNamed:@"bookmark"];
    if(badgeCount > 0) {
        
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.text = [NSString stringWithFormat:@" %ld ", badgeCount];
        numberLabel.font = [UIFont systemFontOfSize:10];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.backgroundColor = [UIColor redColor];
        [numberLabel sizeToFit];
        numberLabel.layer.cornerRadius = numberLabel.bounds.size.height/2;
        numberLabel.layer.masksToBounds = YES;
        UIImage *numberImage = [Utilities imageWithView:numberLabel];
        CGSize finalSize = CGSizeMake(bookmarkImage.size.width + numberImage.size.width/2, bookmarkImage.size.height + numberImage.size.height/2);
        UIGraphicsBeginImageContextWithOptions(finalSize, NO, 0.0);
        [bookmarkImage drawInRect:CGRectMake(0, numberImage.size.height/2, bookmarkImage.size.width, bookmarkImage.size.height)];
        [numberImage drawInRect:CGRectMake(bookmarkImage.size.width - numberImage.size.width/2, 0, numberImage.size.width, numberImage.size.height)];
        bookmarkImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return bookmarkImage;
}

+ (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
