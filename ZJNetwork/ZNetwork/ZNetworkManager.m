//
//  ZNetworkManager.m
//  ZJNetwork
//
//  Created by Zhang on 2018/3/29.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import "ZNetworkManager.h"
#import "ZNetworkCache.h"

#import <RealReachability/RealReachability.h>
#import "NSString+NetworkString.h"

@interface ZNetworkManager ()

@property (nonatomic, strong) ZNetworkCache *networkCache;
@property (nonatomic, strong) RealReachability *reachability;

@end

@implementation ZNetworkManager

+ (instancetype)sharedInstance {
    static ZNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZNetworkManager alloc] init];
    });
    return manager;
}

- (void)requestWithHttpMethod:(HttpMethod)method
                              urlSring:(NSString *)urlSring
                     requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
                    responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer
                               headers:(NSDictionary *)headers
                            parameters:(NSDictionary *)parameters
                                 cache:(BOOL)isCache
                             userCache:(BOOL)isUserCache
                               success:(void (^)(AFHTTPSessionManager *manager, id responseObject, BOOL isCache))success
                               failure:(void (^)(AFHTTPSessionManager *manager, ZNetworkError *error))failure {
    if (!urlSring) return;
    //Network status judgment
    if (![self isConnectionAvailable]) {
        !failure ? : failure(nil, [ZNetworkError sharedInstance].addErrorMessage(zNoNetworkMessage).addErrorCode(zNoNetworkCode));
        return;
    }
    NSString *joinUrl = [urlSring joinTogetherUrlWithDic:parameters];
    NSString *cacheFileName = nil;
    //cache
    if (isCache) {
        if (isUserCache) {
            //user
            joinUrl = [joinUrl joinTogetherUrlWithDic:@{@"userId":@"000000"}];
        }
        cacheFileName = [joinUrl stringByAppendingString:@".txt"].md5;
        [self.networkCache cacheWithFileName:cacheFileName response:^(NSDictionary *dic) {
            if (dic) {
                !success ? : success(nil, dic, YES);
            }
        }];
    }
    //AFHTTPSessionManager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //securityPolicy
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    //requestSerializer
    if (!requestSerializer) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    manager.requestSerializer = requestSerializer;
    //responseSerializer
    if (!responseSerializer) {
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    manager.responseSerializer = responseSerializer;
    //time
    manager.requestSerializer.timeoutInterval = 10.0;
    //headers
    if (headers && headers.count) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    //request
    __weak ZNetworkManager *this = self;
    if (method == GET) {
        [manager GET:urlSring parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isCache) {
                [this.networkCache setCacheWithFileName:cacheFileName responseObject:responseObject];
            }
            !success ? : success(manager, responseObject, NO);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            !failure ? : failure(manager, [ZNetworkError sharedInstance].addErrorMessage(error.description).addErrorCode(error.code));
        }];
    }
    if (method == POST) {
        [manager POST:urlSring parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (isCache) {
                [this.networkCache setCacheWithFileName:cacheFileName responseObject:responseObject];
            }
            !success ? : success(manager, responseObject, NO);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            !failure ? : failure(manager, [ZNetworkError sharedInstance].addErrorMessage(error.description).addErrorCode(error.code));
        }];
    }
}

#pragma mark - Network status judgment
- (BOOL)isConnectionAvailable {
    if (self.reachability.currentReachabilityStatus == RealStatusNotReachable) {
        return NO;
    }
    return YES;
}

- (ZNetworkCache *)networkCache {
    if (!_networkCache) {
        _networkCache = [[ZNetworkCache alloc] init];
    }
    return _networkCache;
}

- (RealReachability *)reachability {
    if (!_reachability) {
        _reachability = [RealReachability sharedInstance];
        [_reachability startNotifier];
    }
    return _reachability;
}

@end
