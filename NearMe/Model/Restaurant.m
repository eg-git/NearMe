//
//  Restaurant.m
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation Restaurant

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate{
    if ((self = [super init])) {
        self.name = [name copy];
        self.address = [address copy];
        self.coordinate = coordinate;
    }
    return self;
}

//implementing title for showCallout (for viewForAnnotation: defined in MapViewController)
-(NSString *)title {
    return (self.name == nil) ? @"" : self.name;
}

-(NSString *)subtitle {
    return (self.address == nil) ? @"" : self.address;
}

@end
