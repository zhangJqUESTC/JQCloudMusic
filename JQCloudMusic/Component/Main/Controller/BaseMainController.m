//
//  BaseMainController.m
//  JQCloudMusic
//  首页，几个控制器父类，主要是处理顶部导航栏
//  Created by zhangjq on 2024/10/20.
//

#import "BaseMainController.h"

@interface BaseMainController ()

@end

@implementation BaseMainController

-(void)initViews{
    [super initViews];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"标题"];
    
    //左侧按钮
    [self addLeftImageButton:[R.image.menu withTintColor]];
    //右侧按钮
    [self addRightImageButton:[R.image.mic withTintColor]];
    
    //搜索按钮
    _searchButton = [[QMUIButton alloc] init];
    _searchButton.myWidth = SCREEN_WIDTH-50*2;
    _searchButton.myHeight = 35;
    _searchButton.adjustsTitleTintColorAutomatically = YES;
    _searchButton.titleLabel.font = UIFontMake(TEXT_MEDDLE);
    _searchButton.tintColor =[UIColor black80];
    _searchButton.layer.cornerRadius = 17.5;
    [_searchButton setTitle:R.string.localizable.hintSearchValue forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor black80] forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor colorDivider];
    [_searchButton setImage:[R.image.search withTintColor] forState:UIControlStateNormal];
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.imagePadding = 5; // 相当于之前的 setImageEdgeInsets
        _searchButton.configuration = config;
    _searchButton.imagePosition = QMUIButtonImagePositionLeft;
    [_searchButton addTarget:self action:@selector(onSearchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addCenterView:_searchButton];
}

-(void)onLeftClick:(QMUIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onRightClick:(QMUIButton *)sender{
    
}

-(void)onSearchClick:(QMUIButton *)sender{
    NSLog(@"BaseMainController onSearchClick");
}

@end
