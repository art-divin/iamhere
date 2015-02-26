//
//  IAHSearchViewController.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHSearchViewController.h"
#import "IAHTheme.h"
#import "IAHObjectManager.h"

@interface IAHSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation IAHSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"controllers.search.title", @"Title of the search view");
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorColor = [IAHTheme colorForViewTint];
	[self.view addSubview:self.tableView];
	[self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:nil views:@{ @"tableView" : self.tableView }]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:nil views:@{ @"tableView" : self.tableView }]];
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
	[self.searchBar setShowsCancelButton:YES];
	self.searchBar.barStyle = UISearchBarStyleProminent;
	self.searchBar.delegate = self;
	self.tableView.tableHeaderView = self.searchBar;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	CGRect frame = self.view.frame;
	self.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(frame), [IAHTheme heightForTableViewCell]);
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: custom cell impl
	return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	// TODO: send search suggestion query
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[IAHObjectManager fetchPlacesForQuery:searchBar.text
								 callback:
	 ^(NSArray *result, XTResponseError *error) {
		 
	 }];
	[searchBar resignFirstResponder];
}

@end
