//
//  MeController.m
//  JQCloudMusic
//  我的界面
//  Created by zhangjq on 2024/10/16.
//

#import "MeController.h"
#import "SheetListView.h"

@interface MeController ()
@property(nonatomic, strong) SheetListView *listView;

//@property(nonatomic, strong) SuperDialogController *createSheetController;
@end

@implementation MeController

-(void)initViews{
    [super initViews];
    [self initLinearLayoutSafeArea];
    _listView=[SheetListView new];
//   _listView.showButton=YES;
//   _listView.delegate=self;
   _listView.userId = [PreferenceUtil getUserId];
   [self.container addSubview:_listView];
}

- (void)initListeners{
    [super initListeners];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

/// 视图即将可见方法
/// @param animated animated description
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_listView loadData];
}

-(void)onEnterForeground:(NSNotification*)data{
    [_listView loadData];
}
@end
