//
//  HZDiskCache.h
//  HZWBDemo
//
//  Created by 韩政 on 2019/8/15.
//  Copyright © 2019 韩政. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZDiskCache : NSObject

@property(nonatomic,assign) NSUInteger capacity;

@property(nonatomic,strong) NSString *cacheDir;

- (instancetype)initWithDirName:(nullable NSString *)dirName NS_DESIGNATED_INITIALIZER;

- (BOOL)containFile:(NSString *)fileName;

- (NSData *)getFile:(NSString *)fileName;

- (BOOL)putFile:(NSData *)data withName:(NSString *)fileName;

- (BOOL)removeFile:(NSString *)fileName;

- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
