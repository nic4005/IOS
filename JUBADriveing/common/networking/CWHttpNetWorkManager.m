//
//  MSHttpNetWorkManager.m
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "CWHttpNetWorkManager.h"
#import "GCDSingleton.h"
#import "OpenUDID.h"

@implementation CWHttpNetWorkManager

SINGLETON_GCD(CWHttpNetWorkManager);

-(void)queryObjectForGET:(NSString *)url
                 succecd:(void (^)(id))succes
                   faild:(void (^)(NSError *))faild{
    
    NSMutableString *urlStr = [[NSMutableString alloc] init];
    [urlStr appendString:url];
    NSMutableDictionary *parDic = [self setupSystemParameter];
    
    NSRange range = [urlStr rangeOfString:@"?"];
    if (range.length ==0){
        [urlStr appendString:@"?"];
    }
    
    int i = 0;
    for (NSString *key in parDic) {
        i++;
        [urlStr appendString:[NSString stringWithFormat:@"%@=%@",key,parDic[key]]];
        if ([parDic allKeys].count != i) {
            [urlStr appendString:@"&"];
        }
    }
    NSLog(@"url = %@",urlStr);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    AFJSONRequestOperation *jsonRequest = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [jsonRequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succes(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        faild(error);
    }];
    
    [jsonRequest start];
}

-(void)submitObjectForPOST:(NSString *)baseUrl
                      path:(NSString *)path
                 andAssets:(NSDictionary *)assets
                   succecd:(void (^)(id))succes
                     faild:(void (^)(NSError *))faild{
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseUrl]];
    [client setParameterEncoding:AFFormURLParameterEncoding];
    NSMutableDictionary *parDic = [self setupSystemParameter];
    for (NSString *key in assets) {
        [parDic setObject:assets[key] forKey:key];
    }

    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"POST" path:path parameters:parDic];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        succes(json);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        faild(error);
    }];
    
    [requestOperation start];
}

-(NSMutableDictionary *)setupSystemParameter{
    // ipad  = 1   iphone = 2
    NSString *openid = [OpenUDID value];
    NSString *platform = IS_IPAD?@"1":@"2";
    NSString *systemVersion = [NSString stringWithFormat:@"%f",IOS_VERSION];
    NSString *appVersion =[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
    NSString *identifierForVendor = @"";
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)])
        identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSMutableDictionary *dicAssets = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      openid, @"openid",
                                      platform, @"platform",
                                      systemVersion, @"sysVersion",
                                      appVersion, @"appVersion",
                                      identifierForVendor , @"idfv",
                                      nil];
    
    return dicAssets;
}
@end
