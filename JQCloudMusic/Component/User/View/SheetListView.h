//
//  SheetListView.h
//  JQCloudMusic
//  我的界面，歌单列表 view
//  Created by zhangjq on 2024/11/20.
//

#import <MyLayout/MyLayout.h>

NS_ASSUME_NONNULL_BEGIN

@interface SheetListView : MyLinearLayout <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSString *userId;

/// 是否显示顶部按钮
@property (nonatomic, assign) BOOL showButton;

/// 代理对象
//@property (nonatomic, weak, nullable) id <SheetListViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *datum;

/// TableView
@property (nonatomic, strong) UITableView *tableView;

-(void)loadData;
@end

NS_ASSUME_NONNULL_END
