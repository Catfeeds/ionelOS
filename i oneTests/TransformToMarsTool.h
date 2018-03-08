//
//  TransformToMarsTool.h
//  ione
//
//  Created by zlt on 16/8/29.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TransformToMarsTool : NSObject

//+ (CLLocation *)transformToMars:(CLLocation *)location;
+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D) latLng;
@end
