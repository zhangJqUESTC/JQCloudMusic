//
//  PlayListCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "PlayListCell.h"

@implementation PlayListCell

- (void)initViews{
    [super initViews];
    self.container.padding=UIEdgeInsetsMake(0, PADDING_OUTER, 0, PADDING_OUTER);
    self.container.subviewSpace = PADDING_MEDDLE;
    
    [self.container addSubview:self.titleView];
    
    self.deleteView = [ViewFactoryUtil buttonWithImage:[R.image.close withTintColor]];
    self.deleteView.tintColor = [UIColor black80];
    self.deleteView.myWidth = 50;
    self.deleteView.myHeight = 50;
    [self.deleteView addTarget:self action:@selector(_deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:self.deleteView];
}

- (void)bind:(Song *)data{
    self.titleView.text = data.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.titleView.textColor = [UIColor colorPrimary];
    } else {
        self.titleView.textColor = [UIColor colorOnSurface];
    }
}

#pragma mark - 事件
-(void)_deleteClick:(UIButton *)sender{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

#pragma mark - 创建控件

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [UILabel new];
        _titleView.myWidth = MyLayoutSize.fill;
        _titleView.myHeight = MyLayoutSize.wrap;
        _titleView.numberOfLines = 2;
        _titleView.text = @"测试";
        _titleView.font = [UIFont systemFontOfSize:TEXT_LARGE];
        _titleView.textColor = [UIColor colorOnSurface];
        _titleView.weight=1;
    }
    return _titleView;
}

@end
