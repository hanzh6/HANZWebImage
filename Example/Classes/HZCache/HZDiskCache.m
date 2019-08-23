//
//  HZDiskCache.m
//  HZWBDemo
//
//  Created by 韩政 on 2019/8/15.
//  Copyright © 2019 韩政. All rights reserved.
//

#import "HZDiskCache.h"


@implementation HZDiskCache{
    NSFileManager *fileManager;
}

- (instancetype)initWithDirName:(NSString *)dirName{
    self = [super init];
    if (self) {
        fileManager = [NSFileManager defaultManager];
        self.cacheDir = [self createDirInCache:dirName];
    }
    return self;
}

- (instancetype)init{
    return [self initWithDirName:nil];
}

- (BOOL)containFile:(NSString *)fileName{
    NSString *filePath = [self.cacheDir stringByAppendingPathComponent:fileName];
    if([fileManager fileExistsAtPath:filePath]){
        return true;
    }
    return false;
}

- (NSData *)getFile:(NSString *)fileName{
    NSString *filePath = [self.cacheDir stringByAppendingPathComponent:fileName];
    return  [fileManager contentsAtPath:filePath];
}

- (void)putFile:(NSData *)data withName:(NSString *)fileName{
    NSString *filePath = [self.cacheDir stringByAppendingPathComponent:fileName];
    [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

- (void)removeFile:(NSString *)fileName{
    NSString *filePath = [self.cacheDir stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:filePath error:nil];
}

- (void)removeAll{
    NSError *error;
    NSArray *dirEnum = [fileManager contentsOfDirectoryAtPath:self.cacheDir error:&error];
    if(error){
        NSLog(@"remove fail");
        return;
    }
    for(int i=0;i<[dirEnum count];i++){
        [self removeFile:dirEnum[i]];
    }
}

- (NSString *)createDirInCache:(NSString *)dirName{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *cacheDir = [cachePath stringByAppendingPathComponent:dirName];
    if([fileManager fileExistsAtPath:cacheDir]){
        NSError *error;
        BOOL success = [fileManager createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:&error];
        if(!success){
            NSLog(@"%@",error.description);
            cacheDir = nil;
        }
    }
    return cacheDir;
}

@end
