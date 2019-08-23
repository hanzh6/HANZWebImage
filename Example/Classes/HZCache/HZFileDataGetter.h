//
//  FileCache.h
//  WeiboDemo
//
//  Created by 韩政 on 2019/8/11.
//  Copyright © 2019 韩政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZNetUtil.h"
#import "HZMemoryCache.h"
#import "HZDiskCache.h"
#import "NSString+MD5.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZFileFinishLoading <NSObject>

- (void)fileLoadSuccess:(NSData *)data;

- (void)fileLoadFail:(NSError *)error;

@end

typedef void(^HZFileCompletdBlock)(NSData * _Nullable,NSError * _Nullable);

@interface HZFileDataGetter : NSObject

@property(nonatomic,strong)id<HZFileFinishLoading> delegate;

- (void)getFileData:(NSString *)Url;

- (void)getFileData:(NSString *)Url complete:(_Nullable HZFileCompletdBlock)block;

@end

NS_ASSUME_NONNULL_END
