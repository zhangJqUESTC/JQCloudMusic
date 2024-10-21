//
//  BaseLogicController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/12.
//

#import "BaseLogicController.h"

@interface BaseLogicController ()

@end

@implementation BaseLogicController


- (void)initViews{
    [super initViews];
    //隐藏系统导航栏
    [self.navigationController.navigationBar setHidden:YES];
    
    //默认颜色，如果某些界面不一样，在单独设置
    [self setBackgroundColor:[UIColor colorBackground]];
}

/// 初始化垂直方向LinearLayout容器
- (void)initLinearLayout{
    _rootContainer = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _rootContainer.myWidth = MyLayoutSize.fill;
    _rootContainer.myHeight = MyLayoutSize.fill;
    _rootContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rootContainer];
}

/// 初始化RelativeLayout容器，四边都在安全区内
- (void)initRelativeLayoutSafeArea{
    [self initLinearLayout];
    
    //header
    [self initHeaderContainer];
    
    _container = [MyRelativeLayout new];
    _container.myWidth = MyLayoutSize.fill;
    _container.myHeight = MyLayoutSize.wrap;
    _container.weight=1;
    _container.backgroundColor = [UIColor clearColor];
    [_rootContainer addSubview:_container];
    
    [self initFooterContainer];
}

/// 初始化垂直方向LinearLayout容器，四边都在安全区内
- (void)initLinearLayoutSafeArea{
    [self initLinearLayout];
    
    //header
    [self initHeaderContainer];
    
    //frame
    self.frameContainer=[MyRelativeLayout new];
    self.frameContainer.myWidth = MyLayoutSize.fill;
    self.frameContainer.myHeight = MyLayoutSize.wrap;
    self.frameContainer.weight=1;
    self.frameContainer.backgroundColor = [UIColor clearColor];
    [_rootContainer addSubview:self.frameContainer];
    
    _container = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _container.myWidth = MyLayoutSize.fill;
    _container.myHeight = MyLayoutSize.fill;
    _container.gravity = MyGravity_Vert_Stretch;
    _container.backgroundColor = [UIColor clearColor];
    [self.frameContainer addSubview:_container];
    
    //footer，一般是底部要显示按钮，例如：购物车界面，商城相关界面
    //当然也可以细分到需要的界面才添加，但这样会增加复杂度
    [self initFooterContainer];
}

//- (void)initLinearLayoutInputSafeArea{
//    [self initLinearLayoutSafeArea];
//    
//    self.container.padding = UIEdgeInsetsMake(PADDING_LARGE, PADDING_OUTER, 0, PADDING_OUTER);
//    self.container.subviewSpace = PADDING_LARGE;
//}

/// 初始化TableView，四边都在安全区内
- (void)initTableViewSafeArea{
    //外面添加一层容器，是方便在真实内容控件前后添加内容
    [self initLinearLayoutSafeArea];

    //tableView
    [self createTableView];

    [self.container addSubview:self.tableView];
}

/// 设置状态栏为亮色(文字是白色)
-(void)setStatusBarLight{
}

/// 创建TableView，不会添加到任何布局
-(void)createTableView{
    self.datum = [NSMutableArray array];

    self.tableView = [ViewFactoryUtil tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.weight=1;
}

/// 使用默认分割线
- (void)initDefaultTableViewDivider{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)initPlaceholderView{
    _placeholderView = [PlaceholderView new];

    //默认隐藏
    _placeholderView.visibility = MyVisibility_Gone;

    [_rootContainer addSubview:self.placeholderView];

    //添加点击事件

    UITapGestureRecognizer *placeholderViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlaceholderViewTapGestureRecognizer:)];

    //设置成false表示当前控件响应后会传播到其他控件上
    //如果不设置为false，界面里面的列表控件可能无法响应点击事件
    placeholderViewTapGestureRecognizer.cancelsTouchesInView = NO;

    [_placeholderView addGestureRecognizer:placeholderViewTapGestureRecognizer];
}

/// 头部容器，安全区外，一般用来设置头部到安全区外背景颜色
-(void)initHeaderContainer{
    self.superHeaderContainer=[[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.superHeaderContainer.myWidth = MyLayoutSize.fill;
    self.superHeaderContainer.myHeight = MyLayoutSize.wrap;
    self.superHeaderContainer.backgroundColor = [UIColor clearColor];
    
    //头部内容容器，安全区内
    self.superHeaderContentContainer=[[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.superHeaderContentContainer.backgroundColor = [UIColor clearColor];
    self.superHeaderContentContainer.leadingPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    self.superHeaderContentContainer.trailingPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    self.superHeaderContentContainer.topPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    self.superHeaderContentContainer.myHeight = MyLayoutSize.wrap;
    
    [self.superHeaderContainer addSubview:self.superHeaderContentContainer];
    [self.rootContainer addSubview:self.superHeaderContainer];
}

-(void)initFooterContainer{
    self.superFooterContainer=[[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.superFooterContainer.myWidth = MyLayoutSize.fill;
    self.superFooterContainer.myHeight = MyLayoutSize.wrap;
    self.superFooterContainer.backgroundColor = [UIColor clearColor];
    
    //底部内容容器，安全区内
    self.superFooterContentContainer=[[MyLinearLayout alloc] initWithOrientation:MyOrientation_Vert];
    self.superFooterContentContainer.backgroundColor = [UIColor clearColor];
    self.superFooterContentContainer.leadingPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    self.superFooterContentContainer.trailingPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    self.superFooterContentContainer.bottomPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    self.superFooterContentContainer.myHeight=MyLayoutSize.wrap;
    
    [self.superFooterContainer addSubview:self.superFooterContentContainer];
    [self.rootContainer addSubview:self.superFooterContainer];
}

-(void)initScrollSafeArea{
    [self initLinearLayoutSafeArea];

    //滚动容器
    _scrollView = [UIScrollView new];
    //_scrollView.contentInset = UIEdgeInsetsMake(0, 13, 0, 13);
    [_scrollView setShowsVerticalScrollIndicator:NO];
    //[_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.myWidth = MyLayoutSize.fill;
    //_scrollView.myHeight = MyLayoutSize.fill;
    [self.container addSubview:_scrollView];

    //真实内容容器
    self.contentContainer = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.contentContainer.gravity = MyGravity_Vert_Center;
    self.contentContainer.myWidth = MyLayoutSize.fill;

    //重点：如果是垂直滚动，不要设置内容容器高度，让他自己计算
    [_scrollView addSubview:self.contentContainer];
}

/// 初始化垂直方向LinearLayout容器，只有顶部不在安全区
- (void)initLinearLayoutTopNotSafeArea{
    _rootContainer = [MyRelativeLayout new];
    _rootContainer.myWidth = MyLayoutSize.fill;
    _rootContainer.myHeight = MyLayoutSize.fill;
    _rootContainer.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_rootContainer];
    
    _container = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    _container.myWidth = MyLayoutSize.fill;
    _container.myHeight = MyLayoutSize.fill;
    _container.weight=1;
    _container.backgroundColor = [UIColor clearColor];
    _container.bottomPos.equalTo(@(MyLayoutPos.safeAreaMargin));
    [_rootContainer addSubview:_container];
    
    //header
    [self initHeaderContainer];
    
}

-(void)setHeaderLight{
    self.superHeaderContainer.backgroundColor = [UIColor colorSurface];
}

-(void)setFooterLight{
    self.superFooterContainer.backgroundColor = [UIColor colorSurface];
}

#pragma mark - 隐藏键盘
- (void)initTapHideKeyboard{
    //点击空白，关闭键盘
    UITapGestureRecognizer *rootTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onRootTouchEvent:)];

    //设置成false表示当前控件响应后会传播到其他控件上
    //如果不设置为false，界面里面的列表控件可能无法响应点击事件
    rootTapGestureRecognizer.cancelsTouchesInView = NO;

       //将触摸事件添加到当前view
    [self.view addGestureRecognizer:rootTapGestureRecognizer];
}

-(void)onRootTouchEvent:(UITapGestureRecognizer *)recognizer{
    [self hideKeyboard];
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - 界面方法

/// 关闭界面
-(void)finish{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finishToMainController:(UIViewController *)newController{
    NSArray *viewControllers = self.navigationController.viewControllers;

    NSMutableArray *newViewControllers = [NSMutableArray array];

    [newViewControllers addObject:[viewControllers objectAtIndex:0]];
    
    [newViewControllers addObject:newController];

    [self.navigationController setViewControllers:newViewControllers animated:YES];
}

/// 关闭当前界面，并显示一个新界面
/// @param newController newController description
-(void)startControllerAndFinishThis:(UIViewController *)newController{
    NSArray *vcs = self.navigationController.viewControllers;

    NSMutableArray *newVCS = [NSMutableArray array];

    if ([vcs count] > 0) {
        for (int i=0; i < [vcs count]-1; i++) {
            [newVCS addObject:[vcs objectAtIndex:i]];

        }

    }

    [newVCS addObject:newController];

    [self.navigationController setViewControllers:newVCS animated:YES];
}

#pragma mark - 列表数据源

/// 有多少个
/// @param tableView tableView description
/// @param section section description
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datum.count;
}

#pragma mark - 加载数据

/// 占位控件点击
/// @param recognizer recognizer description
-(void)onPlaceholderViewTapGestureRecognizer:(UITapGestureRecognizer *)recognizer{
    [self loadData:YES];
}

/// 加载数据方法
/// @param isPlaceholder 是否是通过placeholder控件触发的
-(void)loadData:(BOOL)isPlaceholder{
    
}

/// 加载数据方法
-(void)loadData{
    [self loadData:NO];
}

#pragma mark - 统计

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    NSString *pageId=[self pageId];
//    if (pageId) {
//        [AnalysisUtil startPage:pageId];
//    }
//}

//- (void)viewDidDisappear:(BOOL)animated{
//   [super viewDidDisappear:animated];
//    NSString *pageId=[self pageId];
//    if (pageId) {
//        [AnalysisUtil stopPage:pageId];
//    }
//}

/// 返回页面标识
- (NSString *)pageId{
    return nil;
}
- (void)initLinearLayoutInputSafeArea {
}


@end
