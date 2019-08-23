//
//  HZNetUtil.m
//  ColloectionTest
//
//  Created by 韩政 on 2019/8/9.
//  Copyright © 2019 韩政. All rights reserved.
//

#import "HZNetUtil.h"

@interface HZNetUtil()

@end

@implementation HZNetUtil

- (void)sendGetRequest:(NSString *)url{
    [self sendGetRequest:url complete:nil];
}

- (void)sendGetRequest:(NSString *)strUrl complete:(nullable HZNetCompleted)completed{
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error == nil){
            if(completed == nil){
                [self.delegate dataFromServer:data];
            }else{
                completed(data,response,error);
            }
        }else{
            [self.delegate errorInfo:error];
        }
        
    }];
    [dataTask resume];
}

- (void)sendGetRequest:(NSString *)baseUrl parameters:(NSDictionary *)para{
    [self sendGetRequest:baseUrl parameters:para complete:nil];
}

- (void)sendGetRequest:(NSString *)baseUrl parameters:(NSDictionary *)para complete:(nullable HZNetCompleted)completed{
    [self sendGetRequest:[self generateGetURL:baseUrl parameters:para] complete:completed];
}

- (NSString *)generateGetURL:(NSString *)baseUrl parameters:(NSDictionary *)para{
    NSString * strUrl = baseUrl;
    if(para){
        strUrl = [strUrl stringByAppendingString:@"?"];
        NSArray *keyArr= [para allKeys];
        for (int i=0; i<keyArr.count-1; i++) {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@&",keyArr[i],para[keyArr[i]]];
        }
        strUrl = [strUrl stringByAppendingFormat:@"%@=%@",keyArr[keyArr.count-1],para[keyArr[keyArr.count-1]]];
    }
    return strUrl;
}
@end
