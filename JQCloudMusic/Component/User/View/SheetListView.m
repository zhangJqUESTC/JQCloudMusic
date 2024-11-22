//
//  SheetListView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/20.
//

#import "SheetListView.h"
#import "ButtonData.h"
#import "TopicCell.h"

@implementation SheetListView

- (instancetype)init{
    self=[super init];
    
    self.datum = [NSMutableArray array];
    
    [self initViews];
    return self;
}

-(void)initViews{
    self.myWidth = MyLayoutSize.fill;
    self.myHeight = MyLayoutSize.fill;
    
    //tableView
    self.tableView = [ViewFactoryUtil tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.weight=1;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self addSubview:self.tableView];
//    self.scrollView=self.tableView;
    
    //按钮cell
//    [self.tableView registerClass:[ButtonCell class] forCellReuseIdentifier:ButtonCellName];
    
    //标题cell
//    [self.tableView registerClass:[TitleCell class] forCellReuseIdentifier:TitleCellCellName];

    //注册歌单cell
    [self.tableView registerClass:[TopicCell class] forCellReuseIdentifier:Cell];
    
    
}

-(void)loadData{
    [self.datum removeAllObjects];
    
//    if (_showButton) {
//        [self.datum addObject:[ButtonData withIcon:R.image.scan title:R.string.localizable.downloadManager extra:StyleDownloadManager]];
//        [self.datum addObject:[ButtonData withIcon:R.image.scan title:R.string.localizable.localMusic extra:StyleLocal]];
//        [self.datum addObject:[ButtonData withIcon:R.image.scan title:R.string.localizable.playHistory extra:-1]];
//        [self.datum addObject:[ButtonData withIcon:R.image.scan title:R.string.localizable.myRadio extra:-1]];
//        [self.datum addObject:[ButtonData withIcon:R.image.scan title:R.string.localizable.myCollect extra:-1]];
//        [self.datum addObject:[ButtonData withIcon:R.image.scan title:R.string.localizable.sati extra:-1]];
//    }
//    
    if ([ANONYMOUS isEqualToString:self.userId]) {
        [self.tableView reloadData];
    }else{
//        TitleData *titleData=[TitleData new];
//        titleData.data=R.string.localizable.createdSheet;
//        titleData.extra=StyleAdd;
//        [self.datum addObject:titleData];
        
        //请求创建的歌单
        [[DefaultRepository shared] createSheets:self.userId success:^(BaseResponse * _Nonnull baseResponse, Meta * _Nonnull meta, NSArray * _Nonnull data) {
            //添加数据
            [self.datum addObjectsFromArray:data];
            
//            TitleData *titleData=[TitleData new];
//            titleData.data=R.string.localizable.collectedSheet;
//            [self.datum addObject:titleData];

            [[DefaultRepository shared] collectSheets:self.userId success:^(BaseResponse * _Nonnull baseResponse, Meta * _Nonnull meta, NSArray * _Nonnull data) {
                //添加到列表
                [self.datum addObjectsFromArray:data];
                [self.tableView reloadData];
            }];
        }];
    }
    
    
}

#pragma mark - 列表数据源

/// 有多少个
/// @param tableView tableView description
/// @param section section description
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datum.count;
}

/// 返回当前位置的cell
/// 相当于Android中RecyclerView Adapter的onCreateViewHolder
/// @param tableView tableView description
/// @param indexPath indexPath description
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *data= self.datum[indexPath.row];
    
    //获取类型
    ListStyle style=[self typeForItemAtIndexPath:indexPath];
    
    switch (style) {
        default:{
            //歌单
            TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell forIndexPath:indexPath];
            [cell bindWithSheet:data];
            
            return cell;
        }
    }
    
}


/// Cell类型
/// @param indexPath indexPath description
- (ListStyle)typeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSObject *data= self.datum[indexPath.row];
        
//    if ([data isKindOfClass:[TitleData class]]){
//        return StyleTitle;
//    }else 
        if ([data isKindOfClass:[ButtonData class]]){
        return StyleButton;
    }
    return StyleSheet;
}

@end
