//
//  RecordCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/19.
//

#import "RecordCell.h"

//唱片每16毫秒旋转的弧度

//角度转弧度：度数 * (π / 180）
//每16毫秒转0.2304度(用秒表测转一圈的时间)
//0.2304*(PI/180)=0.004021238596595

//在原来的基础上每16毫秒
//顺时针选中0.004021238596595弧度
static CGFloat const SIZE_RECORD_ROTATE = 0.004021238596595;

@implementation RecordCell

- (void)initViews{
    [super initViews];
    self.container.gravity = MyGravity_Horz_Center | MyGravity_Vert_Center;
    self.contentContainer = [MyRelativeLayout new];
    
    //宽为最外层容器宽度0.731倍
    self.contentContainer.widthSize.equalTo(self.container.widthSize).multiply(0.731);
    
    //高和自己宽度一样
    self.contentContainer.heightSize.equalTo(self.contentContainer.widthSize);
    self.contentContainer.myTop=80;
    [self.container addSubview:self.contentContainer];
    
    //封面
    [self.contentContainer addSubview:self.iconView];
    
    //黑胶唱片背景
    UIImageView *backgroundView = [UIImageView new];
    backgroundView.myWidth = MyLayoutSize.fill;
    backgroundView.myHeight = MyLayoutSize.fill;
    backgroundView.image = R.image.recordBackground;
    backgroundView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentContainer addSubview:backgroundView];
}

- (void)bind:(Song *)data{
    self.data = data;
    
    //显示封面
    [ImageUtil show:self.iconView uri:data.icon];
}

-(void)rotate{
    //在已有的基础上
    //旋转指定的弧度
    self.contentContainer.transform = CGAffineTransformRotate(self.contentContainer.transform, SIZE_RECORD_ROTATE);
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.widthSize.equalTo(self.contentContainer.widthSize).multiply(0.64);
        _iconView.heightSize.equalTo(_iconView.widthSize);
        _iconView.image = R.image.placeholder;
        _iconView.myCenter = CGPointMake(0, 0);
        _iconView.clipsToBounds=YES;
        
        //图片从中心等比向外面填充，控件没有黑边，但图片可能被裁剪
        _iconView.contentMode = UIViewContentModeScaleAspectFill;

    }
    return _iconView;
}
@end
