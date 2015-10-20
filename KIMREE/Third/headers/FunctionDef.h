//
//  FunctionDef.h
//  ECIGARFAN
//
//  Created by JIRUI on 14-4-18.
//  Copyright (c) 2014年 JIRUI. All rights reserved.
//

#ifndef jirui_FunctionDef_h
#define jirui_FunctionDef_h

//颜色
#define F_COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define F_COLOR_RGB(r,g,b) F_COLOR_RGBA(r,g,b,1.0)

//字符串
#define F_STR_INT(i) [NSString stringWithFormat:@"%d",i]
#define F_STR_FLOAT(f) [NSString stringWithFormat:@"%f",f]
#define F_STR_FLOAT2(format,f) [NSString stringWithFormat:format,f]
#define F_STR_DOUBLE(d) [NSString stringWithFormat:@"%lf",d]
#define F_STR_DOUBLE2(format,d) [NSString stringWithFormat:format,d]
#define F_STR_BOOL(b) [NSString stringWithFormat:@"%@",b?@"YES":@"NO"]
#define F_STR_BOOL2(b) [NSString stringWithFormat:@"%d",b]
#define F_STR_REPLACE_IF_NEEDED(str1,str2) str1 ? str1 : str2

//数值对象
#define F_NUM_INT(i) [NSNumber numberWithInt:i]
#define F_NUM_FLOAT(f) [NSNumber numberWithFloat:f]
#define F_NUM_DOUBLE(d) [NSNumber numberWithDouble:d]
#define F_NUM_BOOL(b) [NSNumber numberWithBool:b]

//UserDefaults
#define F_UD_VALUE(key) [S_USER_DEFAULTS valueForKey:key]
#define F_UD_STR(key) [S_USER_DEFAULTS stringForKey:key]
#define F_UD_BOOL(key) [S_USER_DEFAULTS boolForKey:key]
#define F_UD_ARRAY(key) [S_USER_DEFAULTS arrayForKey:key]
#define F_UD_OBJECT_KEY(v,k) [S_USER_DEFAULTS setObject:v forKey:k]
#define F_UD_BOOL_KEY(b,k) [S_USER_DEFAULTS setBool:v forKey:k]

//文件路径
#define F_PATH_IN_DOCUMENTS(path) [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",path]]
#define F_PATH_IN_BUNDLE(name,type) [[NSBundle mainBundle] pathForResource:name ofType:type]

//图片
#define F_IMG(name) [UIImage imageNamed:name]

//JSON
#define F_JSON_REPLACE_NULL(x)        [[x stringByReplacingOccurrencesOfString : @":null" withString : @":\"\""] stringByReplacingOccurrencesOfString : @":NaN" withString : @":\"0\""]

#endif























