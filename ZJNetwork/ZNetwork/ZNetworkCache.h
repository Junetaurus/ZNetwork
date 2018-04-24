//
//  ZNetworkCache.h
//  ZJNetwork
//
//  Created by Zhang on 2018/3/30.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNetworkCache : NSObject

/**
 设置缓存

 @param cacheFileName 路径
 @param responseObject 缓存数据
 */
- (void)setCacheWithFileName:(NSString *)cacheFileName responseObject:(id)responseObject;

/**
 获取缓存

 @param cacheFileName 路径
 @param response 缓存数据
 */
- (void)cacheWithFileName:(NSString *)cacheFileName response:(void (^)(NSDictionary *dic))response;

/**
 移除缓存

 @param filePath 路径
 @return 移除结果
 */
- (BOOL)removeFileOfPath:(NSString *)filePath;

@end
