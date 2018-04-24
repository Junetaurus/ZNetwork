//
//  NSString+NetworkString.m
//  ZJNetwork
//
//  Created by Zhang on 2018/3/29.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import "NSString+NetworkString.h"

#import<CommonCrypto/CommonDigest.h>

@implementation NSString (NetworkString)

- (NSString *)joinTogetherUrlWithDic:(NSDictionary *)dic {
    if (dic && [dic isKindOfClass:[NSDictionary class]] && dic.count) {
        NSMutableString *string = [NSMutableString stringWithString:self];
        if (![string containsString:@"?"]) {
            [string appendString:@"?"];
        }
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [string appendFormat:@"%@=%@&",key,obj];
        }];
        
        if ([string rangeOfString:@"&"].length) {
            [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
        }
        return string.copy;
    } else {
        return self;
    }
}

- (NSDictionary *)urlStrToDic {
    if (self && self.length && [self rangeOfString:@"?"].length == 1) {
        NSArray *array = [self componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

- (NSString *)md5 {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", buffer[i]];
    }
    return output;
}

@end
