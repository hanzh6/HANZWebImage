//
//  UIImageView+WebCache.m
//  ColloectionTest
//
//  Created by 韩政 on 2019/8/9.
//  Copyright © 2019 韩政. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import <objc/runtime.h>

@interface UIImageView()

@end

@implementation UIImageView(WebCache)

//- (void)setReUseID:(NSNumber *)reUseID{
//    objc_setAssociatedObject(self, @selector(setReUseID:),reUseID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSNumber *)reUseID{
//    return objc_getAssociatedObject(self, @selector(setReUseID:));
//}

- (void)setUrl:(NSString *)imgUrl{
    HZFileDataGetter *getter = [[HZFileDataGetter alloc]init];
    getter.delegate = self;
    [getter getFileData:imgUrl];
}

- (void)setUrl:(NSString *)imgUrl showActivityIndicatorView:(BOOL)showActivityIndicator indicatorStyle:(UIActivityIndicatorViewStyle)style{
    if(showActivityIndicator){
        HZFileDataGetter *getter = [[HZFileDataGetter alloc]init];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:style];
        activityView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:activityView];
        [activityView startAnimating];
        [getter getFileData:imgUrl complete:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView removeFromSuperview];
                if(error){
                    NSLog(@"TODO");
                    return;
                }
                self.image = [UIImage imageWithData:data];
            });
        }];
    }else{
        [self setUrl:imgUrl];
    }
    
}

- (void)fileLoadFail:(NSError *)error {
    
}

- (void)fileLoadSuccess:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage imageWithData:data];
    });
}

@end
