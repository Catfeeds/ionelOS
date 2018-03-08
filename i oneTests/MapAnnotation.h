//
//  MapAnnotation.h
//  test
//
//  Created by zlt on 16/8/1.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property(nonatomic,copy)NSString * subtitile1;
@property(nonatomic,copy)NSString * icon;
@end
