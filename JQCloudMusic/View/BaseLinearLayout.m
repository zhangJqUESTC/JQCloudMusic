//
//  BaseLinearLayout.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "BaseLinearLayout.h"

@implementation BaseLinearLayout

- (instancetype)init{
    self=[super initWithOrientation:MyOrientation_Vert];
    if (self) {
        [self initViews];
        [self initDatum];
        [self initListeners];
    }
    return self;
}

- (void)initViews{
}

- (void)initDatum{
}

- (void)initListeners{
}

@end
