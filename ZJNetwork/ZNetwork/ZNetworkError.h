//
//  ZNetworkError.h
//  ZJNetwork
//
//  Created by Zhang on 2018/3/29.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *zNoNetworkMessage = @"网络连接错误，请重试。";
static NSInteger zNoNetworkCode = 100;


@interface ZNetworkError : NSObject

@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, assign) NSInteger errorCode;

+ (instancetype)sharedInstance;

- (ZNetworkError *((^)(NSString *)))addErrorMessage;

- (ZNetworkError *((^)(NSInteger)))addErrorCode;

@end
