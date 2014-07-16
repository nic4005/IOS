//
//  CWUserDataManager
//  ciwenKids
//
//  Created by ciwenkids on 14-6-20.
// Copyright (c) 2014年 xhb. All rights reserved.
//

#import "CWUserDataManager.h"
#import "SharedConst.h"
#import "GCDSingleton.h"
#import "CommonMacros.h"
#import "CWHttpNetWorkManager.h"

@implementation CWUserDataManager

SINGLETON_GCD(CWUserDataManager);

- (id) initWithCoder: (NSCoder *)coder
{
    if (self = [super init])
    {
        self.phoneNum = [coder decodeObjectForKey:@"phoneNum"];
        self.balance = [coder decodeObjectForKey:@"balance"];
        self.urgencyPhone = [coder decodeObjectForKey:@"urgencyPhone"];
        self.nickName = [coder decodeObjectForKey:@"nickName"];
        self.commDest = [coder decodeObjectForKey:@"commDest"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.tokenID = [coder decodeObjectForKey:@"tokenID"];
        
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder *)coder{
    [coder encodeObject:_phoneNum forKey:@"phoneNum"];
    [coder encodeObject:_balance forKey:@"balance"];
    [coder encodeObject:_urgencyPhone forKey:@"urgencyPhone"];
    [coder encodeObject:_nickName forKey:@"nickName"];
    [coder encodeObject:_commDest forKey:@"commDest"];
    [coder encodeObject:_sex forKey:@"sex"];
    [coder encodeObject:_tokenID forKey:@"tokenID"];
}

-(id)init{
    self = [super init];
    if (self) {
        _phoneNum = @"";
        _balance = @"";
        _urgencyPhone = @"";
        _nickName = @"";
        _commDest = @"";
        _sex = @"0";
        _tokenID = @"";
    }
    return self;
}

-(void)userLogin:(NSString *)email password:(NSString *)password{
    [Utility dismissHud];
    [Utility presentHud:@"正在登录"];
    CWHttpNetWorkManager *httpNetManager = [CWHttpNetWorkManager sharedCWHttpNetWorkManager];
    
    NSDictionary *assetsDic = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email",
                                                                                                                         password,@"password",
                                                                                                                         nil];
    
    [httpNetManager submitObjectForPOST:BASE_URL_SCHEME path:JSON_POST_PREFIX_USER_LOGIN andAssets:assetsDic succecd:^(id jsonObject) {
        NSDictionary *headerDic = [jsonObject objectForKey:@"header"];
        NSString *status = [[headerDic objectForKey:@"status"] stringValue];
        NSLog(@"STAUS = %@",status);
        if ([@"1"isEqualToString:status]) {
//           S NSDictionary *bodyDic = [jsonObject objectForKey:@"body"];
            
            
            [Utility saveDataForUserDefault:CONST_USER_DATA data:self];
            POST_NOTIFICATION(NOTIFICATION_userLogin);
            
            [Utility presentAlertView:@"登录成功" message:@"登录成功"];
            [Utility dismissHud];
        }else{
            [Utility presentAlertView:@"登录失败" message:@"登录失败"];
            [Utility dismissHud];
        }
    } faild:^(NSError *error) {
        NSLog(@"login faild!");
        [Utility dismissHud];
    }];
}

-(void)registerNewUser:(NSString *)email password:(NSString *)password sex:(NSString *)sex nickname:(NSString *)nickname wechat:(NSString *)wechat birthday:(NSString *)birthday{
    [Utility presentHud:@"请稍后"];
    CWHttpNetWorkManager *httpNetManager = [CWHttpNetWorkManager sharedCWHttpNetWorkManager];
    NSDictionary *assetsDic = [NSDictionary
                               dictionaryWithObjectsAndKeys:email, @"email",
                               password,@"password",
                               //0 male || 1 female
                               sex, @"userInfo.sex",
                               nickname, @"userInfo.nickname",
                               wechat, @"userInfo.weixinNo",
                               birthday, @"userInfo.dateOfBirth",
                               nil];
//    [httpNetManager submitObjectForPOST:BASE_URL_SCHEME path:JSON_POST_PREFIX_USER_REGISTER andAssets:assetsDic succecd:^(id jsonObject) {
//                NSDictionary *headerDic = [jsonObject objectForKey:@"header"];
//                NSString *status = [[headerDic objectForKey:@"status"] stringValue];
//                if ([@"1"isEqualToString:status]) {
////                    NSDictionary *bodyDic = [jsonObject objectForKey:@"body"];
//                    [self userLogin:self.phoneNum password:@"code"];
//                }else{
//                    [Utility presentAlertView:@"注册失败" message:@"注册失败"];
//                    [Utility dismissHud];
//                }
//    } faild:^(NSError *error) {
//        DLOG(@"error code = %@",error);
//        [Utility dismissHud];
//    }];
//
}



-(void)clearUserInfomation{
    _phoneNum = @"";
    _tokenID = @"";
    _balance = @"";
    _urgencyPhone = @"";
    _nickName = @"";
    _sex = @"0";
    _commDest = @"";
    [Utility removeDataFromUserDefault:CONST_USER_DATA];
}

-(BOOL)userHasLogin{
    CWUserDataManager *userData = (CWUserDataManager *)[Utility gainLocalDataFromUserDefault:CONST_USER_DATA];
    if ([userData.phoneNum isEqualToString:@""] || userData.phoneNum == nil)
        return NO;
    else
        return YES;
}

-(void)setupUserData{
    CWUserDataManager *userData = (CWUserDataManager *)[Utility gainLocalDataFromUserDefault:CONST_USER_DATA];
    if (!userData) {
        return;
    }
    self.phoneNum = userData.phoneNum;
    self.tokenID = userData.tokenID;
    self.balance = userData.balance;

    self.urgencyPhone = userData.urgencyPhone;
    self.nickName = userData.nickName;
    self.sex = userData.sex;
    self.commDest = userData.commDest;
}


#pragma mark
#pragma mark - fetch user info
-(void)fetchUserData{
//    CWHttpNetWorkManager *httpNetManager = [CWHttpNetWorkManager sharedCWHttpNetWorkManager];
//    CWUserDataManager *userData = [CWUserDataManager sharedCWUserDataManager];
//    NSString *reqUrl = [Utility requestURL:JSON_INSERT_PREFIX_CONTENT_HISTORY parameters:userData.phoneNum];
//    [httpNetManager queryObjectForGET:reqUrl succecd:^(id jsonObject){
//        NSDictionary *headerDic = [jsonObject objectForKey:@"header"];
//        NSString *status = [[headerDic objectForKey:@"status"] stringValue];
//        if ([@"1"isEqualToString:status]) {
//            NSDictionary *bodyDic = [jsonObject objectForKey:@"body"];
//            NSDictionary  *userDic = [bodyDic objectForKey:@"user"];
//            self.userID = [[userDic objectForKey:@"id"] stringValue];
//            self.email = email;
//            self.regDate = [userDic objectForKey:@"registerTime"];
//            self.password = password;
//            self.userName = nickname;
//            self.sex = sex;
//            self.birthday = birthday;
//            NSDictionary  *userInfoDic = [bodyDic objectForKey:@"user"];
//            self.wechatNO = [userInfoDic objectForKey:@"weixinNo"];
//            self.userType = [[userInfoDic objectForKey:@"type"] isEqualToString:@"0"]?userNoPayed:userPayed;
//            [self userLogin:self.email password:self.password];
//        }else{
//            [Utility presentAlertView:@"注册失败" message:@"注册失败"];
//            [Utility dismissHud];
//        }
//    } faild:^(NSError *error){
//        NSLog(@"error = %@",error);
//    }];

}
@end
