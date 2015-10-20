//
//  ApiDef.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#ifndef jirui_ApiDef_h
#define jirui_ApiDef_h

// 条形码查询接口
#define API_BAR_CODE_URL @"http://www.kimree.com.cn/app/scancode.php?scancode=%@"  // 扫描条形码
#define API_LOGIN_URL_NEW @"http://www.kimree.com.cn/app/?action=login"  // 登录
#define API_LOGOUT_URL_NEW @"http://www.kimree.com.cn/app/?action=logout"  // 登出
#define API_SIGNIN_URL_NEW @"http://www.kimree.com.cn/app/?action=joinuser" // 注册
#define API_GETUSERINFO_URL_NEW @"http://www.kimree.com.cn/app/?action=getuserinfo" //获取个人信息
#define API_CHECKVIP_URL @"http://www.kimree.com.cn/app/?action=checkvip"  // 根据用户id和会员卡号确定用户合法性
#define API_TRADE_INPUT_URL @"http://www.kimree.com.cn/app/?action=typetrade"  // 录入交易
#define API_TRADE_RECORD_SELECT_URL @"http://www.kimree.com.cn/app/?action=selecttrade" // 查看交易记录
#define API_TRADE_RECORD_DETAIL_URL @"http://www.kimree.com.cn/app/?action=tradeinfo"  // 交易记录详情

#define API_EDITUSERINFO_URL_NEW @"http://www.kimree.com.cn/app/?action=moduser&modway=moduserinfo"       //修改个人信息
#define API_MODIFY_PASSWORD_NEW @"http://www.kimree.com.cn/app/?action=moduser&modway=modpassword"               //修改个人密码
#define API_CHANGEPASSWORD_URL_NEW @"http://www.kimree.com.cn/app/?action=moduser&modway=modpassword"   //更改密码
#define API_UPLOADUSERHEADER_URL_NEW @"http://www.kimree.com.cn/app/?action=moduser&modway=moduserimage"  //修改用户图片


// 服务器地址
#define API_POSTBAR_URL @"http://www.ecigarfan.com/api/api.php?action=postbar" //v1.0
//#define API_LOGIN_URL @"http://www.ecigarfan.com/api/api.php?action=login"             //登陆
//#define API_SIGNIN_URL @"http://www.ecigarfan.com/api/api.php?action=register"         //注册
//#define API_GETUSERINFO_URL @"http://www.ecigarfan.com/api/api.php?action=getuserinfo" //获取个人信息
//#define API_EDITUSERINFO_URL @"http://www.ecigarfan.com/api/api.php?action=moduser&modway=moduserinfo"       //修改个人信息
//#define API_MODIFY_PASSWORD @"http://www.ecigarfan.com/api/api.php?action=moduser&modway=modpassword"               //修改个人密码
//#define API_UPLOADUSERHEADER_URL @"http://www.ecigarfan.com/api/api.php?action=moduser&modway=moduserimage"  //修改用户图片

//旧接口
//#define API_DEALER_URL @"http://www.ecigarfan.com/api/api.php?action=getdealer&effect_tm="                 //获取经销商信息
#define API_DEALER_URL @"http://www.ecig100.com/api/?action=getDealer"                 //获取经销商及烟酒商信息
#define API_CHANGEPASSWORD_URL @"http://www.ecigarfan.com/api/api.php?action=moduser&modway=modpassword"   //更改密码
#define API_PRODUCT_URL @"http://www.ecigarfan.com/api/api.php?action=products&publishtm="                             //产品信息
#define API_GETPRODUCTIMAGE_URL @"http://www.ecigarfan.com/api/api.php?action=getproimage&proid="          //产品详细图片
#define API_GETPRODUCTCATE_URL @"http://www.ecigarfan.com/api/api.php?action=productclass"                 //产品分类接口
#define API_GETADVERTISEMENT_URL @"http://www.ecigarfan.com/api/api.php?action=getad"                  //获取广告接口
#define API_FEEDBACK_URL @"http://www.ecigarfan.com/api/api.php?action=sendask"                  //用户反馈接口
#define API_RESETPASSWORD_URL @"http://www.ecigarfan.com/api/api.php?action=forgetpw"                  //找回密码接口

#define API_MOBILEWEB_URL @"http://www.ecigarfan.com/app/ekmi_mobile.html"    //手机版网页
#define API_MOBILENEWS_URL @"http://www.ecigarfan.com/app/ekmi_news.html"    //手机版新闻
#define API_USEAGREEMENT_URL @"http://www.ecigarfan.com/app/ekmi_agree.html"    //协议网页
#define API_ABOUT_URL @"http://www.ecigarfan.com/app/ekmi_about.html"    //关于网页



#define API_SHOPPIING_URL @"http://www.ecigarfan.com/api/api.php?action=shopping"   //购物接口


//应用信息获取API
#define APP_URL @"https://itunes.apple.com/lookup?id=948643406"


#define API_SHOPPINGCART_ARL  @""         //购物车
#define API_BILL_ALR  @""                 //账单
#define API_CONSIGNEE  @""                //收货人信息，包括地址等
#define API_MEMBERSCORE @""               //会员积分
#define API_LOGISTICS  @""                //物流信息
#define API_GAMEINFORMATION @""           //游戏信息



//kIMREE

#define API_LOGIN_SID @"sid"



//#define API_SERVER_URL @"http://httapi.hai0.com" //v2.0
#define API_SERVER_PATH @""
#define API_SERVER_PARAMS @""
// 接口版本
#define API_VER 1
//
// APP
//
// 注册，第一次打开App客户端，请求用户uid
#define API_CMD_APP_REGISTER @"register"
// 获取基本信息
#define API_CMD_APP_INFO @"get.baseinfo"
// 上传token
#define API_CMD_APP_UPLOAD_TOKEN @"report.pushid"
// 意见反馈
#define API_CMD_APP_FEEDBACK @"add.feedback"
/*
    帖子模块
 */
//版块列表
#define API_CMD_MOD_LIST @"mod.list"
//请求他人帖子
#define API_CMD_OtherPOST_LIST @"otherpost.list"
// 帖子列表
#define API_CMD_ALLPOST_LIST @"allpost.list"
// 新建帖子
#define API_CMD_POST_CREATE @"post.create"
// 删除帖子
#define API_CMD_POST_DELETE @"mypost.delete"
//消息列表
#define API_CMD_NEWS_LIST @"news.list"
//删除消息
#define API_CMD_NEWS_DELETE @"news.delete"
//评论列表
#define API_CMD_COMMENT_LIST @"comment.list"
//帖子回复
#define API_CMD_POST_REPLY @"post.reply"
//评论回复
#define API_CMD_COMMENT_REPLY @"comment.reply"
//
#endif




















