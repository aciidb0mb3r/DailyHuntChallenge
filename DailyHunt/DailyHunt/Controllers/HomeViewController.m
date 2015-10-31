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
#import "ReadNewsViewController.h"
#import <UIImageView+WebCache.h>

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UIButton *bookmarksButton;
@property (nonatomic, strong) UIButton *navbarTitleViewButton;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<NewsArticle *> *articles;
@property (nonatomic, strong) NSArray<NewsArticle *> *fetchedArticles;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self searchSetup];
    [self beginNewsFetch];
    [self setupPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self setupNavBar];
}

- (void)setupNavBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:17/255.0 green:34/255.0 blue:51/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navbarTitleViewButton = [[UIButton alloc] init];
    [self.navbarTitleViewButton setTitle:@"Home" forState:UIControlStateNormal];
    [self.navbarTitleViewButton setImage:[UIImage imageNamed:@"expand_triangle"] forState:UIControlStateNormal];
    [self.navbarTitleViewButton addTarget:self action:@selector(titleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.navbarTitleViewButton;
    [self.navbarTitleViewButton sizeToFit];
    self.navbarTitleViewButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.navbarTitleViewButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.navbarTitleViewButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    
    self.bookmarksButton = [[UIButton alloc] init];
    [self.bookmarksButton setImage:[UIImage imageNamed:@"bookmark"] forState:UIControlStateNormal];
    [self.bookmarksButton addTarget:self action:@selector(openBookmarks:) forControlEvents:UIControlEventTouchUpInside];
    [self.bookmarksButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.bookmarksButton];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)searchSetup {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    UISearchBar *searchBar = self.searchController.searchBar;
    self.tableView.tableHeaderView = searchBar;
    self.definesPresentationContext = YES;
    [searchBar sizeToFit];
    searchBar.barTintColor = [UIColor colorWithRed:17/255.0 green:34/255.0 blue:51/255.0 alpha:1.0];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor colorWithRed:23/255.0	green:45/255.0 blue:67/255.0 alpha:1.0]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
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

- (void)titleViewClicked:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"DailyHunt" message:@"Choose a Category" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    for (NSString *category in NewsArticle.allCategories) {
        
        NewsArticleCategory articleCategory = [NewsArticle categoryForCategoryString:category];
        NSArray<NewsArticle *> *categoryResults = [NewsArticle newsArticleForCategory:articleCategory inArray:self.fetchedArticles];
        NSString *actionTitle = [NSString stringWithFormat:@"%@ (%ld)", category, categoryResults.count];
        UIAlertAction *categoryAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateTitleLabelWithString:actionTitle];
            self.articles = categoryResults;
            [self.tableView reloadData];
        }];
        [alertController addAction:categoryAction];
    }
    
    UIAlertAction *homeAction = [UIAlertAction actionWithTitle:@"All Categories" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self updateTitleLabelWithString:@"Home"];
        self.articles = self.fetchedArticles;
        [self.tableView reloadData];
    }];

    [alertController addAction:homeAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)updateTitleLabelWithString:(NSString *)string {
    [self.navbarTitleViewButton setTitle:string forState:UIControlStateNormal];
    [self.navbarTitleViewButton sizeToFit];
}

- (void)openBookmarks:(id)sender {
    [self performSegueWithIdentifier:@"openBookmarks" sender:self];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self updateTitleLabelWithString:@"Home"];
    return YES;
}

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
    [self performSegueWithIdentifier:@"showNews" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48.0;
}

#pragma mark - Prepare for Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showNews"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewsArticle *article = [self.articles objectAtIndex:indexPath.row];
        ReadNewsViewController *vc = segue.destinationViewController;
        vc.newsArticle = article;
    }
}

@end
