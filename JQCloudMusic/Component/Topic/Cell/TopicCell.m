//
//  TopicCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/20.
//

#import "TopicCell.h"

@implementation TopicCell

- (void)initViews{
    [super initViews];
    self.backgroundColor = [UIColor colorSurface];
    self.container.padding=UIEdgeInsetsMake(PADDING_MEDDLE, PADDING_OUTER, PADDING_MEDDLE, PADDING_OUTER);
    self.container.subviewSpace = PADDING_MEDDLE;
    
    [self.container addSubview:self.iconView];
    [self.container addSubview:self.rightContainer];
    
    //右侧容器
    [self.rightContainer addSubview:self.titleView];
    [self.rightContainer addSubview:self.infoView];
}

-(void)bindWithSheet:(Sheet *)data{
    [ImageUtil show:_iconView uri:data.icon];
    _titleView.text = data.title;
    _infoView.text = [R.string.localizable songCount:data.songsCount];
}

-(void)bindWithUser:(User *)data{
    [ImageUtil showAvatar:_iconView uri:data.icon];
    _titleView.text = data.nickname;
    _infoView.text = data.detail;
}

#pragma mark - 创建控件

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.myWidth = 51;
        _iconView.myHeight = 51;
        _iconView.image = R.image.placeholder;
        
        //图片从中心等比向外面填充，控件没有黑边，但图片可能被裁剪
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_iconView smallRadius];
        
    }
    return _iconView;
}

- (MyLinearLayout *)rightContainer{
    if (!_rightContainer) {
        _rightContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
        _rightContainer.myWidth = MyLayoutSize.fill;
        _rightContainer.myHeight = MyLayoutSize.wrap;
        _rightContainer.weight=1;
        _rightContainer.subviewSpace = 5;
        
    }
    return _rightContainer;
}

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel new];
        _titleView.myWidth = MyLayoutSize.fill;
        _titleView.myHeight = MyLayoutSize.wrap;
        _titleView.numberOfLines = 2;
        _titleView.text = @"测试";
        _titleView.font = [UIFont systemFontOfSize:TEXT_LARGE];
        _titleView.textColor = [UIColor colorOnSurface];
    }
    return _titleView;
}

- (UILabel *)infoView{
    if (!_infoView) {
        _infoView = [UILabel new];
        _infoView.myWidth = MyLayoutSize.fill;
        _infoView.myHeight = MyLayoutSize.wrap;
        _infoView.numberOfLines = 2;
        _infoView.text = @"测试";
        _infoView.font = [UIFont systemFontOfSize:TEXT_SMALL];
        _infoView.textColor = [UIColor black80];
    }
    return _infoView;
}

@end
