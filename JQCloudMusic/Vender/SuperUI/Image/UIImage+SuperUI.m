//
//  UIImage+SuperUI.m
//  JQCloudMusic
//  对图片扩展的一些方法
//  Created by zhangjq on 2024/10/16.
//

#import "UIImage+SuperUI.h"

@implementation UIImage (SuperUI)
-(UIImage *)withTintColor{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)imageWithColor:(UIColor *)color {

   CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context =UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);

    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

   return image;

}
@end
