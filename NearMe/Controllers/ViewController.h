//
//  ViewController.h
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, readonly, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D userCenter;
@property (nonatomic, assign) int mapWidth;
@property (nonatomic, readonly, strong) NSArray *restaurantsList;

@end
