//
//  SongGroupHeaderView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "SongGroupHeaderView.h"

@implementation SongGroupHeaderView

- (void)initViews{
    [super initViews];
    
    self.backgroundColor = [UIColor colorBackgroundLight];
    self.contentView.backgroundColor = [UIColor colorBackgroundLight];
    
    //容器
    MyRelativeLayout *orientationContainer = [MyRelativeLayout new];
    orientationContainer.myWidth = MyLayoutSize.fill;
    orientationContainer.myHeight = MyLayoutSize.wrap;
    orientationContainer.padding = UIEdgeInsetsMake(0, 0, 0, PADDING_SMALL);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayAllTouchEvent:)];

       //将触摸事件添加到当前view
    [orientationContainer addGestureRecognizer:tapGestureRecognizer];
    
    [self.container addSubview:orientationContainer];
    
    //左侧容器
    MyRelativeLayout *leftContainer = [MyRelativeLayout new];
    leftContainer.myWidth = 50;
    leftContainer.myHeight = 50;
    [orientationContainer addSubview:leftContainer];
    
    //图标
    UIImageView *iconView = [UIImageView new];
    iconView.myWidth = 30;
    iconView.myHeight=30;
    iconView.myCenter = CGPointMake(0, 0);
    iconView.image = [R.image.playCircle withTintColor];
    iconView.tintColor = [UIColor colorPrimary];
    
    [leftContainer addSubview:iconView];
    
    //播放全部提示文本
    UILabel *titleView = [UILabel new];
    titleView.myWidth = MyLayoutSize.wrap;
    titleView.myHeight = MyLayoutSize.wrap;
    titleView.text = R.string.localizable.playAll;
    titleView.font = [UIFont boldSystemFontOfSize:TEXT_LARGE2];
    titleView.textColor = [UIColor colorOnSurface];
    titleView.myCenterY = 0;
    titleView.leftPos.equalTo(leftContainer.rightPos);
    [orientationContainer addSubview:titleView];
    
    //数量
    _countView = [UILabel new];
    _countView.myWidth = MyLayoutSize.wrap;
    _countView.myHeight = MyLayoutSize.wrap;
    _countView.text = @"0";
    _countView.textAlignment = NSTextAlignmentLeft;
    _countView.font = [UIFont systemFontOfSize:TEXT_MEDDLE];
    _countView.textColor = [UIColor black80];
    _countView.myCenterY = 0;
    _countView.leftPos.equalTo(titleView.rightPos).offset(5);
    [orientationContainer addSubview:_countView];
    
    //下载按钮
    QMUIButton *downloadButton = [ViewFactoryUtil buttonWithImage:[R.image.arrowCircleDown withTintColor]];
    downloadButton.tintColor = [UIColor colorOnSurface];
    downloadButton.myWidth = 50;
    downloadButton.myHeight = 50;
    downloadButton.myCenterY = 0;
    [orientationContainer addSubview:downloadButton];
    
    //多选按钮
    QMUIButton *multiSelectButton = [ViewFactoryUtil buttonWithImage:[R.image.moreVerticalDot withTintColor]];
    multiSelectButton.tintColor = [UIColor colorOnSurface];
    multiSelectButton.myWidth = 50;
    multiSelectButton.myHeight = 50;
    multiSelectButton.myCenterY = 0;
    multiSelectButton.myRight=0;
    [orientationContainer addSubview:multiSelectButton];
    
    downloadButton.rightPos.equalTo(multiSelectButton.leftPos).offset(5);
}

-(void)onPlayAllTouchEvent:(UITapGestureRecognizer *)recognizer{
    if (self.playAllClickBlock) {
        self.playAllClickBlock();
    }
}

- (void)bind:(SongGroupData *)data{
    _countView.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)data.datum.count];
}


@end
