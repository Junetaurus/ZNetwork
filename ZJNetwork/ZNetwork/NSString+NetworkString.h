//
//  NSString+NetworkString.h
//  ZJNetwork
//
//  Created by Zhang on 2018/3/29.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NetworkString)

- (NSString *)joinTogetherUrlWithDic:(NSDictionary *)dic;

- (NSDictionary *)urlStrToDic;

- (NSString *)md5;

@end
