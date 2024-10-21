//
//  ViewFactoryUtil.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/12.
//
#import <Foundation/Foundation.h>
//提供类似Android中更高层级的布局框架
#import <QMUIKit/QMUIKit.h>
//腾讯开源的UI框架，提供了很多功能，例如：圆角按钮，空心按钮，TextView支持placeholder
#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewFactoryUtil : NSObject

+(QMUIButton *)primaryButton;
/// 主色调半圆角按钮
+(QMUIButton *)primaryHalfFilletButton;

+(QMUIButton *)linkButton;

+ (QMUIButton *)primaryOutlineButton;

+(QMUIButton *)secondHalfFilletSmallButton;

/// 创建图片按钮
+(QMUIButton *)buttonWithImage:(UIImage *)data;

+(UITableView *)tableView;

+(UICollectionView *)collectionView;
+(UICollectionViewFlowLayout *)collectionViewFlowLayout;
+(UIView *)smallDivider;
@end

NS_ASSUME_NONNULL_END
