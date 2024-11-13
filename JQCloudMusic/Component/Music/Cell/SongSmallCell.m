//
//  SongSmallCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "SongSmallCell.h"

@implementation SongSmallCell
- (void)initViews{
    [super initViews];
    self.container.paddingLeading = PADDING_OUTER;
    self.container.paddingTrailing = PADDING_OUTER;
    self.container.myHeight=MyLayoutSize.fill;
    self.container.subviewSpace = PADDING_SMALL;
    self.container.gravity = MyGravity_Vert_Center;
    
    [self.container addSubview:self.iconView];
    
    [self.container addSubview:self.rightContainer];
    [self.rightContainer addSubview:self.titleView];
    
    //歌词
//    _lineView = [LyricLineView new];
//    _lineView.myWidth = MyLayoutSize.fill;
//    _lineView.myHeight = 14;
//    _lineView.gravity = LyricLineGravityLeft;
//    _lineView.lyricTextSize = 12;
//
//    //这一行歌词始终是选中状态
//    [_lineView setLineSelected:YES];
//    [self.rightContainer addSubview:_lineView];
}

-(MyOrientation)getContainerOrientation{
    return MyOrientation_Horz;
}

- (void)bind:(Song *)data{
    [ImageUtil show:_iconView uri:data.icon];
    _titleView.text = data.title;
}

#pragma mark - 创建控件
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.myWidth = 35;
        _iconView.myHeight = 35;
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
        _rightContainer.subviewSpace = PADDING_SMALL;
        
    }
    return _rightContainer;
}

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel new];
        _titleView.myWidth = MyLayoutSize.fill;
        _titleView.myHeight = MyLayoutSize.wrap;
        _titleView.numberOfLines = 1;
        _titleView.text = @"标题";
        _titleView.font = [UIFont systemFontOfSize:TEXT_MEDDLE];
        _titleView.textColor = [UIColor colorOnSurface];
    }
    return _titleView;
}
@end
