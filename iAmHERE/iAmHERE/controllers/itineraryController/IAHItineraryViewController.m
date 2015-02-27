//
//  IAHItineraryViewController.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHItineraryViewController.h"
#import "IAHTheme.h"
#import "IAHRouteManager.h"
#import "IAHPlace.h"
#import "IAHAssetsManager.h"

@interface IAHItineraryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak, getter = itinerary) IAHItinerary *itinerary;

@end

@implementation IAHItineraryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"controllers.itinerary.title", @"Title of the itinerary view");
		self.tabBarItem.image = [IAHAssetsManager imageForTabBarItinerary];
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
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|"
																	  options:kNilOptions
																	  metrics:nil
																		views:@{ @"tableView" : self.tableView }]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|"
																	  options:kNilOptions
																	  metrics:nil
																		views:@{ @"tableView" : self.tableView }]];
	UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
	self.navigationItem.rightBarButtonItem = editBtn;
}

- (void)toggleEditing {
	self.tableView.editing = !self.tableView.isEditing;
	if (self.tableView.isEditing) {
		UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing)];
		self.navigationItem.rightBarButtonItem = doneBtn;
	} else {
		UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
		self.navigationItem.rightBarButtonItem = editBtn;
	}
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

- (IAHItinerary *)itinerary {
	return [IAHRouteManager sharedManager].itinerary;
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
	return self.itinerary.sortedPlaces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
	}
	IAHPlace *place = self.itinerary.sortedPlaces[indexPath.row];
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
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	IAHPlace *place1 = self.itinerary.sortedPlaces[sourceIndexPath.row];
	IAHPlace *place2 = self.itinerary.sortedPlaces[destinationIndexPath.row];
	[[IAHRouteManager sharedManager] exchangePlace:place1 withPlace:place2];
	[[IAHRouteManager sharedManager] saveWithCallback:^(NSError *error) {
		if (error) {
			// TODO: present dialog with error
		}
	}];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	IAHPlace *place = self.itinerary.sortedPlaces[indexPath.row];
	[[IAHRouteManager sharedManager] removePlace:place];
	[[IAHRouteManager sharedManager] saveWithCallback:^(NSError *error) {
		if (error) {
			// TODO: present dialog with error
		}
	}];
	[tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	IAHPlace *place = self.itinerary.sortedPlaces[indexPath.row];
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
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

@end
