//
//  CJMD5.h
//  ione
//
//  Created by zlt on 16/7/28.
//  Copyright © 2016年 lkl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJMD5 : NSObject
+(NSString *)md5HexDigest:(NSString *)str;
- (NSString *)md5:(NSString *)str;
@end
