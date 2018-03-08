//
//  LocationModel.h
//  ione
//
//  Created by lkl on 2017/1/17.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface LocationModel : NSObject
@property(nonatomic,assign)CLLocationDegrees lat;
@property(nonatomic,assign)CLLocationDegrees lng;
@property(nonatomic,copy)NSString * address;
@property(nonatomic,assign)NSInteger time;
@property(nonatomic,assign)NSInteger power;
@property(nonatomic,assign)NSInteger online;
+(instancetype)locationModelWithDict:(NSDictionary *)dict;

@end
