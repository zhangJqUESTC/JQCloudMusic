//
//  BannerCell.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/16.
//

#import <GKCycleScrollView/GKCycleScrollView.h>
#import <GKCycleScrollView/GKPageControl.h>
#import "BaseTableViewCell.h"
#import "BannerData.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const BannerCellName = @"BannerCellName";
@interface BannerCell : BaseTableViewCell

-(void)bind:(BannerData*)data;
@property (nonatomic, strong) GKCycleScrollView *contentScrollView;
@property (nonatomic, strong) NSMutableArray *datum;
@end

NS_ASSUME_NONNULL_END
