//
//  Utils.m
//  Medical_Wisdom
//
//  Created by renchunyu on 14-4-22.
//  Copyright (c) 2014年 renchunyu. All rights reserved.
//

#import "Utils.h"

#import "AppDelegate.h"

@implementation Utils

/*
 AppDelegate
 */
+ (AppDelegate *)applicationDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (UIImageView *)imageViewWithFrame:(CGRect)frame withImage:(UIImage *)image{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return [imageView autorelease];
}

+ (UILabel *)labelWithFrame:(CGRect)frame withTitle:(NSString *)title titleFontSize:(UIFont *)font textColor:(UIColor *)color backgroundColor:(UIColor *)bgColor alignment:(NSTextAlignment)textAlignment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = bgColor;
    label.textAlignment = textAlignment;
    return [label autorelease];
    
}


//alertView
+(UIAlertView *)alertTitle:(NSString *)title message:(NSString *)msg delegate:(id)aDeleagte cancelBtn:(NSString *)cancelName otherBtnName:(NSString *)otherbuttonName{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:aDeleagte cancelButtonTitle:cancelName otherButtonTitles:otherbuttonName, nil];
    [alert show];
    return [alert autorelease];
}

+(UIButton *)createBtnWithType:(UIButtonType)btnType frame:(CGRect)btnFrame backgroundColor:(UIColor*)bgColor{
    UIButton *btn = [UIButton buttonWithType:btnType];
    btn.frame = btnFrame;
    [btn setBackgroundColor:bgColor];
    return btn;
}

//利用正则表达式验证邮箱的合法性,方法不完整，后续改进
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


//MD5加密
+(NSString *)md5HexDigest:(NSString*)password

{
    
    const char *original_str = [password UTF8String];

    unsigned char result[CC_MD5_DIGEST_LENGTH];
 
    CC_MD5(original_str, (unsigned int)strlen(original_str), result);
  
    NSMutableString *hash = [NSMutableString string];
   
    for (int i = 0; i < 16; i++)
     
    {
       
        [hash appendFormat:@"%02X", result[i]];
      
    }
   
    NSString *mdfiveString = [hash lowercaseString];

    NSLog(@"Encryption Result = %@",mdfiveString);
    
    return mdfiveString;
}

@end
