//
//  ItemTableViewController.h
//  ECIGARFAN
//
//  Created by cool on 14-6-8.
//  Copyright (c) 2014年 cool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewController : UITableViewController <UITextFieldDelegate>
@property (strong,nonatomic) NSString  *itemTitle,*itemText,*nickName,*birthday;
@property (strong,nonatomic) UITextField *oldPasswordTextFiled,*changedPasswordTextFiled,*comfirmPasswordTextFiled,*ModifyTextFiled;

//- (void)getUserInfoFromNetwork;
//- (void)submitUserInfo;
@end
