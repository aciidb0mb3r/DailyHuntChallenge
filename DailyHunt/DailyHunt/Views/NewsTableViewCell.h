//
//  NewsTableViewCell.h
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *newsImageView;
@property (nonatomic, weak) IBOutlet UILabel *newsTitle;

@end
