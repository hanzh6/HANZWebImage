//
//  HZMemoryCache.h
//  HZWBDemo
//
//  Created by 韩政 on 2019/8/14.
//  Copyright © 2019 韩政. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZMemoryCache : NSObject

+ (instancetype)sharedInstance;

-(void)debug;

//-(BOOL)containKey:(NSString *)key;

- (id)getDataForKey:(NSString *)key;

- (void)getDataForKey:(NSString *)key completion:(void(^)(NSString *key, id data))completion;

- (void)putData:(id)data withKey:(NSString *)key;

@end
