//
//  SongCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/7.
//

#import "SongCell.h"

@implementation SongCell

- (void)initViews{
    [super initViews];
    self.container.backgroundColor = [UIColor colorBackgroundLight];
    
    //右侧有边距
    self.container.padding = UIEdgeInsetsMake(0, 0, 0, PADDING_SMALL);
    self.container.gravity = MyGravity_Vert_Center | MyGravity_Horz_Stretch;
    
    //左侧容器
    MyRelativeLayout *leftContainer = [MyRelativeLayout new];
    leftContainer.myWidth = 50;
    leftContainer.myHeight = 50;
    [self.container addSubview:leftContainer];
    
    //索引
    [leftContainer addSubview:self.indexView];
    
    //右侧容器
    MyLinearLayout *rightContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
//    rightContainer.myWidth = MyLayoutSize.fill;
    rightContainer.myHeight = MyLayoutSize.wrap;
    rightContainer.subviewSpace = 5;
    [self.container addSubview:rightContainer];
    
    //标题
    [rightContainer addSubview:self.titleView];
    
    //信息容器
    MyLinearLayout *infoContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    infoContainer.myWidth = MyLayoutSize.fill;
    infoContainer.myHeight = MyLayoutSize.wrap;
    infoContainer.subviewSpace = 5;
    [rightContainer addSubview:infoContainer];
    
    [infoContainer addSubview:self.downloadedView];
    [infoContainer addSubview:self.infoView];
    
    //更多按钮
    QMUIButton *moreButton = [ViewFactoryUtil buttonWithImage:[R.image.moreVerticalDot withTintColor]];
    moreButton.tintColor = [UIColor black80];
    moreButton.myWidth = 50;
    moreButton.myHeight = 50;
    [self.container addSubview:moreButton];
}

- (void)bind:(Song *)data{
    //显示标题
    _titleView.text = data.title;
    
    //显示信息
    _infoView.text = [NSString stringWithFormat:@"%@ - 这是专辑",data.singer.nickname];
}

#pragma mark - 创建控件
- (UILabel *)indexView{
    if (!_indexView) {
        _indexView = [UILabel new];
        _indexView.myWidth = MyLayoutSize.wrap;
        _indexView.myHeight = MyLayoutSize.wrap;
        _indexView.myCenter = CGPointMake(0, 0);
        _indexView.numberOfLines = 1;
        _indexView.text = @"1";
        _indexView.font = [UIFont systemFontOfSize:TEXT_LARGE];
        _indexView.textColor = [UIColor black80];
    }
    return _indexView;
}


- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel new];
        _titleView.myWidth = MyLayoutSize.fill;
        _titleView.myHeight = MyLayoutSize.wrap;
        _titleView.numberOfLines = 1;
        _titleView.text = @"标题";
        _titleView.font = [UIFont systemFontOfSize:TEXT_LARGE2];
        _titleView.textColor = [UIColor colorOnSurface];
    }
    return _titleView;
}

- (UIImageView *)downloadedView{
    if (!_downloadedView) {
        _downloadedView = [UIImageView new];
        _downloadedView.myWidth = MyLayoutSize.wrap;
        _downloadedView.myHeight=MyLayoutSize.wrap;
        _downloadedView.visibility=MyVisibility_Gone;
        _downloadedView.image = R.image.dayRecommend;
    }
    return _downloadedView;
}

- (UILabel *)infoView{
    if (!_infoView) {
        _infoView = [UILabel new];
        _infoView.myWidth = MyLayoutSize.fill;
        _infoView.myHeight = MyLayoutSize.wrap;
        _infoView.numberOfLines = 1;
        _infoView.text = @"标题";
        _infoView.font = [UIFont systemFontOfSize:TEXT_MEDDLE];
        _infoView.textColor = [UIColor black80];
    }
    return _infoView;
}

@end
