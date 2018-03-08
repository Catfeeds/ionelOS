//
//  MyFileManager.m
//  ione
//
//  Created by lkl on 2017/5/16.
//  Copyright © 2017年 lkl. All rights reserved.
//

#import "MyFileManager.h"

@implementation MyFileManager

+(void)browser
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *files = [fm enumeratorAtPath:documentsDirectory];
    for(NSString *file in files){
        NSLog(@"%@/%@", documentsDirectory,file);
    }
}

+(NSString *)newFileWithExtension:(NSString *)ext
{
    long t = time(NULL);
    long r = arc4random()%99999;
    return [[NSString alloc] initWithFormat:@"%ld%05ld.%@",t,r,ext];
}

+(NSString *)pathForFile:(NSString *)file
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [[NSString alloc] initWithFormat:@"%@/%@",documentsDirectory,file];
}

+(void)writeFile:(NSString *)file data:(NSData *)data
{
    [[NSFileManager defaultManager] createFileAtPath:[MyFileManager pathForFile:file] contents:data attributes:nil];
}

+(void)deleteFile:(NSString *)file
{
    [[NSFileManager defaultManager] removeItemAtPath:[MyFileManager pathForFile:file] error:nil];
}
@end
