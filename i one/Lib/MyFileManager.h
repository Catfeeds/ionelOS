//
//  MyFileManager.h
//  ione
//
//  Created by lkl on 2017/5/16.
//  Copyright © 2017年 lkl. All rights reserved.
//

#ifndef MyFileManager_h
#define MyFileManager_h

#import <Foundation/Foundation.h>

@interface MyFileManager : NSObject
+(void)browser;
+(NSString *)newFileWithExtension:(NSString *)ext;
+(NSString *)pathForFile:(NSString *)file;
+(void)writeFile:(NSString *)file data:(NSData *)data;
+(void)deleteFile:(NSString *)file;
@end

#endif /* MyFileManager_h */
