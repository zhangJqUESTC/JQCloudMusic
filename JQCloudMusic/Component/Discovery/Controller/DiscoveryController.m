//
//  DiscoveryController.m
//  JQCloudMusic
//  发现界面
//  Created by zhangjq on 2024/10/16.
//

#import "DiscoveryController.h"
#import "BannerData.h"
#import "BannerCell.h"
#import "BannerClickEvent.h"
#import "DiscoveryButtonCell.h"
#import "ButtonData.h"
#import "SheetData.h"
#import "SheetGroupCell.h"
#import "SongData.h"
#import "SongGroupCell.h"
#import "DiscoveryFooterCell.h"
#import "FooterData.h"
#import "ClickEvent.h"
#import "SuperWebController.h"
//下拉刷新
#import <MJRefresh/MJRefresh.h>
#import "SheetDetailController.h"


@interface DiscoveryController () <SheetGroupDelegate>

@end

@implementation DiscoveryController

-(void)initViews{
    [super initViews];

    //初始化tableView结构
    [self initTableViewSafeArea];
    
    
    //初始化占位控件
    [self initPlaceholderView];
    
    //注册轮播图cell
    //也可以放到header中，这里之所以放到cell
    //是要实现列表的数据可以调整显示顺序
    [self.tableView registerClass:[BannerCell class] forCellReuseIdentifier:BannerCellName];
    //注册快捷键cell
    [self.tableView registerClass:[DiscoveryButtonCell class] forCellReuseIdentifier:DiscoveryButtonCellName];
    //注册歌单groupCell
    [self.tableView registerClass:[SheetGroupCell class] forCellReuseIdentifier:SheetGroupCellName];
    //注册单曲groupCell
    [self.tableView registerClass:[SongGroupCell class] forCellReuseIdentifier:SongGroupCellName];
    //注册FooterCell
    [self.tableView registerClass:[DiscoveryFooterCell class] forCellReuseIdentifier:DiscoveryFooterCellName];
    
    //下拉刷新
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];

//    //隐藏标题
    header.stateLabel.hidden = YES;

    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header=header;
    
}

-(void)endRefresh{
    [self.tableView.mj_header endRefreshing];
}

-(void)initDatum{
    [super initDatum];
    [self loadData:YES];
    
}

//-(void)onLeftClick:(QMUIButton *)sender{
////    [self.navigationController popViewControllerAnimated:YES];
//    NSLog(@"DiscoveryController onLeftClick");
//}
//
//-(void)onRightClick:(QMUIButton *)sender{
//    NSLog(@"DiscoveryController onRightClick");
//}

- (void)initListeners{
    [super initListeners];
    @weakify(self);
    
    //订阅banner点击事件
    [QTSubMain(self,BannerClickEvent) next:^(BannerClickEvent *event) {
        @strongify(self);
        [self processAdClick:event.data];
    }];
    
    //订阅banner点击事件
    [QTSubMain(self,ClickEvent) next:^(ClickEvent *event) {
        @strongify(self);
        [self processClick:event.style];
    }];

}

- (void)processAdClick:(Ad *)data{
    NSLog(@"processAdClick %@",data.uri);
    if ([data.uri hasPrefix:@"http"]) {
        [SuperWebController start:self.navigationController title:data.title uri:data.uri];
    }else{
        
    }
}

-(void)processClick:(ListStyle)style{
    switch (style) {
        case StyleRerfresh:
            [self autoRefresh];
            break;
        default:
            break;
    }
}

-(void)autoRefresh{
    //滚动到顶部
    NSIndexPath *indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    //延时200毫秒，执行加载数据，目的是让列表先向上滚动到顶部
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self startRefresh];
     });
}

-(void)startRefresh{
    //进入界面后自动刷新，会调用回调方法
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData:(BOOL)isPlaceholder{
//    [self.tableView reloadData];
        
    //广告API
    [[DefaultRepository shared] bannerAdWithController:self success:^(BaseResponse * _Nonnull baseResponse, Meta * _Nonnull meta, NSArray * _Nonnull data) {
        [self.datum removeAllObjects];
        
        //添加轮播图
        BannerData *bannerData=[BannerData new];
        bannerData.data = data;
        [self.datum addObject:bannerData];
        
        //添加快捷按钮
        [self.datum addObject:[ButtonData new]];
        
        //请求歌单数据
        [self loadSheetData];
        
       
    }];
    
}

-(void)loadSheetData{
    [[DefaultRepository shared] sheets:SIZE12 controller:self success:^(BaseResponse * _Nonnull baseResponse, Meta * _Nonnull meta, NSArray * _Nonnull data) {
        
        //添加歌单数据
        SheetData *sheetData=[SheetData new];
        sheetData.datum = data;
        [self.datum addObject:sheetData];
        //请求单曲数据
        [self loadSongData];
    }];
}

-(void)loadSongData{
    [[DefaultRepository shared] songsWithController:self success:^(BaseResponse * _Nonnull baseResponse, Meta * _Nonnull meta, NSArray * _Nonnull data) {
        [self endRefresh];
        
        //添加单曲数据
        SongData *result=[SongData new];
        result.datum = data;
        [self.datum addObject:result];
//        
        //添加尾部数据
        [self.datum addObject:[FooterData new]];
        
        [self.tableView reloadData];
        
//        //请求启动界面广告，当然也可以和轮播图接口一起返回
//        [self loadSplashAd];
    }];
}

#pragma mark - 列表数据源

/// 返回当前位置的cell
/// 相当于Android中RecyclerView Adapter的onCreateViewHolder
/// @param tableView tableView description
/// @param indexPath indexPath description
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data= self.datum[indexPath.row];
    //获取类型
    ListStyle style=[self typeForItemAtIndexPath:indexPath];
    
    switch (style) {
        case StyleBanner:{
            //轮播图
            BannerCell *cell = [tableView dequeueReusableCellWithIdentifier:BannerCellName forIndexPath:indexPath];
            
            //绑定数据
            [cell bind:data];
            
            return cell;
        }
            
        case StyleButton:{
            //按钮
            DiscoveryButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscoveryButtonCellName forIndexPath:indexPath];
            [cell bind:data];
            return cell;
        }
        case StyleSheet:{
            //歌单组
            SheetGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:SheetGroupCellName forIndexPath:indexPath];
            
            [cell bind:data];
            
            //设置代理
            cell.delegate = self;
            
            return cell;
        }
        case StyleSong:{
            //单曲组
            SongGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:SongGroupCellName forIndexPath:indexPath];
            
//            [cell setClickBlock:^(Song * _Nonnull result) {
//                @strongify(self);
//                [[MusicListManager shared] setDatum:@[result]];
//                
//                //播放当前音乐
//                [[MusicListManager shared] play:result];
//                
//                [self startMusicPlayerController];
//            }];
            
            [cell bind:data];
            
            return cell;
        }
        default:{
            DiscoveryFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscoveryFooterCellName forIndexPath:indexPath];
            return cell;
        }
    }
}

/// Cell类型
/// @param indexPath indexPath description
- (ListStyle)typeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data= self.datum[indexPath.row];
        
    if([data isKindOfClass:[BannerData class]]){
        //banner
        return StyleBanner;
    }else if ([data isKindOfClass:[ButtonData class]]){
        //按钮
        return StyleButton;
    }
    else if ([data isKindOfClass:[SheetData class]]){
        //歌单
        return StyleSheet;
    }
    else if ([data isKindOfClass:[SongData class]]){
        //单曲
        return StyleSong;
    }
//
    //TODO 更多的类型，在这里扩展就行了
    
    //尾部类型
    return -1;
}

#pragma mark - 歌单组代理
- (void)sheetClick:(Sheet *)data{
    [SheetDetailController start:self.navigationController id:data.id];
}
@end
