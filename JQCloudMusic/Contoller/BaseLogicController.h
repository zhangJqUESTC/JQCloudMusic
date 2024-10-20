//
//  BaseLogicController.h
//  JQCloudMusic
//  项目中通用的逻辑控制器
//  Created by zhangjq on 2024/10/12.
//


//提供类似Android中更高层级的布局框架
#import <MyLayout/MyLayout.h>
#import "BaseCommonController.h"
#import "PlaceholderView.h"
//#import "PlaceholderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseLogicController : BaseCommonController<UITableViewDataSource,UITableViewDelegate>
/// TableView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datum;

/// 根容器
@property (nonatomic, strong) MyBaseLayout *rootContainer;

/// 容器
@property (nonatomic, strong) MyBaseLayout *container;

/// frame容器，一般用来添加占位布局
@property (nonatomic, strong) MyBaseLayout *frameContainer;

/// 头部容器
@property (nonatomic, strong) MyBaseLayout *superHeaderContainer;
@property (nonatomic, strong) MyBaseLayout *superHeaderContentContainer;

/// 底部容器
@property (nonatomic, strong) MyBaseLayout *superFooterContainer;
@property (nonatomic, strong) MyBaseLayout *superFooterContentContainer;

/// 占位控件
@property(nonatomic,strong) PlaceholderView *placeholderView;

/// 内容容器，一般只有初始化ScrollView后，才有效
@property (nonatomic, strong) MyLinearLayout *contentContainer;

/// 滚动容器
@property (nonatomic, strong) UIScrollView *scrollView;

/// 初始化垂直方向LinearLayout容器
- (void)initLinearLayout;

/// 初始化RelativeLayout容器，四边都在安全区内
- (void)initRelativeLayoutSafeArea;

/// 初始化垂直方向LinearLayout容器，四边都在安全区内
- (void)initLinearLayoutSafeArea;

/// 在initLinearLayoutSafeArea基础上，设置padding，子控件间距
- (void)initLinearLayoutInputSafeArea;

/// 初始化TableView，四边都在安全区内
- (void)initTableViewSafeArea;

/// 使用默认分割线
- (void)initDefaultTableViewDivider;

/// 初始化占位控件
- (void)initPlaceholderView;

/// 初始化ScrollView容器，四边都在安全区内
- (void)initScrollSafeArea;

/// 设置状态栏为亮色(文字是白色)
-(void)setStatusBarLight;

/// 初始化垂直方向LinearLayout容器，只有顶部不在安全区
- (void)initLinearLayoutTopNotSafeArea;

/// 创建TableView，不会添加到任何布局
-(void)createTableView;

/// 标题容器设置为亮色，也是就是白天是白色
-(void)setHeaderLight;

/// 底部容器设置为亮色，也是就是白天是白色
-(void)setFooterLight;

#pragma mark - 隐藏键盘

/// 点击空白隐藏键盘
- (void)initTapHideKeyboard;

/// 隐藏键盘
-(void)hideKeyboard;

#pragma mark - 加载数据

/// 加载数据方法
/// @param isPlaceholder 是否是通过placeholder控件触发的
-(void)loadData:(BOOL)isPlaceholder;

/// 加载数据方法
-(void)loadData;

#pragma mark - 界面方法

/// 关闭界面
-(void)finish;

/// 将主界面后面的界面全部关闭，不关闭主界面，并显示一个界面
/// @param newController newController description
-(void)finishToMainController:(UIViewController *)newController;

/// 关闭当前界面，并显示一个新界面
/// @param newController newController description
-(void)startControllerAndFinishThis:(UIViewController *)newController;

#pragma mark - 统计

/// 返回页面标识
- (NSString *)pageId;
@end

NS_ASSUME_NONNULL_END
