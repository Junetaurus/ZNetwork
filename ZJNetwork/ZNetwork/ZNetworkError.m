//
//  ZNetworkError.m
//  ZJNetwork
//
//  Created by Zhang on 2018/3/29.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import "ZNetworkError.h"

@implementation ZNetworkError

+ (instancetype)shareErrorMessage:(NSString *)errorMessage errorCode:(NSInteger)errorCode {
    ZNetworkError *error = [[ZNetworkError alloc] init];
    return error;
}

+ (instancetype)sharedInstance {
    return [[ZNetworkError alloc] init];
}

- (ZNetworkError *((^)(NSString *)))addErrorMessage {
    return ^(NSString *errorMessage) {
        _errorMessage = errorMessage;
        return self;
    };
}

- (ZNetworkError *((^)(NSInteger)))addErrorCode {
    return ^(NSInteger errorCode) {
        _errorCode = errorCode;
        return self;
    };
}

@end
