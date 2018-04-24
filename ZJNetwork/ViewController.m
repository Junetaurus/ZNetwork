//
//  ViewController.m
//  ZJNetwork
//
//  Created by Zhang on 2018/3/20.
//  Copyright © 2018年 Zhang. All rights reserved.
//

#import "ViewController.h"
#import "ZNetworkManager.h"

static NSString *urlStr = @"https://apis.zcdog.com:50183/api/user/userMgr/user/activities";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)request {
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    headers[@"appid"] = @"zcdog";
    headers[@"ChannelId"] = @"ios";
    headers[@"VersionCode"] = @"5.4";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tabid"] = @"43";  //14 31  43
    
    [[ZNetworkManager sharedInstance] requestWithHttpMethod:GET urlSring:urlStr requestSerializer:nil responseSerializer:nil headers:headers parameters:params cache:YES userCache:NO success:^(AFHTTPSessionManager *manager, id responseObject, BOOL isCache) {
        NSLog(@"responseObject = %@\nisCache = %d", responseObject ,isCache);
    } failure:^(AFHTTPSessionManager *manager, ZNetworkError *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self request];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
