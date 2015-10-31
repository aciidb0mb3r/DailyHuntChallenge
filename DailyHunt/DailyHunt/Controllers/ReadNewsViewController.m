//
//  ReadNewsViewController.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "ReadNewsViewController.h"
#import "BookmarksManager.h"
#import "NewsFeedManager.h"
#import <UIImageView+WebCache.h>

@interface ReadNewsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *newsTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *newsContentLabel;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, weak) IBOutlet UIImageView *newsImageView;
@property (nonatomic, weak) UIButton *bookmarksButton;

@property (nonatomic, strong) NewsArticle *liveArticle;
@property (nonatomic, weak) IBOutlet UIImageView *tvIconImageView;
@property (nonatomic, weak) IBOutlet UILabel *liveNewsLabel;

@property (nonatomic, weak) UIButton *navbarTitleViewButton;

@end

@implementation ReadNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self updateView];
    [self beginUpdatingLiveView];
    
}

//Jugad
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navbarTitleViewButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.navbarTitleViewButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.navbarTitleViewButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
}

- (void)setupNavBar {
    
    UIButton *navbarTitleViewButton = [[UIButton alloc] init];
    [navbarTitleViewButton setTitle:[self.newsArticle.source.capitalizedString stringByAppendingString:@" "] forState:UIControlStateNormal];
    [navbarTitleViewButton setImage:[UIImage imageNamed:@"open_outside"] forState:UIControlStateNormal];
    [navbarTitleViewButton addTarget:self action:@selector(titleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = navbarTitleViewButton;
    [navbarTitleViewButton sizeToFit];
    navbarTitleViewButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    navbarTitleViewButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    navbarTitleViewButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.navbarTitleViewButton = navbarTitleViewButton;
    UIButton *bookmarksButton = [[UIButton alloc] init];
    [bookmarksButton setImage:[UIImage imageNamed:@"add_bookmark"] forState:UIControlStateNormal];
    [bookmarksButton addTarget:self action:@selector(addToBookmarks:) forControlEvents:UIControlEventTouchUpInside];
    [bookmarksButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bookmarksButton];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.bookmarksButton = bookmarksButton;
    [self updateBookMarkButton];
}

- (void)addToBookmarks:(id)sender {
    BookmarksManager *bookmarksManager = [BookmarksManager sharedInstance];
    
    if([bookmarksManager isBookmarked:self.newsArticle]) {
        [bookmarksManager removeFromBookmark:self.newsArticle];
    } else {
        [bookmarksManager addToBookmark:self.newsArticle];
    }
    [self updateBookMarkButton];
}

- (void)updateBookMarkButton {
    UIImage *bookmarkImage = [UIImage imageNamed:@"add_bookmark"];
    if([[BookmarksManager sharedInstance] isBookmarked:self.newsArticle]) {
        bookmarkImage = [UIImage imageNamed:@"remove_bookmark"];
    }
    [self.bookmarksButton setImage:bookmarkImage forState:UIControlStateNormal];
    [self.bookmarksButton sizeToFit];
}

- (IBAction)shareButtonPressed:(id)sender {
    NSURL *URL = self.newsArticle.newsURL;
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[URL] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)titleViewClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:self.newsArticle.newsURL];
}

- (void)updateView {
    self.newsTitleLabel.text = self.newsArticle.title;
    self.newsContentLabel.text = self.newsArticle.content;
    [self.newsImageView sd_setImageWithURL:self.newsArticle.imageURL placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
}

- (IBAction)liveNewsTapped:(id)sender {
    if(!self.liveArticle) return;
    ReadNewsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"readNewsVC"];
    vc.newsArticle = self.liveArticle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)beginUpdatingLiveView {
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:NSDate.date interval:30 target:self selector:@selector(updateLiveNews) userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)updateLiveNews {
    NewsFeedManager *newsManager = [NewsFeedManager sharedInstance];
    self.liveArticle = [newsManager liveNewsRelatedToArticle:self.newsArticle];
    self.liveNewsLabel.text = self.liveArticle.title;
    
    self.tvIconImageView.animationImages = @[[UIImage imageNamed:@"news_tv"], [UIImage imageNamed:@"news_tv_without_chat"]];
    self.tvIconImageView.animationRepeatCount = 10;
    self.tvIconImageView.animationDuration = 0.5;
    [self.tvIconImageView startAnimating];
}

@end
