//
//  SuperHorizontalProgressView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "SuperHorizontalProgressView.h"

@implementation SuperHorizontalProgressView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.thumbTintColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return NO;
}

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, SCREEN_WIDTH, 1);
}

@end
