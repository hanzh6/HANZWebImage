//
//  HZNetUtil.h
//  ColloectionTest
//
//  Created by 韩政 on 2019/8/9.
//  Copyright © 2019 韩政. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HZNetResultFeedBack <NSObject>

- (void)dataFromServer:(NSData *)data;

- (void)errorInfo:(NSError *)error;

@end

typedef void(^HZNetCompleted)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error);

@interface HZNetUtil : NSObject

@property(nonatomic,strong) id<HZNetResultFeedBack> delegate;

- (void)sendGetRequest:(NSString *)baseUrl parameters:(NSDictionary *)para complete:(nullable HZNetCompleted)completed;

- (void)sendGetRequest:(NSString *)baseUrl parameters:(NSDictionary *)para;

- (void)sendGetRequest:(NSString *)url;

- (void)sendGetRequest:(NSString *)url complete:(nullable HZNetCompleted)completed;

@end

NS_ASSUME_NONNULL_END
