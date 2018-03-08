//
//  TransformToMarsTool.m
//  ione
//
//  Created by zlt on 16/8/29.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import "TransformToMarsTool.h"

@implementation TransformToMarsTool
//GPS转火星
const double a = 6378245.0;
const double ee = 0.00669342162296594323;
//
//+ (CLLocation *)transformToMars:(CLLocation *)location {
//    //是否在中国大陆之外
//    if ([[self class] outOfChina:location]) {
//        return location;
//    }
//    double dLat = [[self class] transformLatWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
//    double dLon = [[self class] transformLonWithX:location.coordinate.longitude - 105.0 y:location.coordinate.latitude - 35.0];
//    double radLat = location.coordinate.latitude / 180.0 * M_PI;
//    double magic = sin(radLat);
//    magic = 1 - ee * magic * magic;
//    double sqrtMagic = sqrt(magic);
//    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
//    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
//    return [[CLLocation alloc] initWithLatitude:location.coordinate.latitude + dLat longitude:location.coordinate.longitude + dLon];
//}

+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D) latLng
{
    double wgLat = latLng.latitude;
    double wgLon = latLng.longitude;
    double mgLat;
    double mgLon;
    
    if ([self outOfChina:wgLat :wgLon ])
    {
        return latLng;
    }
    double dLat = [self transformLat:wgLon-105.0 :wgLat - 35 ];
    double dLon = [self transformLon:wgLon-105.0 :wgLat - 35 ];
    
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    CLLocationCoordinate2D loc2D ;
    loc2D.latitude = mgLat;
    loc2D.longitude = mgLon;
    
    return loc2D;
}

#pragma mark private
+ (BOOL) outOfChina:(double) lat :(double) lon
{
    if (lon < 72.004 || lon > 137.8347) {
        return true;
    }
    if (lat < 0.8293 || lat > 55.8271) {
        return true;
    }
    return false;
}
+ (double) transformLat:(double)x  :(double) y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y +
    0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 *sin(2.0 * x *M_PI)) * 2.0 /
    3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 *sin(y / 3.0 *M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 *sin(y * M_PI / 30.0)) * 2.0 /
    3.0;
    return ret;
}

+ (double) transformLon:(double) x :(double) y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 /
    3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 *M_PI) + 300.0 *sin(x / 30.0 * M_PI)) * 2.0 /
    3.0;
    return ret;
}

//+ (BOOL)outOfChina:(CLLocation *)location {
//    if (location.coordinate.longitude < 72.004 || location.coordinate.longitude > 137.8347) {
//        return YES;
//    }
//    if (location.coordinate.latitude < 0.8293 || location.coordinate.latitude > 55.8271) {
//        return YES;
//    }
//    return NO;
//}

//+ (double)transformLatWithX:(double)x y:(double)y {
//    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
//    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
//    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
//    ret += (160.0 * sin(y / 12.0 * M_PI) + 320.0 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
//    return ret;
//}
//
//+ (double)transformLonWithX:(double)x y:(double)y {
//    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
//    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
//    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
//    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
//    return ret;
//}

@end
