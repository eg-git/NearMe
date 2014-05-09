//
//  GooglePlacesApi.m
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import "GooglePlacesApi.h"
#import "Reachability.h"
#import "Restaurant.h"

static const NSString *googlePlacesApiKey = @"AIzaSyDYzATmw3oXMQJl-qIdjjsI-8Lj5xPkij4";
static const NSString *googlePlacesType = @"restaurant";

@implementation GooglePlacesApi

- (NSArray *)sendRestaurantsRequestForLatitude:(CGFloat)latitude longitude:(CGFloat)longitude andMapWidth:(int)width{
    NSMutableArray *restaurantList = [[NSMutableArray alloc] init];
    NSString *absoluteUrl = [NSString stringWithFormat:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"GooglePlacesUrl"], latitude, longitude, width, googlePlacesType, googlePlacesApiKey];
    NSLog(@"absoluteUrl: %@", absoluteUrl);
    
    NSURL *googlePlacesRequestURL = [NSURL URLWithString:[absoluteUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSArray *response = [self sendRestaurantsRequestForUrl:googlePlacesRequestURL];
    
    //redraw every pin
    for (NSDictionary *restaurantData in response) {
        NSDictionary *geo = [restaurantData objectForKey:@"geometry"];
        NSDictionary *loc = [geo objectForKey:@"location"];
        NSString *name = [restaurantData objectForKey:@"name"];
        NSString *address = [restaurantData objectForKey:@"vicinity"];
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = [[loc objectForKey:@"lat"] doubleValue];
        coordinates.longitude = [[loc objectForKey:@"lng"] doubleValue];
        
        Restaurant *restaurant = [[Restaurant alloc] initWithName:name address:address coordinate:coordinates];
        [restaurantList addObject:restaurant];
    }
    
    return restaurantList;
}


- (NSArray *)sendRestaurantsRequestForUrl:(NSURL *)url{
    NSData *data = [NSData dataWithContentsOfURL: url];
    return [self parseGoogleResponse:data];
}

-(NSArray *)parseGoogleResponse:(NSData *)response {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:0
                          error:&error];
    
    if (error != nil){
        NSLog(@"JSON parsing error: %@", [error userInfo]);
        return nil;
    }
    
    NSString *apiError = [json objectForKey:@"status"];
    if(![apiError isEqualToString:@"OK"]){
        NSLog(@"API error %@", apiError);
        return nil;
    }
    
    return [json objectForKey:@"results"];
}

@end
