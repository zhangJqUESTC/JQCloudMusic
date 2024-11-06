//
//  BaseRelativeLayout.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/31.
//

#import "BaseRelativeLayout.h"

@implementation BaseRelativeLayout


- (instancetype)init{
    self=[super init];
    if (self) {
        [self innerInit];
    }
    
    return self;
}

-(void)innerInit{
    [self initViews];
    [self initDatum];
    [self initListeners];
}

/// 找控件
- (void)initViews{
    
}


/// 设置数据
- (void)initDatum{
    
}

/// 设置监听器
- (void)initListeners{
    
}
@end
