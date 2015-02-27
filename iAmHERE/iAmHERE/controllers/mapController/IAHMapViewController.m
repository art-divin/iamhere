//
//  IAHMapViewController.m
//  iAmHERE
//
//  Created by Ruslan Alikhamov on 25/02/15.
//  Copyright (c) 2015 Ruslan Alikhamov. All rights reserved.
//

#import "IAHMapViewController.h"
#import "IAHAssetsManager.h"
#import "IAHRouteManager.h"
#import "IAHTheme.h"
#import "IAHPlace.h"

@import MapKit;

@interface IAHMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign, getter = isStart) BOOL start;
@property (nonatomic, assign, getter = isEnd) BOOL end;

@end

@implementation IAHMapAnnotation @end

@interface IAHMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) UILabel *settingsLbl;
@property (nonatomic, strong) UIView *settingsView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, assign, getter = hasSettingsVisible) BOOL settingsVisible;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation IAHMapViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.title = NSLocalizedString(@"controllers.map.title", @"Title of the map view");
		self.tabBarItem.image = [IAHAssetsManager imageForTabBarMap];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.settingsView = [UIView new];
	self.settingsLbl = [UILabel new];
	[self.settingsLbl setNumberOfLines:0];
	[self.settingsView setBackgroundColor:[IAHTheme colorForViewBackground]];
	self.mapView = [[MKMapView alloc] init];
	self.mapView.delegate = self;
	[self.view addSubview:self.mapView];
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"Walk", @"Car", @"Transport" ]];
	[self.segmentedControl addTarget:self action:@selector(updateRouteType) forControlEvents:UIControlEventValueChanged];
	[self.segmentedControl setSelectedSegmentIndex:0];
	[self.settingsView addSubview:self.segmentedControl];
	[self.settingsView addSubview:self.settingsLbl];
	[self.segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.settingsLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.settingsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[settingsLbl]-[control]-|"
																			  options:kNilOptions
																			  metrics:nil
																				views:@{ @"control" : self.segmentedControl,
																						 @"settingsLbl" : self.settingsLbl }]];
	[self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl
																  attribute:NSLayoutAttributeCenterX
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.settingsView
																  attribute:NSLayoutAttributeCenterX
																 multiplier:1.0f
																   constant:0.0f]];
	[self.settingsView addConstraint:[NSLayoutConstraint constraintWithItem:self.settingsLbl
																  attribute:NSLayoutAttributeCenterX
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self.settingsView
																  attribute:NSLayoutAttributeCenterX
																 multiplier:1.0f
																   constant:0.0f]];
	[self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|"
																	  options:kNilOptions
																	  metrics:nil
																		views:@{ @"mapView" : self.mapView }]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|"
																	  options:kNilOptions
																	  metrics:nil
																		views:@{ @"mapView" : self.mapView }]];
	UIBarButtonItem *toggleBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleSettings)];
	self.navigationItem.leftBarButtonItem = toggleBtn;
}

- (void)updateRouteType {
	NSString *type = nil;
	switch (self.segmentedControl.selectedSegmentIndex) {
		case 0: type = @"pedestrian"; break;
		case 1: type = @"car"; break;
		case 2: type = @"publicTransport";	break;
		default: break;
	}
	__weak typeof(self) weakSelf = self;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[[IAHRouteManager sharedManager] calculateRouteForTransportType:type
														   callback:
	 ^(IAHItinerary *itinerary, NSError *error) {
		 dispatch_async(dispatch_get_main_queue(), ^{
			 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			 if (error) {
				 // TODO: show error
			 } else {
				 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				 NSDateComponents *comps = [NSDateComponents new];
				 comps.second = [itinerary.summary.travelTime integerValue];
				 NSCalendar *calendar = [NSCalendar currentCalendar];
				 NSDate *date = [calendar dateFromComponents:comps];
				 NSString *templateStr = [NSDateFormatter dateFormatFromTemplate:@"HHmmss" options:kNilOptions locale:[NSLocale currentLocale]];
				 [dateFormatter setDateFormat:templateStr];
				 NSString *timeStr = [dateFormatter stringFromDate:date];
				 CLLocationDistance distance = [itinerary.summary.distance doubleValue];
				 MKDistanceFormatter *distanceFmt = [MKDistanceFormatter new];
				 NSString *distanceStr = [distanceFmt stringFromDistance:distance];
				 NSString *infoStr = [[NSString alloc] initWithFormat:@"%@: %@\n%@: %@\n%@: %@",
									  NSLocalizedString(@"controllers.map.summary.type", @"Type label in summary in Map settings"),
									  type,
									  NSLocalizedString(@"controllers.map.summary.time", @"Time label in summary in Map settings"),
									  timeStr,
									  NSLocalizedString(@"controllers.map.summary.length", @"Length label in summary in Map settings"),
									  distanceStr];
				 NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
				 paragraph.lineBreakMode = NSLineBreakByWordWrapping;
				 paragraph.alignment = NSTextAlignmentCenter;
				 NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:infoStr
																			   attributes:@{ NSForegroundColorAttributeName : [IAHTheme colorForViewTint],
																							 NSParagraphStyleAttributeName : paragraph }];
				 weakSelf.settingsLbl.attributedText = attrStr;
				 NSArray *legArr = [itinerary sortedLegs];
				 NSUInteger totalNumberOfSteps = [itinerary numberOfManeuvers];
				 NSArray *placeArr = [itinerary sortedPlaces];
				 NSMutableArray *annotationArr = [NSMutableArray new];
				 [weakSelf.mapView removeAnnotations:weakSelf.mapView.annotations];
				 [weakSelf.mapView removeOverlays:weakSelf.mapView.overlays];
				 NSUInteger placeCount = placeArr.count;
				 [placeArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					 IAHPlace *place = obj;
					 IAHMapAnnotation *annotaion = [IAHMapAnnotation new];
					 if (idx == 0) {
						 annotaion.start = YES;
					 } else if (idx == placeCount - 1) {
						 annotaion.end = YES;
					 }
					 annotaion.coordinate = place.location.coordinate;
					 [annotationArr addObject:annotaion];
				 }];
				 [weakSelf.mapView addAnnotations:annotationArr];
				 [weakSelf.mapView showAnnotations:annotationArr animated:YES];
				 CLLocationCoordinate2D coordinates[totalNumberOfSteps];
				 __block CLLocationCoordinate2D *coordPtr = coordinates;
				 [legArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					 IAHRouteLeg *leg = obj;
					 NSArray *maneuvers = [leg sortedManeuvers];
					 [maneuvers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
						 IAHRouteManeuver *maneuver = obj;
						 CLLocation *location = maneuver.location;
						 *coordPtr++ = location.coordinate;
					 }];
				 }];
				 MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:totalNumberOfSteps];
				 [weakSelf.mapView addOverlay:polyLine];
			 }
		 });
	 }];
}

// (c) http://stackoverflow.com/a/14622113/611055
- (void)toggleSettings {
	__weak typeof(self) weakSelf = self;
	[UIView animateWithDuration:[IAHTheme animationDuration]
					 animations:^{
						 CATransition *animation = [CATransition animation];
						 [animation setDuration:[IAHTheme animationDuration]];
						 [animation setTimingFunction:[CAMediaTimingFunction functionWithName:@"default"]];
						 animation.fillMode = kCAFillModeForwards;
						 [animation setRemovedOnCompletion:NO];
						 // For curl and uncurl the animation here..
						 if (!weakSelf.hasSettingsVisible) {
							 animation.endProgress = 0.65;
							 animation.type = @"pageCurl";
							 [weakSelf.mapView.layer addAnimation:animation forKey:@"pageCurlAnimation"];
							 [weakSelf.mapView addSubview:weakSelf.settingsView];
							 [weakSelf.settingsView setTranslatesAutoresizingMaskIntoConstraints:NO];
							 [weakSelf.mapView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[settingsView]|"
																									  options:kNilOptions
																									  metrics:nil
																										views:@{ @"settingsView" : weakSelf.settingsView }]];
							 [weakSelf.mapView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[settingsView]|"
																									  options:kNilOptions
																									  metrics:nil
																										views:@{ @"settingsView" : weakSelf.settingsView }]];
							 weakSelf.settingsVisible = YES;
						 } else {
							 animation.startProgress = 0.35;
							 animation.type = @"pageUnCurl";
							 [weakSelf.mapView.layer addAnimation:animation forKey:@"pageUnCurlAnimation"];
							 [weakSelf.settingsView removeFromSuperview];
							 weakSelf.settingsVisible = NO;
						 }
					 }
	 ];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self updateRouteType];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationSlide;
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
		polylineView.strokeColor = [IAHTheme colorForPolyline];
		polylineView.lineWidth = [IAHTheme widthForPolyline];
		return polylineView;
	}
	return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	static NSString * const annotationID = @"IAHMapAnnotation";
	MKPinAnnotationView *view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationID];
	if (!view) {
		view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationID];
	}
	view.canShowCallout = NO;
	view.animatesDrop = YES;
	if ([annotation isKindOfClass:[IAHMapAnnotation class]]) {
		IAHMapAnnotation *ann = annotation;
		if (ann.isStart) {
			view.pinColor = MKPinAnnotationColorGreen;
		} else if (ann.isEnd) {
			view.pinColor = MKPinAnnotationColorRed;
		} else {
			view.pinColor = MKPinAnnotationColorPurple;
		}
	} else {
		view.pinColor = MKPinAnnotationColorPurple;
	}
	return view;
}

@end
