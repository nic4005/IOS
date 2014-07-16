//
//  MSHttpNetWorkManager.h
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface CWHttpNetWorkManager : NSObject

+(CWHttpNetWorkManager *)sharedCWHttpNetWorkManager;

// GET
-(void)queryObjectForGET:(NSString *)url
                 succecd:(void (^)(id jsonObject))succes
                   faild:(void (^)(NSError *error))faild;


// POST
-(void)submitObjectForPOST:(NSString *)baseUrl
                      path:(NSString *)path
                 andAssets:(NSDictionary *)Assets
                   succecd:(void (^)(id jsonObject))succes
                     faild:(void (^)(NSError *error))faild;
@end
