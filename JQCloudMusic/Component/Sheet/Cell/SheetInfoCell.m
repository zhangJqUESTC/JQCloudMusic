//
//  SheetInfoCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "SheetInfoCell.h"
#import <YCShadowView/YCShadowView.h>

@implementation SheetInfoCell

- (void)initViews{
    [super initViews];
    self.container.padding = UIEdgeInsetsMake(PADDING_OUTER, PADDING_OUTER, PADDING_LARGE, PADDING_OUTER);
    self.container.subviewSpace = PADDING_LARGE2;
    
    //水平容器
    MyLinearLayout *orientationContainer = [ViewFactoryUtil orientationContainer];
    orientationContainer.subviewSpace = PADDING_OUTER;
    orientationContainer.gravity = MyGravity_Vert_Center | MyGravity_Horz_Stretch;
    orientationContainer.padding = UIEdgeInsetsMake(0, 0, 0, PADDING_SMALL);
    [self.container addSubview:orientationContainer];

    //图标
    _iconView = [UIImageView new];
    _iconView.myWidth = 120;
    _iconView.myHeight = 120;
    _iconView.image = R.image.placeholder;
    [_iconView smallRadius];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    
    [orientationContainer addSubview:_iconView];
    
    //右侧容器
    MyLinearLayout *rightContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
//    rightContainer.myWidth = MyLayoutSize.fill;
    rightContainer.myHeight = MyLayoutSize.wrap;
    rightContainer.subviewSpace = PADDING_SMALL;
    [orientationContainer addSubview:rightContainer];
    
    //标题
    [rightContainer addSubview:self.titleView];
    
    //用户容器
    MyLinearLayout *userContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    userContainer.myWidth = MyLayoutSize.fill;
    userContainer.myHeight = MyLayoutSize.wrap;
    userContainer.subviewSpace = PADDING_SMALL;
    userContainer.gravity = MyGravity_Vert_Center;
    [rightContainer addSubview:userContainer];
    
    [userContainer addSubview:self.avatarView];
    [userContainer addSubview:self.nicknameView];
    
    //详情容器
    MyLinearLayout *detailContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    
    //类似paddingTop
    detailContainer.myTop = PADDING_MEDDLE;
    detailContainer.myWidth = MyLayoutSize.fill;
    detailContainer.myHeight = MyLayoutSize.wrap;
    detailContainer.subviewSpace = PADDING_SMALL;
    userContainer.gravity = MyGravity_Vert_Center | MyGravity_Horz_Stretch;
    [rightContainer addSubview:detailContainer];
    
    [detailContainer addSubview:self.detailView];
    [detailContainer addSubview:[ViewFactoryUtil moreIconView]];
    
    //快捷按钮根容器
    MyRelativeLayout *buttonRootContainer = [MyRelativeLayout new];
    buttonRootContainer.myHorzMargin = 30;
    buttonRootContainer.myWidth = MyLayoutSize.fill;
    buttonRootContainer.myHeight = 46;
    [self.container addSubview:buttonRootContainer];
    
    //背景
    YCShadowView *backgroundView = [YCShadowView new];
    backgroundView.myWidth = MyLayoutSize.fill;
    backgroundView.myHeight = 46;
    backgroundView.backgroundColor = [UIColor secondButtonLight];

    //阴影
    [backgroundView yc_shaodw];

    //圆角
    [backgroundView yc_cornerRadius:25];

    [buttonRootContainer addSubview:backgroundView];
    
    //快捷按钮容器
    MyLinearLayout *buttonContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
    buttonContainer.myWidth = MyLayoutSize.fill;
    buttonContainer.myHeight = MyLayoutSize.wrap;
    buttonContainer.gravity = MyGravity_Horz_Stretch;
    buttonContainer.layer.cornerRadius = 23;
    [buttonRootContainer addSubview:buttonContainer];
    
    [buttonContainer addSubview:self.collectCountView];
    [buttonContainer addSubview:[ViewFactoryUtil smallVerticalDivider]];
    [buttonContainer addSubview:self.commentCountView];
    [buttonContainer addSubview:[ViewFactoryUtil smallVerticalDivider]];
    [buttonContainer addSubview:self.shareCountView];
}

-(void)bind:(Sheet *)data{
    [ImageUtil show:_iconView uri:data.icon];
    _titleView.text = data.title;
    
    //用户信息
    [ImageUtil showAvatar:_avatarView uri:data.user.icon];
    _nicknameView.text = data.user.nickname;
    
    _detailView.text = data.detail;
    
    //收藏数
    [self.collectCountView setTitle:[NSString stringWithFormat:@"%d",data.collectsCount] forState:UIControlStateNormal];
    
    //评论数
    [self.commentCountView setTitle:[NSString stringWithFormat:@"%d",data.commentsCount] forState:UIControlStateNormal];
    
    //分享数
    [self.shareCountView setTitle:[NSString stringWithFormat:@"%d",data.commentsCount] forState:UIControlStateNormal];
}

- (MyOrientation)getContainerOrientation{
    return MyOrientation_Vert;
}

/// 评论数按钮点击
/// @param sender sender description
-(void)onCommentClick:(UIButton *)sender{
//    ClickEvent *event = [[ClickEvent alloc] init];
//    event.style = StyleComment;
//    [QTEventBus.shared dispatch:event];
}

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel new];
        _titleView.myWidth = MyLayoutSize.fill;
        _titleView.myHeight = MyLayoutSize.wrap;
        _titleView.numberOfLines = 2;
        _titleView.text = @"歌单标题歌单标题歌单标题歌单标题歌单标题歌单标题歌单标题";
        _titleView.font = [UIFont systemFontOfSize:TEXT_LARGE2];
        _titleView.textColor = [UIColor colorLightWhite];
    }
    return _titleView;
}

- (UIImageView *)avatarView{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.myWidth = 30;
        _avatarView.myHeight=30;
        _avatarView.image = R.image.defaultAvatar;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [_avatarView smallRadius];
    }
    return _avatarView;
}

- (UILabel *)nicknameView{
    if (!_nicknameView) {
        _nicknameView = [UILabel new];
        _nicknameView.myWidth = MyLayoutSize.wrap;
        _nicknameView.myHeight = MyLayoutSize.wrap;
        _nicknameView.numberOfLines = 1;
        _nicknameView.text = @"昵称";
        _nicknameView.font = [UIFont systemFontOfSize:TEXT_MEDDLE];
        _nicknameView.textColor = [UIColor colorLightWhite];
    }
    return _nicknameView;
}

- (UILabel *)detailView{
    if (!_detailView) {
        _detailView = [UILabel new];
        _detailView.myWidth = 160;
        _detailView.myHeight = MyLayoutSize.wrap;
        _detailView.numberOfLines = 1;
        _detailView.text = @"介绍";
        _detailView.font = [UIFont systemFontOfSize:TEXT_MEDDLE];
        _detailView.textColor = [UIColor colorLightWhite];
    }
    return _detailView;
}

- (QMUIButton *)collectCountView{
    if (!_collectCountView) {
        _collectCountView = [ViewFactoryUtil secoundButtonWithImage:[R.image.stars withTintColor] title:@"0"];
    }
    return _collectCountView;
}

- (QMUIButton *)commentCountView{
    if (!_commentCountView) {
        _commentCountView = [ViewFactoryUtil secoundButtonWithImage:[R.image.comments withTintColor] title:@"0"];
        [_commentCountView addTarget:self action:@selector(onCommentClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentCountView;
}

- (QMUIButton *)shareCountView{
    if (!_shareCountView) {
        _shareCountView = [ViewFactoryUtil secoundButtonWithImage:[R.image.search withTintColor] title:@"0"];
    }
    return _shareCountView;
}


@end
