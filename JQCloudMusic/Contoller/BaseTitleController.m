//
//  BaseTitleController.m
//  JQCloudMusic
//  通用标题控制器
//  使用普通控件实现标题栏，目的是方便使用
//  Created by zhangjq on 2024/10/20.
//

#import "BaseTitleController.h"

@interface BaseTitleController ()

@end

@implementation BaseTitleController

- (void)initLinearLayoutSafeArea{
    [super initLinearLayoutSafeArea];
    
    if ([self isAddToolBar]) {
        [self initToolbar];
    }
}

- (void)initRelativeLayoutSafeArea{
    [super initRelativeLayoutSafeArea];
    if ([self isAddToolBar]) {
        [self initToolbar];
    }
}

- (void)setTitle:(NSString *)title{
    self.toolbarView.titleView.text=title;
}

-(BOOL)isAddToolBar{
    return YES;
}

-(void)initToolbar{
    [self.superHeaderContentContainer addSubview:self.toolbarView];
    
    //添加返回按钮
    if([self.navigationController.childViewControllers count]!=1) {
        [self addLeftImageButton:[R.image.arrowLeft withTintColor]];
    }
}

-(void)addLeftImageButton:(UIImage *)data{
    self.leftButton = [ViewFactoryUtil buttonWithImage:data];
    [self.leftButton addTarget:self action:@selector(onLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addLeftItem:self.leftButton];
}

-(void)addRightImageButton:(UIImage *)data{
    self.rightButton = [ViewFactoryUtil buttonWithImage:data];
    [self.rightButton addTarget:self action:@selector(onRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolbarView addRightItem:self.rightButton];
}

-(void)addRightButton:(NSString *)data{
    self.rightButton = [ViewFactoryUtil linkButton];
    [self.rightButton setTitle:data forState: UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorOnSurface] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(onRightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton sizeToFit];
    [self.toolbarView addRightItem:self.rightButton];
}

-(void)setToolbarLight{
    [self.toolbarView setToolbarLight];
}

-(void)onLeftClick:(QMUIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onRightClick:(QMUIButton *)sender{
    
}


#pragma mark - 创建控件
- (SuperToolbarView *)toolbarView{
    if (!_toolbarView) {
        _toolbarView = [SuperToolbarView new];
        
    }
    return _toolbarView;
}

@end
