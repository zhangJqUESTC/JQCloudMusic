//
//  DiscoveryFooterCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/20.
//

#import "DiscoveryFooterCell.h"
#import "ClickEvent.h"

@implementation DiscoveryFooterCell

- (void)initViews{
    [super initViews];
    
    self.container.gravity = MyGravity_Horz_Center;
    
    //内边距
    self.container.padding = UIEdgeInsetsMake(PADDING_OUTER, 0, PADDING_OUTER, 0);
    
    self.container.subviewSpace = PADDING_OUTER;
    
    [self.container addSubview:self.orientationContainer];
    
    [self.orientationContainer addSubview:self.refreshView];
    
    //提示文本
    UILabel *infoView = [UILabel new];
    infoView.myWidth = MyLayoutSize.wrap;
    infoView.myHeight = MyLayoutSize.wrap;
    infoView.font = [UIFont systemFontOfSize:12];
    infoView.text = R.string.localizable.changeContent;
    infoView.textColor = [UIColor black80];
    [self.orientationContainer addSubview:infoView];
    
    [self.container addSubview:self.customView];
}

-(void)refreshClick{
    ClickEvent *event = [[ClickEvent alloc] init];
    event.style = StyleRerfresh;
    [QTEventBus.shared dispatch:event];
}

- (MyOrientation)getContainerOrientation{
    return MyOrientation_Vert;
}

- (QMUIButton *)refreshView{
    if (!_refreshView) {
        _refreshView = [ViewFactoryUtil linkButton];
        [_refreshView setTitle:R.string.localizable.clickRefresh forState: UIControlStateNormal];
        
        // 将图片位置改为在文字左侧
        _refreshView.imagePosition = QMUIButtonImagePositionLeft;
        
        //设置图片
        [_refreshView setImage:[R.image.refresh withTintColor] forState:UIControlStateNormal];
        
        _refreshView.tintColor = [UIColor link];
        
        [_refreshView setTitleColor:[UIColor link] forState:UIControlStateNormal];
        
        //点击事件
        [_refreshView addTarget:self action:@selector(refreshClick) forControlEvents:UIControlEventTouchUpInside];
        
        _refreshView.titleLabel.font = UIFontMake(TEXT_SMALL);
        
        [_refreshView sizeToFit];
    }
    return _refreshView;
}

- (QMUIButton *)customView{
    if (!_customView) {
        _customView = [ViewFactoryUtil secondHalfFilletSmallButton];
        [_customView setTitle:R.string.localizable.customDiscovery forState: UIControlStateNormal];
    }
    return _customView;
}

- (MyLinearLayout *)orientationContainer{
    if (!_orientationContainer) {
        _orientationContainer = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
        _orientationContainer.myWidth = MyLayoutSize.wrap;
        _orientationContainer.myHeight = MyLayoutSize.wrap;
        _orientationContainer.subviewSpace = PADDING_MEDDLE;
        _orientationContainer.gravity = MyGravity_Vert_Center;
    }
    return _orientationContainer;
}

@end
