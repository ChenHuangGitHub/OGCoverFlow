//
//  UIView+Extension.h
//


#import <UIKit/UIKit.h>

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@end
