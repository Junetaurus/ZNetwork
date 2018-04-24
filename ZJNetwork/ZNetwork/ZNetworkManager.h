//
//  ZNetworkManager.h
//  ZJNetwork
//
//  Created by Zhang on 2018/3/29.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ZNetworkError.h"

typedef NS_ENUM(NSInteger, HttpMethod) {
    GET,
    POST,
};

@interface ZNetworkManager : NSObject

+ (instancetype)sharedInstance;

/**
 request

 @param method get post ...
 @param urlSring urlSring
 @param requestSerializer 默认 [AFHTTPRequestSerializer serializer]
 @param responseSerializer 默认 [AFJSONResponseSerializer serializer]
 @param headers headers
 @param parameters parameters
 @param isCache 是否缓存
 @param isUserCache 是否根据用户缓存
 @param success success
 @param failure failure
 */
- (void)requestWithHttpMethod:(HttpMethod)method
                              urlSring:(NSString *)urlSring
                     requestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer
                    responseSerializer:(AFHTTPResponseSerializer <AFURLResponseSerialization> *)responseSerializer
                               headers:(NSDictionary *)headers
                            parameters:(NSDictionary *)parameters
                                 cache:(BOOL)isCache
                             userCache:(BOOL)isUserCache
                               success:(void (^)(AFHTTPSessionManager *manager, id responseObject, BOOL isCache))success
                               failure:(void (^)(AFHTTPSessionManager *manager, ZNetworkError *error))failure;

@end
