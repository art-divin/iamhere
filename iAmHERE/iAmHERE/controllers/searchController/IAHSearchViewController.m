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
#import "IAHLocationManager.h"
#import "IAHRouteManager.h"

@interface IAHSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *resultArr;

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
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
	[self.searchBar setShowsCancelButton:YES];
	self.searchBar.barStyle = UISearchBarStyleProminent;
	self.searchBar.delegate = self;
	[self.view addSubview:self.searchBar];
	[self.searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
																	  options:kNilOptions
																	  metrics:nil
																		views:@{ @"tableView" : self.tableView }]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[searchBar(==height)][tableView]|"
																	  options:kNilOptions
																	  metrics:@{ @"height" : @([IAHTheme heightForTableViewCell]) }
																		views:@{ @"searchBar" : self.searchBar,
																				 @"tableView" : self.tableView }]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar]|"
																	  options:kNilOptions
																	  metrics:nil
																		views:@{ @"searchBar" : self.searchBar }]];
	[IAHLocationManager fetchCurrentLocationWithSubscription:^(CLLocationCoordinate2D coordinate) {
		// no-op
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.resultArr.count) {
		[self.tableView reloadData];
	}
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
	return self.resultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	}
	IAHPlace *place = self.resultArr[indexPath.row];
	NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
	paragraph.lineBreakMode = NSLineBreakByWordWrapping;
	NSDictionary *attrDic = @{ NSForegroundColorAttributeName : [IAHTheme colorForCellTitle],
							   NSParagraphStyleAttributeName : paragraph };
	NSAttributedString *titleAttrStr = [[NSAttributedString alloc] initWithString:place.title
																	   attributes:attrDic];
	NSAttributedString *vicinityAttrStr = [[NSAttributedString alloc] initWithString:place.vicinity
																		  attributes:attrDic];
	cell.textLabel.numberOfLines = 0;
	cell.detailTextLabel.numberOfLines = 0;
	cell.textLabel.attributedText = titleAttrStr;
	cell.detailTextLabel.attributedText = vicinityAttrStr;
	if (place.itinerary) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	IAHPlace *place = self.resultArr[indexPath.row];
	NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
	paragraph.lineBreakMode = NSLineBreakByWordWrapping;
	NSDictionary *attrDic = @{ NSForegroundColorAttributeName : [IAHTheme colorForCellTitle],
							   NSParagraphStyleAttributeName : paragraph };
	NSAttributedString *titleAttrStr = [[NSAttributedString alloc] initWithString:place.title
																	   attributes:attrDic];
	NSAttributedString *vicinityAttrStr = [[NSAttributedString alloc] initWithString:place.vicinity
																		  attributes:attrDic];
	CGFloat width = CGRectGetWidth(tableView.frame) - tableView.separatorInset.left;
	CGRect rect = [titleAttrStr boundingRectWithSize:(CGSize){ .width = width, .height = CGFLOAT_MAX }
											 options:NSStringDrawingUsesLineFragmentOrigin
											 context:nil];
	CGRect rect2 = [vicinityAttrStr boundingRectWithSize:(CGSize){ .width = width, .height = CGFLOAT_MAX }
												 options:NSStringDrawingUsesLineFragmentOrigin
												 context:nil];
	CGFloat height = ceil(CGRectGetHeight(rect));
	height += ceil(CGRectGetHeight(rect2));
	height = MAX(height, [IAHTheme heightForTableViewCell]);
	return height + [IAHTheme heightForTableViewCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	IAHPlace *place = self.resultArr[indexPath.row];
	if (place.itinerary) {
		[[IAHRouteManager sharedManager] removePlace:place];
	} else {
		[[IAHRouteManager sharedManager] addPlace:place];
	}
	[[IAHRouteManager sharedManager] saveWithCallback:^(NSError *error) {
		// TODO: show error dialog
	}];
	[tableView reloadRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (searchText.length == 0) {
		self.resultArr = nil;
		[self.tableView reloadData];
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	__weak typeof(self) weakSelf = self;
	[IAHLocationManager fetchCurrentLocationWithSubscription:^(CLLocationCoordinate2D coordinate) {
		if (CLLocationCoordinate2DIsValid(coordinate)) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
			[IAHObjectManager fetchPlacesForQuery:searchBar.text
									   coordinate:coordinate
										 callback:
			 ^(NSArray *result, XTResponseError *error) {
				 dispatch_async(dispatch_get_main_queue(), ^{
					 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
					 if (error) {
						 // TODO: show error dialog
					 } else {
						 weakSelf.resultArr = result;
						 [weakSelf.tableView reloadData];
					 }
				 });
			 }];
		} else {
			// TODO: show an error
		}
	}];
	[searchBar resignFirstResponder];
}

@end
