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

+ (QMUIButton *)primaryHalfFilletOutlineButton;

+(QMUIButton *)title:(NSString *)title color:(UIColor *)color;

+(QMUIButton *)buttonWithImage:(UIImage *)image title:(NSString *)title;

/// 创建图片按钮
+(QMUIButton *)buttonWithImage:(UIImage *)data;

+(QMUIButton *)buttonWithImage:(UIImage *)data selectedImage:(UIImage *)selectedImage;

+(UITableView *)tableView;

+(UICollectionView *)collectionView;
//水平collectionView
+(UICollectionView *)pageCollectionView;
+(UICollectionViewFlowLayout *)pageCollectionViewFlowLayout;
+(UICollectionViewFlowLayout *)collectionViewFlowLayout;
+(UIView *)smallDivider;

+(UIImageView *)moreIconView;

+(QMUIButton *)secoundButtonWithImage:(UIImage *)image title:(NSString *)title;

//小垂直分割线
+(UIView *)smallVerticalDivider;

+(MyLinearLayout *)orientationContainer;
@end

NS_ASSUME_NONNULL_END
