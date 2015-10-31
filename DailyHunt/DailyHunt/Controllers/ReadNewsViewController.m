//
//  ReadNewsViewController.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "ReadNewsViewController.h"
#import "BookmarksManager.h"

@interface ReadNewsViewController ()

@end

@implementation ReadNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];
}
- (void)setupNavBar {
    
    UIButton *bookmarksButton = [[UIButton alloc] init];
    [bookmarksButton setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [bookmarksButton addTarget:self action:@selector(addToBookmarks:) forControlEvents:UIControlEventTouchUpInside];
    [bookmarksButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bookmarksButton];
}

- (void)addToBookmarks:(id)sender {
    BookmarksManager *bookmarksManager = [BookmarksManager sharedInstance];
    [bookmarksManager addToBookmark:self.newsArticle];
}



@end
