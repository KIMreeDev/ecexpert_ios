//
//  GiftProductViewController.m
//  ECExpert
//
//  Created by JIRUI on 15/5/12.
//  Copyright (c) 2015年 JIRUI. All rights reserved.
//

#import <objc/runtime.h>
#import "GiftProductViewController.h"
#import "DateViewController.h"

@interface GiftProductViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UITableView     *tableView;

@property (strong, nonatomic) UITextField     *totalField;
@property (strong, nonatomic) UITextField     *dispatchField;
@property (strong, nonatomic) UIButton        *effectiveDateBtn;
@property (strong, nonatomic) UIButton        *expirationDateBtn;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation GiftProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"赠品详情";
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    [self initTableView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    [self.view addGestureRecognizer:tapGR];
    
    if (self.pageEditType != GiftPageEditTypeNone) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(commitChanges)];
    }
}

- (void)commitChanges{
    self.giftProduct.totalCount = [self.totalField.text integerValue];
    self.giftProduct.dispatchCount = [self.dispatchField.text integerValue];
    self.giftProduct.effectiveDate = [self.dateFormatter dateFromString:self.effectiveDateBtn.titleLabel.text];
    self.giftProduct.expirationDate = [self.dateFormatter dateFromString:self.expirationDateBtn.titleLabel.text];
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.giftProduct.totalCount == 0) {
        [self.giftArray removeObject:self.giftProduct];
    }
    [_supTableView reloadData];
}

- (void)removeKeyboard{
    [self.view endEditing:YES];
}

- (void)goback{
    if (self.pageEditType == GiftPageEditTypeNone) {
        [super goback];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"放弃修改?" message:@"放弃修改数据?" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [super goback];
            }
        }];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 移除: 派发数量 生效日期 失效日期
    return 10 - 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 没有必要重用
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
    CGRect dateBtnFrame    = CGRectMake(0, (44 - 30) / 2.0, 120, 30);
    
    CGRect labelFrame = CGRectMake(0, (44 - 22) / 2.0, contentRightViewFrame.size.width, 22);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 2;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [contentRightView addSubview:label];
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        cell.textLabel.text = @"商品名称：";
        label.text = self.giftProduct.productNameZH.length > 0 ? self.giftProduct.productNameZH: self.giftProduct.productNameEN;
        
    }else if (row == 1){
        cell.textLabel.text = @"商品条码：";
        label.text = self.giftProduct.scanCode;
        
    }else if (row == 2){
        cell.textLabel.text = @"赠品总数量：";
        [label removeFromSuperview];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        add.tag = 10;
        add.frame = addBtnFrame;
        add.tintColor = [UIColor redColor];
        [add addTarget:self action:@selector(totalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
        minus.tag = 11;
        minus.frame = minusBtnFrame;
        [minus setImage:[UIImage imageNamed:@"button_minus_red"] forState:UIControlStateNormal];
        minus.backgroundColor = [UIColor clearColor];
        [minus addTarget:self action:@selector(totalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _totalField = [[UITextField alloc] init];
        _totalField.textColor = [UIColor whiteColor];
        _totalField.frame = countFieldFrame;
        _totalField.textAlignment = NSTextAlignmentCenter;
        _totalField.keyboardType = UIKeyboardTypeDecimalPad;
        _totalField.delegate = self;
        _totalField.text = [NSString stringWithFormat:@"%lu",self.giftProduct.totalCount];
        
        [contentRightView addSubview:add];
        [contentRightView addSubview:minus];
        [contentRightView addSubview:_totalField];
        
        
        // 在 查看交易记录 和 赠品记录 时，赠品总数不会发生改变
        if (self.pageEditType == GiftPageEditTypeNone || self.pageEditType == GiftPageEditTypeDispatch) {
            add.hidden = YES;
            minus.hidden = YES;
            _totalField.enabled = NO;
        }
    
    }
    /*else if (row == 3){
        if (self.pageEditType == GiftPageEditTypeDispatch) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"本次分派赠品数量：%d", 0];
        }
        cell.textLabel.text = @"已分派数量：";
        [label removeFromSuperview];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeContactAdd];
        add.tag = 20;
        add.frame = addBtnFrame;
        add.tintColor = [UIColor redColor];
        [add addTarget:self action:@selector(dispatchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
        minus.tag = 21;
        minus.frame = minusBtnFrame;
        [minus setImage:[UIImage imageNamed:@"button_minus_red"] forState:UIControlStateNormal];
        minus.backgroundColor = [UIColor clearColor];
        [minus addTarget:self action:@selector(dispatchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _dispatchField = [[UITextField alloc] init];
        _dispatchField.textColor = [UIColor whiteColor];
        _dispatchField.frame = countFieldFrame;
        _dispatchField.textAlignment = NSTextAlignmentCenter;
        _dispatchField.keyboardType = UIKeyboardTypeDecimalPad;
        _dispatchField.delegate = self;
        _dispatchField.text = [NSString stringWithFormat:@"%lu",self.giftProduct.dispatchCount];
        
        [contentRightView addSubview:add];
        [contentRightView addSubview:minus];
        [contentRightView addSubview:_dispatchField];
        
        
        // 赠品分派数量，仅在 交易记录 中无法进行修改
        if (self.pageEditType == GiftPageEditTypeNone) {
            add.hidden = YES;
            minus.hidden = YES;
            _dispatchField.enabled = NO;
        }else if(self.pageEditType == GiftPageEditTypeDispatch){
            objc_setAssociatedObject(add, "DispatchCell", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(minus, "DispatchCell", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(_dispatchField, "DispatchCell", cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }else if (row == 4){
        cell.textLabel.text = @"生效日期：";
        [label removeFromSuperview];
        
        _effectiveDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_effectiveDateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _effectiveDateBtn.frame = dateBtnFrame;
        [_effectiveDateBtn setTitle:[self.dateFormatter stringFromDate:self.giftProduct.effectiveDate] forState:UIControlStateNormal];
        [_effectiveDateBtn addTarget:self action:@selector(changeDateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if(self.pageEditType != GiftPageEditTypeALL){
            _effectiveDateBtn.enabled = NO;
        }else{
            _effectiveDateBtn.layer.masksToBounds = YES;
            _effectiveDateBtn.layer.cornerRadius = 5;
            _effectiveDateBtn.layer.borderWidth = 1;
            _effectiveDateBtn.layer.borderColor = COLOR_LIGHT_BLUE_THEME.CGColor;
        }
    
        [contentRightView addSubview:_effectiveDateBtn];
    }else if (row == 5){
        cell.textLabel.text = @"失效日期：";
        [label removeFromSuperview];
        
        _expirationDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_expirationDateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _expirationDateBtn.frame = dateBtnFrame;
        [_expirationDateBtn setTitle:[self.dateFormatter stringFromDate:self.giftProduct.expirationDate] forState:UIControlStateNormal];
        [_expirationDateBtn addTarget:self action:@selector(changeDateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if(self.pageEditType != GiftPageEditTypeALL){
            _expirationDateBtn.enabled = NO;
        }else{
            _expirationDateBtn.layer.masksToBounds = YES;
            _expirationDateBtn.layer.cornerRadius = 5;
            _expirationDateBtn.layer.borderWidth = 1;
            _expirationDateBtn.layer.borderColor = COLOR_LIGHT_BLUE_THEME.CGColor;
        }
        
        [contentRightView addSubview:_expirationDateBtn];
    }*/
    else if (row == 3){
        cell.textLabel.text = @"品牌名称：";
        label.text = self.giftProduct.brandName;
        
    }else if (row == 4){
        cell.textLabel.text = @"规格型号：";
        label.text = self.giftProduct.specifications;
        
    }else if (row == 5){
        cell.textLabel.text = @"原产国：";
        label.text = self.giftProduct.originCountry;
        
    }else if (row == 6){
        cell.textLabel.text = @"装配国：";
        label.text = self.giftProduct.assembleCountry;
        
    }
    
    if (label) {
        CGSize labelSize = [label sizeThatFits:label.frame.size];
        label.frame = (CGRect){{label.frame.origin.x, label.frame.origin.y},labelSize};
    }
    
    return cell;
}

- (void)changeDateAction:(UIButton *)btn{
    NSDate *minDate = nil;
    NSDate *maxDate = nil;
    NSDate *autoSelectedDate = [self.dateFormatter dateFromString:btn.titleLabel.text];
    NSString *title;
    
    if (self.effectiveDateBtn == btn) {
        title = @"生效日期";
        maxDate = [self.dateFormatter dateFromString:self.expirationDateBtn.titleLabel.text];
    }else{
        title = @"失效日期";
        minDate = [self.dateFormatter dateFromString:self.effectiveDateBtn.titleLabel.text];
        NSString *nowStr = [self.dateFormatter stringFromDate:[NSDate date]];
        NSString *minStr = [self.dateFormatter stringFromDate:minDate];
        if ([minStr compare:nowStr] == NSOrderedAscending) {
            minDate = [self.dateFormatter dateFromString:nowStr];
        }
    }
    
    DateViewController *dateVC = [[DateViewController alloc] init];
    dateVC.title = title;
    dateVC.autoSelectedDate = autoSelectedDate;
    dateVC.minDate = minDate;
    dateVC.maxDate = maxDate;
    
    __unsafe_unretained UIButton *blockBtn = btn;
    __unsafe_unretained GiftProductViewController *blockSelf = self;
    dateVC.finishDatePickBlock = ^(NSDate *pickDate){
        [blockBtn setTitle:[blockSelf.dateFormatter stringFromDate:pickDate] forState:UIControlStateNormal];
    };
    [self.navigationController pushViewController:dateVC animated:YES];
}

// 赠品总数量修改
- (void)totalButtonAction:(UIButton *)btn{
    // button tag : 10 add    11 minus
    NSInteger btnTag = btn.tag;
    NSInteger dispatchNumber = [self.dispatchField.text integerValue];
    NSInteger countNumber = [self.totalField.text integerValue];
    
    if (btnTag == 10) {
        countNumber ++;
    }else if (btnTag == 11 && countNumber > dispatchNumber){
        countNumber --;
    }
    self.totalField.text = [NSString stringWithFormat:@"%lu", countNumber];
}

// 赠品已分派数量修改
- (void)dispatchButtonAction:(UIButton *)btn{
    // button tag : 20 add    21 minus
    NSInteger btnTag = btn.tag;
    NSInteger totalNumber = [self.totalField.text integerValue];
    NSInteger countNumber = [self.dispatchField.text integerValue];
    NSInteger baseDispatch = self.giftProduct.dispatchCount;
    
    if (btnTag == 20 && countNumber < totalNumber) {
        countNumber ++;
    }else if (btnTag == 21 && countNumber > 0){
        countNumber --;
    }
    
    // 分派赠品的时候，分派数量不能减少
    if (self.pageEditType == GiftPageEditTypeDispatch) {
        UITableViewCell *dispatchCell = objc_getAssociatedObject(btn, "DispatchCell");
        if (countNumber < baseDispatch) {
            countNumber = baseDispatch;
        }
        dispatchCell.detailTextLabel.text = [NSString stringWithFormat:@"本次分派赠品数量：%lu", (countNumber - baseDispatch)];
    }
    
    self.dispatchField.text = [NSString stringWithFormat:@"%lu", countNumber];
}

#pragma mark - UITableViewDelegate

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (self.totalField == textField) {
        NSInteger dispatch = [self.dispatchField.text integerValue];
        NSInteger total = [textField.text integerValue];
        if (dispatch > total) {
            total = dispatch;
            textField.text = [NSString stringWithFormat:@"%lu",total];
        }
        
    }else if (self.dispatchField == textField){
        NSInteger total = [self.totalField.text integerValue];
        NSInteger baseDispatch = self.giftProduct.dispatchCount;
        NSInteger dispatch = [textField.text integerValue];
        if (dispatch > total) {
            dispatch = total;
            textField.text = [NSString stringWithFormat:@"%lu",dispatch];
        }
        if (self.pageEditType == GiftPageEditTypeDispatch) {
            UITableViewCell *dispatchCell = objc_getAssociatedObject(textField, "DispatchCell");
            dispatchCell.detailTextLabel.text = [NSString stringWithFormat:@"本次分派赠品数量：%lu", (dispatch - baseDispatch)];
        }
        
    }
    
}

- (void)textFieldDidChange:(NSNotification*) notification{
    UITextField *textField = (UITextField *)[notification object];
    NSString *textValue = textField.text;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
