//
//  MapViewController.m
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

@import MapKit;
@import CoreLocation;
#import "MapViewController.h"
#import "Restaurant.h"
#import "ViewController.h"

//1 mile - the distance will be 1600 meters
static const NSString *metersDistance = @"1600";

@interface MapViewController ()<MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) ViewController *viewController;

@end

@implementation MapViewController

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if ([parent isKindOfClass:[ViewController class]])
        self.viewController = (ViewController *)parent;
    else
        @throw [NSException exceptionWithName:self.class.description reason:@"Wrong parent to setup the map!" userInfo:nil];
}

#pragma mark - MKMapViewDelegate methods.
- (void)mapView:(MKMapView *)mv didUpdateUserLocation:(MKUserLocation *)userLocation{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.viewController.locationManager.location.coordinate, [metersDistance floatValue], [metersDistance floatValue]);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.viewController.locationManager.location.coordinate, [metersDistance floatValue], [metersDistance floatValue]);
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKMapRect mapRect = self.mapView.visibleMapRect;
    MKMapPoint rightPoint = MKMapPointMake(MKMapRectGetMinX(mapRect), MKMapRectGetMidY(mapRect));
    MKMapPoint leftPoint = MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMidY(mapRect));
    
    self.viewController.mapWidth = MKMetersBetweenMapPoints(rightPoint, leftPoint);
    self.viewController.userCenter = self.mapView.centerCoordinate;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"Restaurant";
    
    if ([annotation isKindOfClass:[Restaurant class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil)
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        else
            annotationView.annotation = annotation;
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

#pragma mark - helper methods
- (void)drawPins:(NSArray *)data {
    //remove every pin from the map
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[Restaurant class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    //redraw every pin
    for (Restaurant *restaurant in self.viewController.restaurantsList) {
        [self.mapView addAnnotation:restaurant];
    }
}

@end
