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

@property (nonatomic, strong) MKMapView *mapView;

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
	self.mapView = [[MKMapView alloc] init];
	self.mapView.delegate = self;
	[self.view addSubview:self.mapView];
	[self.mapView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:kNilOptions metrics:nil views:@{ @"mapView" : self.mapView }]];
	[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:kNilOptions metrics:nil views:@{ @"mapView" : self.mapView }]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	__weak typeof(self) weakSelf = self;
	[[IAHRouteManager sharedManager] calculateRoute:
	 ^(IAHItinerary *itinerary, NSError *error) {
		 dispatch_async(dispatch_get_main_queue(), ^{
			 if (error) {
				 // TODO: show error
			 } else {
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
