//
//  UIImageView+WebCache.h
//  ColloectionTest
//
//  Created by 韩政 on 2019/8/9.
//  Copyright © 2019 韩政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZFileDataGetter.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView(WebCache) <HZFileFinishLoading>

//@property(nonatomic,assign)NSNumber *reUseID;

- (void)setUrl:(NSString *)imgUrl;

- (void)setUrl:(NSString *)imgUrl showActivityIndicatorView:(BOOL)showActivityIndicator indicatorStyle:(UIActivityIndicatorViewStyle)style;

@end

NS_ASSUME_NONNULL_END
