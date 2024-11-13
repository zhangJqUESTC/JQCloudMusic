//
//  SuperHorizontalProgressView.h
//  JQCloudMusic
//  水平进度条，不能拖拽，只显示进度
//  Created by zhangjq on 2024/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperHorizontalProgressView : UISlider
@property(nonatomic) float progress;

@property(nonatomic) UIColor *progressTintColor;
@end

NS_ASSUME_NONNULL_END
