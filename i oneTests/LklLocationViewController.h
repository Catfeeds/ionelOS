//
//  LklLocationViewController.h
//  ione
//
//  Created by lkl on 2017/3/28.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


#import "LoginViewController.h"
#import "BaseViewController.h"
@interface LklLocationViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MKMapViewDelegate,LoginDelegate>
@property(nonatomic,strong)MKMapView * mapView;
@property(nonatomic,strong)UIImageView * elctimageView;
@property(nonatomic,strong)UIButton * historyButton;
@property(nonatomic,strong)UIButton * elumButton;
@property(nonatomic,strong)UICollectionView  * collectionView;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)UILabel * timeLabel;
@end
