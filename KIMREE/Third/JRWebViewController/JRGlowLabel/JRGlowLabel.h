#import <UIKit/UIKit.h>

@interface JRGlowLabel : UILabel
@property (nonatomic, assign) CGFloat glowSize;
@property (nonatomic) UIColor *glowColor;
@property (nonatomic, assign) CGFloat innerGlowSize;
@property (nonatomic) UIColor *innerGlowColor;
@end

