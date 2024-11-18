//
//  PlayListView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "PlayListView.h"
#import "MusicListManager.h"
#import <GKCover/GKCover.h>
#import "PlayListCell.h"

@implementation PlayListView

- (void)initViews{
    [super initViews];
    self.backgroundColor = [UIColor colorSurface];
    
    //容器
    MyRelativeLayout *orientationContainer = [MyRelativeLayout new];
    orientationContainer.myWidth = MyLayoutSize.fill;
    orientationContainer.myHeight = MyLayoutSize.wrap;
    orientationContainer.padding = UIEdgeInsetsMake(0, 0, 0, PADDING_SMALL);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPlayAllTouchEvent:)];

       //将触摸事件添加到当前view
    [orientationContainer addGestureRecognizer:tapGestureRecognizer];
    
    [self addSubview:orientationContainer];
    
    //左侧容器
    MyRelativeLayout *leftContainer = [MyRelativeLayout new];
    leftContainer.myWidth = 50;
    leftContainer.myHeight = 50;
    [orientationContainer addSubview:leftContainer];
    
    //图标
    UIImageView *iconView = [UIImageView new];
    iconView.myWidth = 30;
    iconView.myHeight=30;
    iconView.myCenter = CGPointMake(0, 0);
    iconView.image = [R.image.playCircle withTintColor];
    iconView.tintColor = [UIColor colorPrimary];
    
    [leftContainer addSubview:iconView];
    
    //播放全部提示文本
    UILabel *titleView = [UILabel new];
    titleView.myWidth = MyLayoutSize.wrap;
    titleView.myHeight = MyLayoutSize.wrap;
    titleView.text = R.string.localizable.playAll;
    titleView.font = [UIFont boldSystemFontOfSize:TEXT_LARGE2];
    titleView.textColor = [UIColor colorOnSurface];
    titleView.myCenterY = 0;
    titleView.leftPos.equalTo(leftContainer.rightPos);
    [orientationContainer addSubview:titleView];
    
    //数量
    _countView = [UILabel new];
    _countView.myWidth = MyLayoutSize.wrap;
    _countView.myHeight = MyLayoutSize.wrap;
    _countView.text = @"0";
    _countView.textAlignment = NSTextAlignmentLeft;
    _countView.font = [UIFont systemFontOfSize:TEXT_MEDDLE];
    _countView.textColor = [UIColor black80];
    _countView.myCenterY = 0;
    _countView.leftPos.equalTo(titleView.rightPos).offset(5);
    [orientationContainer addSubview:_countView];
    
    //删除所有按钮
    QMUIButton *deleteButton = [ViewFactoryUtil buttonWithImage:[R.image.close withTintColor]];
    deleteButton.tintColor = [UIColor colorOnSurface];
    deleteButton.myWidth = 50;
    deleteButton.myHeight = 50;
    deleteButton.myCenterY = 0;
    deleteButton.myRight = 0;
    [deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [orientationContainer addSubview:deleteButton];
    
    [self addSubview:[ViewFactoryUtil smallDivider]];
    
    //tableView
    [self createTableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.tableView registerClass:[PlayListCell class] forCellReuseIdentifier:Cell];
        
    [self addSubview:self.tableView];
}

/// 创建TableView，不会添加到任何布局
-(void)createTableView{
    self.tableView = [ViewFactoryUtil tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.weight=1;
}

/// 删除点击
/// @param sender sender description
- (void)deleteClick:(QMUIButton *)sender{
    [[MusicListManager shared] deleteAll];
    
    [GKCover hideCover];
}

-(void)onPlayAllTouchEvent:(UITapGestureRecognizer *)recognizer{
    [self play:0];
    
    [GKCover hideCover];
}

- (void)play:(NSInteger)index{
    Song *data=[[MusicListManager shared] getDatum][index];
    
    [[MusicListManager shared] play:data];
}

- (void)initDatum{
    [super initDatum];
    
    _countView.text = [NSString stringWithFormat:@"(%lu)",(unsigned long)[[MusicListManager shared] getDatum].count];
    
    //选中当前音乐
    [self scrollPosition];
}

/// 选中当前播放的音乐
-(void)scrollPosition{
    //获取当前音乐在播放列表中的索引
    Song *data = [[MusicListManager shared] getData];
    
    NSUInteger index = [[[MusicListManager shared] getDatum] indexOfObject:data];
    
    if (index != -1) {
        //创建indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        //延迟后选中当前音乐
        //因为前面执行可能是删除Cell操作
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //选中
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
         });
    }
}

#pragma mark - 列表数据源

/// 有多少个
/// @param tableView tableView description
/// @param section section description
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[MusicListManager shared] getDatum].count;
}

/// 返回当前位置的cell
/// 相当于Android中RecyclerView Adapter的onCreateViewHolder
/// @param tableView tableView description
/// @param indexPath indexPath description
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Song *data= [[MusicListManager shared] getDatum][indexPath.row];
    
    PlayListCell *cell=[tableView dequeueReusableCellWithIdentifier:Cell forIndexPath:indexPath];
    
    [cell bind:data];
    
    [cell setDeleteBlock:^{
        [[MusicListManager shared] delete:indexPath.row];
        
        [GKCover hideCover];
    }];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self play:indexPath.row];
}

@end
