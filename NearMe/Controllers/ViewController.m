//
//  ViewController.m
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

@import CoreLocation;
#import "ViewController.h"
#import "Restaurant.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "GooglePlacesApi.h"
#import "AppDelegate.h"
#import "Reachability.h"

#define kPlacesQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ViewController () <CLLocationManagerDelegate>

//setters for readonly properties in the header file
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *restaurantsList;

//view controllers
@property (nonatomic, strong) MapViewController *mapViewController;
@property (nonatomic, strong) ListViewController *listViewController;
@property (nonatomic, strong) GooglePlacesApi *googleApi;

@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *listOrMapButton;
@property (nonatomic, weak) IBOutlet UIView *shadowView;
@property (nonatomic, strong) Reachability *reachability;

//which view is on the front?
@property (nonatomic, assign, getter = isMapShown) BOOL mapShown;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //define location manager
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //current restaurant list
    self.restaurantsList = [[NSMutableArray alloc] init];
    
    //class in charge to retrieve data from Google Places API
    self.googleApi = [[GooglePlacesApi alloc] init];
    
    //flag to define which view we are seeing (map or list?)
    self.mapShown = YES;
    
    //shadow view that appears while loading data
    self.shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    //instantiate reachability to detect if the user has internet connection
    self.reachability = [Reachability reachabilityForInternetConnection];
    
    //define frame for the view controllers
    CGRect frame = self.view.frame;
    frame.origin.y = self.toolbar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    frame.size.height = frame.size.height - frame.origin.y;
    
    //add ListViewController
    self.listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListViewController"];
    self.listViewController.view.frame = frame;
    [self addChildViewController:self.listViewController];
    [self.view addSubview:self.listViewController.view];
    [self.listViewController didMoveToParentViewController:self];
    
    //add MapViewController
    self.mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    self.mapViewController.view.frame = frame;
    [self addChildViewController:self.mapViewController];
    [self.view addSubview:self.mapViewController.view];
    [self.mapViewController didMoveToParentViewController:self];
    
}

#pragma mark - API interaction methods
- (void)reloadPins{
    if(self.isMapShown)
        [self.mapViewController drawPins:self.restaurantsList];
    else
        [self.listViewController updateList];
    self.shadowView.hidden = YES;
}

#pragma mark - helper methods
- (IBAction)locateButtonPressed:(id)sender{
    if (NotReachable == [self.reachability currentReachabilityStatus]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No network available"
                                                        message:@"We are unable to update your restaurants list!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service not available"
                                                        message:@"We are unable to update your restaurants list!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.view bringSubviewToFront:self.shadowView];
        self.shadowView.hidden = NO;
        dispatch_async(kPlacesQueue, ^{
            self.restaurantsList = [self.googleApi sendRestaurantsRequestForLatitude:self.userCenter.latitude longitude:self.userCenter.longitude andMapWidth:self.mapWidth];
            [self performSelectorOnMainThread:@selector(reloadPins) withObject:nil waitUntilDone:YES];
        });
    }
}

- (IBAction)toggleMap:(id)sender{
    if (self.isMapShown){
        [self.listViewController updateList];
        [self.view bringSubviewToFront:self.listViewController.view];
    }
    else{
        [self.mapViewController drawPins:self.restaurantsList];
        [self.view bringSubviewToFront:self.mapViewController.view];
    }
    
    self.mapShown = !self.mapShown;
    self.listOrMapButton.title = (self.isMapShown) ? @"List" : @"Map";
}


@end
