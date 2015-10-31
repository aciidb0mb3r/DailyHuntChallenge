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
#import "NewsFeedManager.h"
#import <UIImageView+WebCache.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NewsArticle *> *articles;
@property (nonatomic, strong) NSArray<NewsArticle *> *fetchedArticles;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self searchSetup];
    [self beginNewsFetch];
    [self setupPullToRefresh];
}

- (void)searchSetup {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
}

- (void)beginNewsFetch {
    NewsFeedManager *newsFeedManager = [NewsFeedManager sharedInstance];
    [newsFeedManager fetchNewsCompletion:^(NSArray<NewsArticle *> *results, NSError *error) {
        if(error) {
            [self showAlertForError:error];
            return;
        }
        self.fetchedArticles = results;
        self.articles = results;
        [self.tableView reloadData];
    }];
}

- (void)setupPullToRefresh {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshResults:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)refreshResults:(UIRefreshControl *)refreshControl {
    [self beginNewsFetch];
    [refreshControl endRefreshing];
}

- (void)showAlertForError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DailyHunt" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.articles = self.fetchedArticles;
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    if(searchString.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title contains[c] %@ OR self.source contains[c] %@", searchString, searchString];
        self.articles = [self.fetchedArticles filteredArrayUsingPredicate:predicate];
    } else {
        self.articles = self.fetchedArticles;
    }
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
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

@end
