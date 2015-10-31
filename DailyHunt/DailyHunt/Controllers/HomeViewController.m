//
//  HomeViewController.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsTableViewCell.h"
#import "NewsArticle.h"
#import <UIImageView+WebCache.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NewsArticle *> *articles;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"NewsTableViewCell";
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NewsArticle *article = self.articles[indexPath.row];
    
    cell.newsTitle.text = article.title;
    [cell.newsImageView sd_setImageWithURL:article.imageURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

@end
