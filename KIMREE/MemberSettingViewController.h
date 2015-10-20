//
//  MemberSettingViewController.h
//  ECIGARFAN
//
//  Created by renchunyu on 14-5-30.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
#import "BaseViewController.h"


@interface MemberSettingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,QRCodeReaderDelegate>

{
    UIView *feedbackView,*aboutView;
    
}
@property (nonatomic,strong) NSString *userName,*userNickname,*userLevel;
@property (strong, nonatomic)  UITableView *memberTableView;
@property (nonatomic,strong) UIImageView *headView,*imageView;
@property (strong,nonatomic) UITextView *information;

@end
