//
//  SheetDetailController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/7.
//

#import "SheetDetailController.h"
#import "SheetInfoCell.h"
#import "SongGroupHeaderView.h"
#import "Sheet.h"
#import "SongCell.h"

@interface SheetDetailController ()
@property(nonatomic, strong) Sheet *data;

//背景
@property(nonatomic, strong) UIImageView *backgroundImageView;

//背景模糊
@property(nonatomic, strong) UIVisualEffectView *backgroundVisual;
@end

@implementation SheetDetailController

- (void)initViews{
    [super initViews];
    //添加背景图片控件
    _backgroundImageView = [UIImageView new];

    //默认隐藏
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.alpha = 0;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];

    //背景模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _backgroundVisual = [[UIVisualEffectView alloc] initWithEffect:blur];
    [_backgroundImageView addSubview:_backgroundVisual];
    //初始化TableView结构
    [self initTableViewSafeArea];
    //设置状态栏为亮色(文字是白色)
    [self setStatusBarLight];
    
    [self setToolbarLight];
    
    [self setBackgroundColor:[UIColor colorBackgroundLight]];
    [self.superFooterContainer setBackgroundColor:[UIColor colorBackgroundLight]];
    
    [self setTitle:R.string.localizable.sheet];
    
    //注册歌单信息
    [self.tableView registerClass:[SheetInfoCell class] forCellReuseIdentifier:SheetInfoCellName];
    
    //注册歌单信息
    [self.tableView registerClass:[SongGroupHeaderView class] forHeaderFooterViewReuseIdentifier:SongGroupHeaderViewName];
    
    //注册单曲
    [self.tableView registerClass:[SongCell class] forCellReuseIdentifier:SongCellName];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _backgroundImageView.frame = self.view.bounds;
    _backgroundVisual.frame = _backgroundImageView.bounds;
}

- (void)initDatum{
    [super initDatum];
    
    [self loadData];
}

-(void)loadData:(BOOL)isPlaceholder{
    [[DefaultRepository shared] sheetDetailWithId:_id success:^(BaseResponse * _Nonnull baseResponse, id  _Nonnull data) {
        [self show:data];
    }];
}

- (void)show:(Sheet *)data{
    self.data = data;
    
    [ImageUtil show:self.backgroundImageView uri:data.icon];

    //使用动画显示背景图片
    [UIView animateWithDuration:0.3 animations:^{
        //透明度设置为1
        self.backgroundImageView.alpha=1;
    }];
    
    [self.datum removeAllObjects];
    
    //第一组
    SongGroupData *groupData=[SongGroupData new];
    NSMutableArray *tempArray = [NSMutableArray new];
    [tempArray addObject:data];
    groupData.datum=tempArray;
    [self.datum addObject:groupData];
    
    if (data.songs) {
        //有音乐才设置

        //设置数据
        groupData=[SongGroupData new];
        NSMutableArray *tempArray = [NSMutableArray new];
        [tempArray addObjectsFromArray:data.songs];
        [tempArray addObjectsFromArray:data.songs];
        groupData.datum=tempArray;
        [self.datum addObject:groupData];
    }
    

    [self.tableView reloadData];
}

/// Cell类型
- (ListStyle)typeForItemAtData:(NSObject *)data{
        
    if([data isKindOfClass:[Sheet class]]){
        //歌单信息
        return StyleSheet;
    }
    
    return StyleSong;
}

/// 返回section view
/// @param tableView tableView description
/// @param section section description
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    __weak __typeof(self)weakSelf = self;
    
    //取出组数据
    SongGroupData *groupData=self.datum[section];
    
    //获取header
    SongGroupHeaderView *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:   SongGroupHeaderViewName];
    
    [header setPlayAllClickBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        if (strongSelf.datum.count>0) {
            return;
        }
        
        SongGroupData *groupData=strongSelf.datum[1];
        Song *data= groupData.datum[0];
        
        [strongSelf play:data];
    }];

    //绑定数据
    [header bind:groupData];

    //返回header
    return header;
}

/// 返回当前位置的cell
/// 相当于Android中RecyclerView Adapter的onCreateViewHolder
/// @param tableView tableView description
/// @param indexPath indexPath description
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SongGroupData *groupData=self.datum[indexPath.section];
    NSObject *data= groupData.datum[indexPath.row];

    //获取类型
    ListStyle style=[self typeForItemAtData:data];

    switch (style) {
        case StyleSheet:{
            SheetInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SheetInfoCellName forIndexPath:indexPath];

            [cell bind:data];

            return cell;
        }
        default:{
            SongCell *cell = [tableView dequeueReusableCellWithIdentifier:SongCellName forIndexPath:indexPath];

            //显示位置
            cell.indexView.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];

            [cell bind:data];

            return cell;
        }
    }

}

/// 播放音乐
/// @param data data description
-(void)play:(Song *)data{
    //把当前歌单所有音乐设置到播放列表
    //有些应用
    //可能会实现添加到已经播放列表功能
    [[MusicListManager shared] setDatum:self.data.songs];

    //播放当前音乐
    [[MusicListManager shared] play:data];
//    
    [self startMusicPlayerController];
}

/// 有多少组
/// @param tableView tableView description
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.datum.count;
}

/// 当前组有多少个
/// @param tableView tableView description
/// @param section section description
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    SongGroupData *groupData=self.datum[section];
    return groupData.datum.count;
}

/// header高度
/// @param tableView tableView description
/// @param section section description
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 50;
    }
    
    //其他组不显示section
    return 0;
}

/// cell点击
/// @param tableView tableView description
/// @param indexPath indexPath description
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SongGroupData *groupData=self.datum[indexPath.section];
    NSObject *data= groupData.datum[indexPath.row];
    
    //获取类型
    ListStyle style=[self typeForItemAtData:data];
    if (style==StyleSong) {
        [self play:data];
    }
}

+ (void)start:(UINavigationController *)controller id:(NSString *)id{
    SheetDetailController *newController = [SheetDetailController new];
    
    newController.id=id;
    
    [controller pushViewController:newController animated:YES];
}

@end
