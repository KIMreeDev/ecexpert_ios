//
//  TableGameViewController.m
//  ECIGARFAN
//
//  Created by renchunyu on 14-4-30.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "TableGameViewController.h"

@interface TableGameViewController ()

@end

@implementation TableGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =NSLocalizedString(@"Wheel of Fortune", @"");
    
    //添加转盘
    UIImageView *image_disk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"disk.jpg"]];
    image_disk.frame = CGRectMake(0.0, 65.0, 320.0, 320.0);
    image1 = image_disk;
    [self.view addSubview:image1];
    
    //添加转针
    UIImageView *image_start = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start.png"]];
    image_start.frame = CGRectMake(103.0, 120.0, 120.0, 210.0);
    image2 = image_start;
    [self.view addSubview:image2];
    
    //添加按钮
    UIButton *btn_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn_start.frame = CGRectMake(110.0, kScreen_Height-95, 100.0, 40.0);
    [btn_start setTitleColor:COLOR_LIGHT_BLUE_THEME forState:UIControlStateNormal];
    [btn_start setTitle:NSLocalizedString(@"Have a try", @"") forState:UIControlStateNormal];
    [btn_start addTarget:self action:@selector(tableGame) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_start];
    
    UIButton *scroe_start = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    scroe_start.frame = CGRectMake(0.0, kScreen_Height-50, 160.0, 50.0);
    [scroe_start setTitle:NSLocalizedString(@"Your score", @"") forState:UIControlStateNormal];
    [scroe_start addTarget:self action:@selector(checkScore) forControlEvents:UIControlEventTouchUpInside];
    scroe_start.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    [scroe_start setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    [self.view addSubview:scroe_start];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exit.frame = CGRectMake(160.0, kScreen_Height-50, 160.0, 50.0);
    [exit setTitle:NSLocalizedString(@"Exit", @"") forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    exit.backgroundColor=COLOR_LIGHT_BLUE_THEME;
    [exit setTitleColor:COLOR_WHITE_NEW forState:UIControlStateNormal];
    [self.view addSubview:exit];

}

-(void)exit
{
  
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)checkScore
{
    UIAlertView *score = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Your score is", @"") message:@"769394" delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", @"") otherButtonTitles: nil];
    
    [score show];

}

- (void)tableGame
{
    //******************旋转动画******************
    //产生随机角度
    srand((unsigned)time(0));  //不加这句每次产生的随机数不变
    random = (rand() % 20) / 10.0;
    //设置动画
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [spin setFromValue:[NSNumber numberWithFloat:M_PI * (0.0+orign)]];
    [spin setToValue:[NSNumber numberWithFloat:M_PI * (10.0+random+orign)]];
    [spin setDuration:2.5];
    [spin setDelegate:self];//设置代理，可以相应animationDidStop:finished:函数，用以弹出提醒框
    //速度控制器
    [spin setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //添加动画
    [[image2 layer] addAnimation:spin forKey:nil];
    //锁定结束位置
    image2.transform = CGAffineTransformMakeRotation(M_PI * (10.0+random+orign));
    //锁定fromValue的位置
    orign = 10.0+random+orign;
    orign = fmodf(orign, 2.0);
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //判断抽奖结果
    if (orign >= 0.0 && orign < (0.5/3.0)) {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the First prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
       
    }
    else if (orign >= (0.5/3.0) && orign < ((0.5/3.0)*2))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Seventh prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
       
    }else if (orign >= ((0.5/3.0)*2) && orign < ((0.5/3.0)*3))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Sixth prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= (0.0+0.5) && orign < ((0.5/3.0)+0.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Seventh prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= ((0.5/3.0)+0.5) && orign < (((0.5/3.0)*2)+0.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Fifth prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
      
    }else if (orign >= (((0.5/3.0)*2)+0.5) && orign < (((0.5/3.0)*3)+0.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Seventh prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= (0.0+1.0) && orign < ((0.5/3.0)+1.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Fourth prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
      
    }else if (orign >= ((0.5/3.0)+1.0) && orign < (((0.5/3.0)*2)+1.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Seventh prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= (((0.5/3.0)*2)+1.0) && orign < (((0.5/3.0)*3)+1.0))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Third prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= (0.0+1.5) && orign < ((0.5/3.0)+1.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Seventh prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= ((0.5/3.0)+1.5) && orign < (((0.5/3.0)*2)+1.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Second prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }else if (orign >= (((0.5/3.0)*2)+1.5) && orign < (((0.5/3.0)*3)+1.5))
    {
        UIAlertView *result = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"congratulation!", @"") message:NSLocalizedString(@"You win the Seventh prize!", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Accept the prize!", @"") otherButtonTitles: nil];
        [result show];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
