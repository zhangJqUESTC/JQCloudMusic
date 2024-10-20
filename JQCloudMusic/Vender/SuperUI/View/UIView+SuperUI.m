//
//  UIView+SuperUI.m
//  JQCloudMusic
//  扩展显示隐藏控件快捷方法
//  Created by zhangjq on 2024/10/17.
//

#import "UIView+SuperUI.h"

@implementation UIView (SuperUI)
/// 设置隐藏控件
-(void)hide{
    self.visibility = MyVisibility_Gone;
}

/// 设置隐藏控件，但还是暂用位置
-(void)invisible{
    self.visibility = MyVisibility_Invisible;
}

/// 显示控件
-(void)show{
    self.visibility = MyVisibility_Visible;
}

/// 显示控件
/// @param show 是否显示
-(void)show:(BOOL)show{
    self.visibility = show ? MyVisibility_Visible : MyVisibility_Gone;
}

-(void)smallRadius{
    //小圆角
    self.layer.cornerRadius = SMALL_RADIUS;
    self.clipsToBounds=YES;
}

- (void)radiusWithSize:(float)size{
    self.layer.cornerRadius = size;
    self.clipsToBounds=YES;
}

- (void)radius{
    [self radiusWithSize:MEDDLE_RADIUS];
}

- (void)setViewAnchorPoint:(CGPoint)data{
    //原来的锚点
    CGPoint originAnchorPoint = self.layer.anchorPoint;

    //要偏移的锚点
    CGPoint offetPoint = CGPointMake(data.x - originAnchorPoint.x, data.y - originAnchorPoint.y);

    //要偏移的距离
    CGFloat offetX = offetPoint.x * self.frame.size.width;
    CGFloat offetY = offetPoint.y * self.frame.size.height;

    //设置这个值 说明已经改变了偏移量
    self.layer.anchorPoint = data;

    //将指定的偏宜量更改回来
    self.layer.position = CGPointMake(self.layer.position.x+offetX, self.layer.position.y+offetY);
}
@end
