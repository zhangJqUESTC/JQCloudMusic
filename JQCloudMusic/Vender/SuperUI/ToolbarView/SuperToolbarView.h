//
//  SuperToolbarView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/20.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperToolbarView : MyRelativeLayout
/// 左侧容器
@property (nonatomic, strong) MyLinearLayout *leftContainer;

/// 中间容器
@property (nonatomic, strong) MyLinearLayout *centerContainer;

/// 右侧容器
@property (nonatomic, strong) MyLinearLayout *rightContainer;

/// 标题
@property (nonatomic, strong) UILabel *titleView;

/// 添加左侧菜单
/// - Parameter data: data description
/// - Returns: description
-(SuperToolbarView *)addLeftItem:(UIView *)data;


/// 中间容器添加控件
-(void)addCenterView:(UIView *)data;

/// 添加右侧菜单
/// - Parameter data: data description
/// - Returns: description
-(SuperToolbarView *)addRightItem:(UIView *)data;

/// 设置亮色
/// 前景是白色
-(SuperToolbarView *)setToolbarLight;
@end

NS_ASSUME_NONNULL_END
