//
//  BaseTableViewHeaderFooterView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/10.
//

#import "BaseTableViewHeaderFooterView.h"

@implementation BaseTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self innerInit];
    }
    return self;
}

- (void)innerInit{
    [self initViews];
    [self initDatum];
    [self initListeners];
}

- (void)initViews{
    //背景透明
    self.backgroundColor = [UIColor redColor];
    self.contentView.backgroundColor = [UIColor redColor];
    
    //根容器
    self.container = [[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.container.myWidth = MyLayoutSize.fill;
    self.container.myHeight = MyLayoutSize.wrap;
    [self.contentView addSubview:self.container];
}

- (void)initDatum{
    
}

- (void)initListeners{
    
}

/// 使用MyLayout后，让item自动计算高度，要重写该方法
/// @param targetSize targetSize description
/// @param horizontalFittingPriority horizontalFittingPriority description
/// @param verticalFittingPriority verticalFittingPriority description
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority{
    return [self.container systemLayoutSizeFittingSize:targetSize];
}

@end
