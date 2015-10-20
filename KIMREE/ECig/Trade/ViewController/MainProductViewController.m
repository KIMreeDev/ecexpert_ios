//
//  MainProductViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/9.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import <objc/runtime.h>
#import "MainProductViewController.h"

@interface MainProductViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextField *countField;

@end

@implementation MainProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    [self initTableView];    
    
    if(self.isEdit){
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
        [self.view addGestureRecognizer:tapGR];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(commitChanges)];
    }
}

- (void)commitChanges{
    
    self.mainProduct.totalCount = [self.countField.text integerValue];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.mainProduct.totalCount == 0) {
        [self.productArray removeObject:self.mainProduct];
    }
    [_supTableView reloadData];
    
}

- (void)goback{
    if (self.isEdit) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"放弃修改?" message:@"放弃修改数据?" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [super goback];
            }
        }];
    }else{
        [super goback];
    }
    
}

- (void)removeKeyboard{
    [self.countField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView{
    CGFloat _x,_y,_w,_h;
    _w = KM_SCREEN_WIDTH,
    _x = 0;
    _y = 0;
    _h = KM_SCREEN_HEIGHT;
    if (self.navigationController) {
        _y = 64;
        _h -= 64;
    }
    if (self.tabBarController) {
        _h -= 49;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(_x, _y, _w, _h) style:UITableViewStylePlain];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBA(0, 0, 0, 0.3);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // tableviewcell 不需要重用
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    CGRect contentFrame = cell.contentView.frame;
    CGRect contentRightViewFrame = CGRectMake(contentFrame.size.width / 2.0, contentFrame.origin.y, contentFrame.size.width / 2.0, contentFrame.size.height);
    UIView *contentRightView = [[UIView alloc] initWithFrame:contentRightViewFrame];
    [cell.contentView addSubview:contentRightView];
    
    CGRect minusBtnFrame   = CGRectMake(0, (44 - 22) / 2.0, 22, 22);
    CGRect countFieldFrame = CGRectMake(0 + 22, (44 - 22) / 2.0, 60, 22);
    CGRect addBtnFrame     = CGRectMake(22 + 60, (44 - 30) / 2.0, 30, 30);
    
    CGRect labelFrame = CGRectMake(0, (44 - 22) / 2.0, contentRightViewFrame.size.width, 22);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [contentRightView addSubview:label];
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"商品名称：";
        label.text = self.mainProduct.productNameZH.length > 0 ? self.mainProduct.productNameZH: self.mainProduct.productNameEN;
        
    }else if (row == 1){
        cell.textLabel.text = @"商品条码：";
        label.text = self.mainProduct.scanCode;
        
    }else if (row == 2) {
        cell.textLabel.text = @"商品数量：";
        [label removeFromSuperview];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        add.tag = 1;
        add.frame = addBtnFrame;
        add.tintColor = [UIColor redColor];
        [add addTarget:self action:@selector(countButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
        minus.tag = 2;
        minus.frame = minusBtnFrame;
        [minus setImage:[UIImage imageNamed:@"button_minus_red"] forState:UIControlStateNormal];
        minus.backgroundColor = [UIColor clearColor];
        [minus addTarget:self action:@selector(countButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _countField = [[UITextField alloc] init];
        _countField.frame = countFieldFrame;
        _countField.textColor = [UIColor whiteColor];
        _countField.textAlignment = NSTextAlignmentCenter;
        _countField.keyboardType = UIKeyboardTypeDecimalPad;
        _countField.delegate = self;
        _countField.text = [NSString stringWithFormat:@"%lu", self.mainProduct.totalCount];
        
        [contentRightView addSubview:add];
        [contentRightView addSubview:minus];
        [contentRightView addSubview:_countField];
        
        if (!self.isEdit) {
            add.hidden = YES;
            minus.hidden = YES;
            _countField.enabled = NO;
        }
    }else if (row == 3){
        cell.textLabel.text = @"品牌名称：";
        label.text = self.mainProduct.brandName;
        
    }else if (row == 4){
        cell.textLabel.text = @"规格型号：";
        label.text = self.mainProduct.specifications;
        
    }else if (row == 5){
        cell.textLabel.text = @"原产国：";
        label.text = self.mainProduct.originCountry;
        
    }else if (row == 6){
        cell.textLabel.text = @"装配国：";
        label.text = self.mainProduct.assembleCountry;
        
    }
    
    if (label) {
        CGSize labelSize = [label sizeThatFits:label.frame.size];
        label.frame = (CGRect){{label.frame.origin.x, label.frame.origin.y},labelSize};
    }
    
    return cell;
}

- (void)countButtonAction:(UIButton *)btn{
    // button tag : 1 add    2 minus
    NSInteger btnTag      = btn.tag;
    NSInteger countNumber = [self.countField.text integerValue];
    
    if (btnTag == 1) {
        countNumber ++;
    }else if (btnTag == 2 && countNumber > 0){
        countNumber --;
    }
    self.countField.text = [NSString stringWithFormat:@"%lu", countNumber];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(NSNotification*) notification{
    UITextField *textField = (UITextField *)[notification object];
    NSString *textValue    = textField.text;
    NSString *removeString = objc_getAssociatedObject(textField, "RemoveString");
    
    NSRange range = [textValue rangeOfString:removeString];
    textValue = [textValue stringByReplacingCharactersInRange:range withString:@""];
    textField.text = textValue;

    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *intRegex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", intRegex];
    BOOL isInt = [predicate evaluateWithObject:string];
    
    if (!isInt) {
        
        objc_setAssociatedObject(textField, "RemoveString", string, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }
    
    return YES;
}


#pragma mark - UITableViewDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
