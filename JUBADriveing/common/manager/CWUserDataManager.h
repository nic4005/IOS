//
//  CWUserDataManager
//  ciwenKids
//
//  Created by ciwenkids on 14-6-20.
// Copyright (c) 2014年 xhb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	userNoPayed = 0,
    userPayed  = 1,
} userType;


@interface CWUserDataManager : NSObject

@property(nonatomic, copy)NSString *tokenID;
@property(nonatomic, copy)NSString *phoneNum;
@property(nonatomic, copy)NSString *balance;
@property(nonatomic, copy)NSString *urgencyPhone;
@property(nonatomic, copy)NSString *nickName;
@property(nonatomic, copy)NSString *sex;
@property(nonatomic, copy)NSString *commDest;

+(CWUserDataManager *)sharedCWUserDataManager;

-(void)userLogin:(NSString *)email password:(NSString *)password;
-(void)clearUserInfomation;
-(void)registerNewUser:(NSString *)email password:(NSString *)password sex:(NSString *)sex nickname:(NSString *)nickname wechat:(NSString *)wechat birthday:(NSString *)birthday;
-(void)setupUserData;

-(BOOL)userHasLogin;

-(void)fetchUserData;
@end
