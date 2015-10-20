//
//  ItemTableViewController.m
//  ECIGARFAN
//
//  Created by cool on 14-6-8.
//  Copyright (c) 2014年 cool. All rights reserved.
//

#import "ItemTableViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "AFNetworkingFactory.h"

@interface ItemTableViewController ()

@property (strong,nonatomic) UIBarButtonItem *saveBtn;
@property (strong,nonatomic) ASIFormDataRequest *request;
@end

@implementation ItemTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_BACKGROUND;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _saveBtn=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", "") style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = _saveBtn;

    _ModifyTextFiled=[[UITextField alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    _ModifyTextFiled.borderStyle= UITextBorderStyleRoundedRect;
    _ModifyTextFiled.delegate  =self;
    _ModifyTextFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    _ModifyTextFiled.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _ModifyTextFiled.returnKeyType = UIReturnKeyDone;
    _ModifyTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;

    
    _oldPasswordTextFiled=[self textFieldInit:_changedPasswordTextFiled];
    _oldPasswordTextFiled.placeholder = NSLocalizedString(@"OLD PASSWORD", "");
    _oldPasswordTextFiled.tag = Tag_OldPasswordTextField;
   
    
     _changedPasswordTextFiled=[self textFieldInit:_changedPasswordTextFiled];
     _changedPasswordTextFiled.placeholder = NSLocalizedString(@"NEW PASSWORD", "");
    _changedPasswordTextFiled.tag = Tag_TempPasswordTextField;

    
    _comfirmPasswordTextFiled=[self textFieldInit:_comfirmPasswordTextFiled];
    _comfirmPasswordTextFiled.placeholder = NSLocalizedString(@"NEW PASSWORD", "");
    _comfirmPasswordTextFiled.tag = Tag_ConfirmPasswordTextField;

}


-(UITextField*)textFieldInit:(UITextField*)textField
{
    textField=[[UITextField alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    textField.borderStyle= UITextBorderStyleRoundedRect;
    textField.delegate = self;
    textField.secureTextEntry = YES;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}


//保存

-(void)save{
    
    _saveBtn.enabled=NO;
    NSString *url =[[NSString alloc] init];
    if ([_itemTitle isEqualToString:NSLocalizedString(@"Password", "")]) {
        url=API_CHANGEPASSWORD_URL_NEW;
    }else
    {
        url=API_EDITUSERINFO_URL_NEW;
    }
    
    //提交
    if ([self.title isEqualToString:NSLocalizedString(@"Password", "")]) {
        if ([self checkValidityTextField]) {
            
            [self LinkNetWork:url];
        }
    }else
        
        
        [self LinkNetWork:url];
    
}


- (BOOL)checkValidityTextField
{

    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"NO password", "") delegate:self cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text] isEqualToString:@""]) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"NO comfirm password", "") delegate:self cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        
        return NO;
    }
    
    
    if ([[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] length] < 6) {
        
        [Utils alertTitle:nil message:NSLocalizedString(@"Password lengh must be over 6 numbers including letters!", "") delegate:nil cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        return NO;
    }
    if (![[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:[(UITextField *)[self.view viewWithTag:Tag_ConfirmPasswordTextField] text]]) {
        [Utils alertTitle:nil message:NSLocalizedString(@"The two input password does not match!", "") delegate:nil cancelBtn:NSLocalizedString(@"Cancel", "") otherBtnName:nil];
        return NO;
    }
    
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.title isEqualToString:NSLocalizedString(@"Gender", "")]&&section==1) {
        return 2;
    }else if([self.title isEqualToString:NSLocalizedString(@"Password", "")]&&section==1){
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 0;
    }
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *FooterView = [[UIView alloc] init];
    FooterView.backgroundColor = COLOR_BACKGROUND;
    return FooterView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:nil];
        cell.backgroundColor=COLOR_BACKGROUND;
    }
    if (indexPath.section==1) {
        if ([self.title isEqualToString:NSLocalizedString(@"Gender", "")]) {
            
            if (indexPath.row==0) {
                if ([_itemText isEqualToString:NSLocalizedString(@"male", "")]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                UILabel *maleLabel=[[UILabel alloc] init];
                [self leftLabelInit:maleLabel name:NSLocalizedString(@"male", "") size:CGRectMake(10, 20, 100, 40) numerOfLines:1 fontSize:15];
                [cell addSubview:maleLabel];
                
                UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 80, 320, 1)];
                view.backgroundColor=COLOR_SEPERATER;
                [cell addSubview:view];
                
                
            }else {
                if ([_itemText isEqualToString:NSLocalizedString(@"female", "")]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                UILabel *femaleLabel=[[UILabel alloc] init];
                [self leftLabelInit:femaleLabel name:NSLocalizedString(@"female", "") size:CGRectMake(10, 20, 100, 40) numerOfLines:1 fontSize:15];
                [cell addSubview:femaleLabel];
            }
        }else if([self.title isEqualToString:NSLocalizedString(@"Password", "")]){
            
            if (indexPath.row==0) {

                [cell addSubview:_oldPasswordTextFiled];
            }else if(indexPath.row==1)
            {

                [cell addSubview:_changedPasswordTextFiled];
            }else{

                [cell addSubview:_comfirmPasswordTextFiled];
            }
            
        }
        else
        {
            if ([self.title isEqualToString:NSLocalizedString(@"Phone", "")]) {
                _ModifyTextFiled.keyboardType= UIKeyboardTypeNumberPad;
            }
            
            _ModifyTextFiled.text=_itemText;
            [cell addSubview:_ModifyTextFiled];
        }
    }
    
    
    return cell;
}

//初始化方法
-(void)leftLabelInit:(UILabel*)label name:(NSString*)string size:(CGRect)frame numerOfLines:(int)num fontSize:(int)size{
    label.text=string;
    label.textColor=COLOR_DARK_GRAY;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentLeft;
    label.frame = frame;
    label.numberOfLines=num;
    
    label.font =[UIFont boldSystemFontOfSize:size];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.title isEqualToString:NSLocalizedString(@"Gender", "")]) {
        NSArray *array = [tableView visibleCells];
        for (UITableViewCell *cell in array) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
        if (indexPath.row==1) {
            _itemText=NSLocalizedString(@"male", "");
        }else{
            _itemText=NSLocalizedString(@"female", "");
        }
    }
    
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:API_LOGIN_SID];
        [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
        
        LoginViewController *secVC=[[LoginViewController alloc] init];
        [self.navigationController pushViewController:secVC animated:YES];

}


//网络请求

- (void)LinkNetWork:(NSString *)strUrl
{
    _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    [_request setDelegate:self];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setTimeOutSeconds:10];
    
    if ([strUrl isEqualToString:API_GETUSERINFO_URL_NEW]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *loginUserInfo = appDelegate.loginUser;
        [_request setPostValue:[loginUserInfo objectForKey:@"usertype"] forKey:@"usertype"];
        _request.tag=102;
        
    }else {
        if ([self.title isEqualToString:NSLocalizedString(@"Nickname", "")]) {
            [_request setPostValue:_ModifyTextFiled.text forKey:@"customer_nickname"];
        } else if([_itemTitle isEqualToString:NSLocalizedString(@"Password", "")]){
            [_request setPostValue:_oldPasswordTextFiled.text forKey:@"oldpassword"];
            [_request setPostValue:_changedPasswordTextFiled.text forKey:@"newpassword"];
            
        }else
        {
            //后台规定必须带nickname ，bug
            [_request setPostValue:_nickName forKey:@"customer_nickname"];
            
            
            if ([self.title isEqualToString:NSLocalizedString(@"Birthday", "")]) {
                [_request setPostValue:_birthday forKey:@"customer_birth"];
            }
            if ([self.title isEqualToString:NSLocalizedString(@"Signature", "")]) {
                [_request setPostValue:_ModifyTextFiled.text forKey:@"customer_sign"];
            }
            if ([self.title isEqualToString:NSLocalizedString(@"Gender", "")]) {
                if ([_itemText isEqualToString:NSLocalizedString(@"male", "")]) {
                    [_request setPostValue:@"1" forKey:@"customer_sex"];
                }else if([_itemText isEqualToString:NSLocalizedString(@"female", "")])
                {
                    [_request setPostValue:@"0" forKey:@"customer_sex"];
                }
            }
            if ([self.title isEqualToString:NSLocalizedString(@"Region", "")]) {
                [_request setPostValue:_ModifyTextFiled.text forKey:@"customer_address"];
            }
            if ([self.title isEqualToString:NSLocalizedString(@"Email", "")]) {
                [_request setPostValue:_ModifyTextFiled.text forKey:@"customer_email"];
            }
            if ([self.title isEqualToString:NSLocalizedString(@"Phone", "")]) {
                [_request setPostValue:_ModifyTextFiled.text forKey:@"customer_phone"];
            }
        }
        
        //[MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Sending...", @"")  ];
    
    }

 
    [_request startAsynchronous];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
      _saveBtn.enabled=YES;
     [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Failed to connect link to server!", "") dismissAfter:1.0f];
    
//    if (request.tag==102) {
//        [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"Get user information...", "")];
//        [MMProgressHUD dismissWithError:NSLocalizedString(@"Failed to connect link to server!", "")];
//        
//       
//    }else {
//    
//        [MMProgressHUD showWithTitle:nil status:NSLocalizedString(@"submit...", "") ];
//        [MMProgressHUD dismissWithError:NSLocalizedString(@"Failed to connect link to server!", "")];
//       
//    }

}

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSData *jsonData = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error;
    NSMutableDictionary *rootDic = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    int status=[[rootDic objectForKey:@"code"] intValue];
    if (request.tag==102) {
        
        if (status==1) {
            
            [[LocalStroge sharedInstance] deleteFileforKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            [[LocalStroge sharedInstance] addObject:[rootDic objectForKey:@"data"] forKey:F_USER_INFORMATION filePath:NSDocumentDirectory];
            [self.navigationController popViewControllerAnimated:YES];
            
            // 修改数据后要重新查询登录用户信息，查询成功后需要刷新界面显示，在需要刷新显示数据的地方接收该通知进行处理
            [[NSNotificationCenter defaultCenter] postNotificationName:KM_REFRESH_LOGIN_USER_INFO object:nil];
        }
        else{
            
        }
        _saveBtn.enabled=YES;

        
    }else {
    
        if (status==1) {
            
           
            [self LinkNetWork:API_GETUSERINFO_URL_NEW];
            //[MMProgressHUD dismissWithSuccess:nil];
            [JDStatusBarNotification showWithStatus:NSLocalizedString(@"Successful modification!", "") dismissAfter:1.0f];

        }
        else{
            
            _saveBtn.enabled=YES;
            
            if([[rootDic objectForKey:@"data"] isEqualToString:@"操作失败！原因：未登录或登录过期"]){
                //[MMProgressHUD dismissWithSuccess:nil];
                
                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Login timeout,please login again", "") delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", "") otherButtonTitles: nil];
                [alertView show];
            }else
            {
                
               // [MMProgressHUD dismissWithError:[rootDic objectForKey:@"data"]];
                [JDStatusBarNotification showWithStatus:[rootDic objectForKey:@"data"] dismissAfter:1.0f];

            }
        }
       

    }
    
}


-(void)dealloc
{
    
    [_request cancel];
    [_request clearDelegatesAndCancel];
    
}


@end
