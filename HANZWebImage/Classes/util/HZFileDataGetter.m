//
//  FileCache.m
//  WeiboDemo
//
//  Created by 韩政 on 2019/8/11.
//  Copyright © 2019 韩政. All rights reserved.
//

#import "HZFileDataGetter.h"

@interface HZFileDataGetter()

@end

static HZDiskCache *diskCache;

@implementation HZFileDataGetter

- (instancetype)init{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            diskCache = [[HZDiskCache alloc]initWithDirName:@"File"];
        });
    }
    return self;
}

- (void)getFileData:(NSString *)url{
    [self getFileData:url complete:nil];
}

- (void)getFileData:(NSString *)url complete:(_Nullable HZFileCompletdBlock)complete{
    NSString *key = [NSString getMD5:url];
    HZMemoryCache *sharedCache = [HZMemoryCache sharedInstance];
    NSData *memoryData = [sharedCache getDataForKey:key];
    if(memoryData){
        if(complete){
            complete(memoryData,nil);
        }else{
            [self.delegate fileLoadSuccess:memoryData];
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if([diskCache containFile:key]){
            NSData *temp = [diskCache getFile:key];
            if(complete){
                complete(temp,nil);
            }else{
                [self.delegate fileLoadSuccess:temp];
            }
            [sharedCache putData:temp withKey:key];
            return;
        }
        HZNetUtil *net = [HZNetUtil new];
        [net sendGetRequest:url complete:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@",[error localizedDescription]);
                return;
            }
            if(complete){
                complete(data,nil);
            }else{
                [self.delegate fileLoadSuccess:data];
            }
            [sharedCache putData:data withKey:key];
            [diskCache putFile:data withName:key];
        }];
    });
    
}

@end
