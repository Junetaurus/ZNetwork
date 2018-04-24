//
//  ZNetworkCache.m
//  ZJNetwork
//
//  Created by Zhang on 2018/3/30.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import "ZNetworkCache.h"

@interface ZNetworkCache ()

@property (nonatomic, strong) NSCache *networkCatch;
@property (nonatomic, strong) dispatch_queue_t networkCatchQueue;

@end

@implementation ZNetworkCache

- (void)setCacheWithFileName:(NSString *)cacheFileName responseObject:(id)responseObject {
    dispatch_async(self.networkCatchQueue, ^{
        if (responseObject) {
            //
            [self.networkCatch setObject:responseObject forKey:cacheFileName];
            //
            NSString *fileName = [[self getCachePath] stringByAppendingPathComponent:cacheFileName];
            NSData *data = nil;
            if ([responseObject isKindOfClass:[NSData class]]) {
                id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                data = [NSKeyedArchiver archivedDataWithRootObject:json];
            } else {
                data = [NSKeyedArchiver archivedDataWithRootObject:responseObject];
            }
            if (data) {
                [self saveFile:fileName withData:data];
            }
        }
    });
}

- (void)cacheWithFileName:(NSString *)cacheFileName response:(void (^)(NSDictionary *dic))response {
    dispatch_async(self.networkCatchQueue, ^{
        NSDictionary *responseDic = nil;
        if ([self.networkCatch objectForKey:cacheFileName]) {
            responseDic = [self.networkCatch objectForKey:cacheFileName];
        } else {
            NSString *fileName = [[self getCachePath] stringByAppendingPathComponent:cacheFileName];
            NSData *data = [self getFileData:fileName];
            if (data) {
                responseDic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                //
                [self.networkCatch setObject:responseDic forKey:cacheFileName];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            !response ? : response(responseDic);
        });
    });
}

- (BOOL)saveFile:(NSString *)filePath withData:(NSData *)data {
    BOOL ret = YES;
    ret = [self creatFileWithPath:filePath];
    if (ret) {
        ret = [data writeToFile:filePath atomically:YES];
        if (!ret) {
            NSLog(@"%s Failed",__FUNCTION__);
        }
    } else {
        NSLog(@"%s Failed",__FUNCTION__);
    }
    return ret;
}

- (NSData *)getFileData:(NSString *)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *fileData = [handle readDataToEndOfFile];
    [handle closeFile];
    return fileData;
}

- (BOOL)creatFileWithPath:(NSString *)filePath {
    BOOL isSuccess = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL temp = [fileManager fileExistsAtPath:filePath];
    if (!temp) {
        isSuccess = [fileManager createFileAtPath:filePath contents:nil attributes:nil];
    }
    return isSuccess;
}

- (NSString *)getCachePath {
    NSArray *filePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [filePaths objectAtIndex:0];
}

- (BOOL)removeFileOfPath:(NSString *)filePath {
    BOOL flag = YES;
    NSFileManager *fileManage = [NSFileManager defaultManager];
    if ([fileManage fileExistsAtPath:filePath]) {
        if (![fileManage removeItemAtPath:filePath error:nil]) {
            flag = NO;
        }
    }
    return flag;
}

- (NSCache *)networkCatch {
    if (!_networkCatch) {
        _networkCatch = [[NSCache alloc] init];
    }
    return _networkCatch;
}

- (dispatch_queue_t)networkCatchQueue {
    if (!_networkCatchQueue) {
        _networkCatchQueue = dispatch_queue_create("com.dispatch.ZNetworkCatch", DISPATCH_QUEUE_SERIAL);
    }
    return _networkCatchQueue;
}

@end

