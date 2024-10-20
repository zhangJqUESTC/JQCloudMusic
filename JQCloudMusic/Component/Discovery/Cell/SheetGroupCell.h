//
//  SheetGroupCell.h
//  JQCloudMusic
//  发现界面歌单组
//  Created by zhangjq on 2024/10/17.
//

#import "BaseTableViewCell.h"
#import "SheetData.h"
#import "ItemTitleView.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const SheetGroupCellName = @"SheetGroupCellName";

@protocol SheetGroupDelegate<NSObject>

/// 歌单点击回调
/// @param data 点击的歌单对象
- (void)sheetClick:(Sheet *)data;

@optional

/// 这是一个可选方法，在这里没有任何作用，只是演示可选语法
- (void)testOptionalMethod;
@end

@interface SheetGroupCell : BaseTableViewCell
/// 代理对象，目的是将歌单点击回调到外界，可以用EventBus，也可以用block
@property (nonatomic, weak, nullable) id<SheetGroupDelegate> delegate;
/// 标题控件
@property(nonatomic,strong) ItemTitleView *titleView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *datum;

-(void)bind:(SheetData *)data;
- (MyOrientation)getContainerOrientation;
@end

NS_ASSUME_NONNULL_END
