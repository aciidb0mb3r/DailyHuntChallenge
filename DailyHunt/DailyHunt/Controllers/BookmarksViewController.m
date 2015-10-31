//
//  BookmarksViewController.m
//  DailyHunt
//
//  Created by Ankit Aggarwal on 31/10/15.
//  Copyright © 2015 Ankit. All rights reserved.
//

#import "BookmarksViewController.h"
#import "NewsTableViewCell.h"
#import "NewsArticle.h"
#import "ReadNewsViewController.h"
#import "BookmarksManager.h"
#import <UIImageView+WebCache.h>

@interface BookmarksViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NewsArticle *> *articles;

@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.articles = [[BookmarksManager sharedInstance] bookmarkedArticles];
    [self.tableView reloadData];
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
    [cell.newsImageView sd_setImageWithURL:article.imageURL placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showNewsFromBookMarks" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showNewsFromBookMarks"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewsArticle *article = [self.articles objectAtIndex:indexPath.row];
        ReadNewsViewController *vc = segue.destinationViewController;
        vc.newsArticle = article;
    }
}

@end
