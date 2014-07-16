//
//  SharedConst.h
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#ifndef ciwenKids_SharedConst_h
#define ciwenKids_SharedConst_h

#pragma mark -
#pragma mark BASE URL

//#define BASE_URL_SCHEME @"http://192.168.1.1:8081/"
#define BASE_URL_SCHEME @"http://dev.buddiestv.com/"


#pragma mark -
#pragma mark JSON

//==================user==================
//get code
#define JSON_QUERY_PREFIX_VERIFY_CODE @"user/getCode"
// user login
#define JSON_POST_PREFIX_USER_LOGIN @"user/login"
//user info
#define JSON_QUERY_PREFIX_USER_INFO @"user/info"
//perfect information
#define JSON_POST_PREFIX_PERFECT_INFO @"user/info/complete"

//==================order================
//history
#define JSON_QUERY_PREFIX_ORDER_HISTORY @"account/historyOrder"
//history order info
#define JSON_QUERY_PREFIX_ORDER_INFO@"account/historyOrder/info"
//current order
#define JSON_QUERY_PREFIX_CURRENT_ORDER @"account/currentOrder"
//current order info
#define JSON_QUERY_PREFIX_CURRENT_ORDER_INFO @"account/currentOrder/info"
//appoint order
#define JSON_POST_PREFIX_APPOINT_ORDER @"appoint"
//order quick
#define JSON_POST_PREFIX_ORDER_QUICK @"order/quick"



//===================Driver================
//nearyby driver
#define JSON_QUERY_PREFIX_NEARYBY_DRIVER @"map/nearbyDrivers"
//comment list
#define JSON_QUERY_PREFIX_COMMENT LIST @"driver/comment"


//grade
#define JSON_POST_PREFIX_DRIVER_GRADE @"driver/grade"

//=================setting=================
//suggestion
#define JSON_POST_PREFIX_SUGGESTION @"suggestion"
//price list
#define JSON_QUERY_PREFIX_PRICE_LIST @"price/list"


//==================payment==================
// verify payment
#define JSON_POST_PREFIX_VERIFY_PAYMENT @"account/receipt/verify"


//==================network=====================
#define NOTIFICATION_hostReachabilitySwitchON @"HOST_REACHABILITY_SWITCH_ON"
#define NOTIFICATION_hostReachabilitySwitchOFF @"HOST_REACHABILITY_SWITCH_OFF"



#pragma mark -
#pragma mark Notification
//--------------------account--------------------
#define NOTIFICATION_gotoUserCenter @"GOTO_USERCENTER"

//--------------------user------------------------
#define NOTIFICATION_userLogin @"USER_LOGIN"

//--------------------MSG-----------------------
#define NOTIFCATION_SUBQUESTION_SELECTED @"SUBQUESTION_SELECTED"

#define JSON_QUERY_ASSET_VALUE_RES_VER 2


//-------------------collection view cell id------------------------------
#define COMMON_VIDEO_CELL_ID @"COMMON_VIDEO_ID"


//--------------------const size--------------------
#define NAVIGATION_SIZE_HEIGHT 60
#define TABBAR_SIZE_HEIGHT 60


//--------------------page ID--------------------
#define STORE_PAGE_ID_MAIN 301
#define STORE_PAGE_ID_CHARACTER 302
#define STORE_PAGE_ID_COLLECTION 303
#define STORE_PAGE_ID_RECOMMENDATION 305

//--------------------font--------------------
#define STORE_FONT_CN  @"STHeitiTC-Medium"

//--------------------greeting string--------------------


//--------------------const key--------------------
#define CONST_FIRST_START @"CONST_FIRST_START"
#define CONST_USER_DATA @"CONST_USER_DATA"
#define CONST_USER_ID @"CONST_USER_ID"
#define CONST_USER_PHONE_NUMBER @"CONST_USER_PHONE_NUMBER"

//#define GREETING_NETWORK_NOT_AVAILABLE @"您的网络没有连接上哦～请检查一下吧！"
#define GREETING_NETWORK_NOT_AVAILABLE @"未能连接到服务器～请稍候再试一下吧！"
#define GREETING_NEED_USER_LOGIN_MESSAGE @"需要登录才可以查看喔！"
#define GREETING_COLLECTION_NEED_USER_LOGIN_MESSAGE @"需要登录才可以收藏喔！"
#define GREETING_CONNECT_SERVER_FAILD @"连接服务器失败！"

//--------------------label string--------------------
#define MINE_FUNCTION_FIRST_TITLESTRING @"美丽日记"
#define MINE_FUNCTION_FIRST_DESCSTRING @"在这里可以清楚的看到你的美容计划哦"
#define MINE_FUNCTION_SECEND_TITLESTRING @"订单管理"


#endif

