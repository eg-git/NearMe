//
//  GooglePlacesApi.h
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SharedData;

@interface GooglePlacesApi : NSObject

- (NSArray *)sendRestaurantsRequestForLatitude:(CGFloat)latitude longitude:(CGFloat)longitude andMapWidth:(int)width;

@end
