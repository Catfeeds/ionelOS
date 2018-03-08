//
//  CustomAnnotationView.h
//  ione
//
//  Created by zlt on 16/8/11.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CustomCalloutView.h"
@interface CustomAnnotationView : MKAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@end
