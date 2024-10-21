//
//  BannerCell.m
//  JQCloudMusic
//  发现界面轮博图cell
//  Created by zhangjq on 2024/10/16.
//

//轮播图

#import "BannerCell.h"
#import "Ad.h"
#import "ResourceUtil.h"
//图片加载框架
#import <SDWebImage/SDWebImage.h>
#import "BannerClickEvent.h"
@implementation BannerCell

-(void)initViews{
    [super initViews];
    //底部的距离，由下一个控件设置，除非不方便设置
    self.container.padding = UIEdgeInsetsMake(16, 16, 0, 16);
    //轮播图器容器
    MyRelativeLayout *bannerContainer =[MyRelativeLayout new];
    bannerContainer.myWidth = MyLayoutSize.fill;
    
    //SCREEN_WIDTH是QMUI提供的宏
    //直接在initViews里面这样获取self.contentView.frame.size.width是默认值
    //而不是应用了自动布局后的值
    bannerContainer.myHeight = SCREEN_WIDTH * 0.389;
    //高是宽的0.389倍，这样算，最终cell高度没问题，但轮播图cell高度有问题，所以手动算
//    bannerContainer.heightSize.equalTo(self.contentView.widthSize).multiply(0.389);
    [self.container addSubview:bannerContainer];
    
    //轮播图
    _contentScrollView = [[GKCycleScrollView alloc] init];
    _contentScrollView.backgroundColor = [UIColor clearColor];
    _contentScrollView.dataSource = self;
    _contentScrollView.delegate = self;
    _contentScrollView.myWidth = MyLayoutSize.fill;
    _contentScrollView.myHeight = MyLayoutSize.fill;
    _contentScrollView.clipsToBounds = YES;
    _contentScrollView.layer.cornerRadius = 10;

    //禁用自动滚动
    _contentScrollView.isAutoScroll=YES;

    //不改变透明度
    _contentScrollView.isChangeAlpha=NO;

    _contentScrollView.clipsToBounds = YES;
    [bannerContainer addSubview:_contentScrollView];

    //指示器
    GKPageControl *pageControl = [[GKPageControl alloc] init];
    pageControl.userInteractionEnabled = NO;
    pageControl.style = GKPageControlStyleCycle;
    _contentScrollView.pageControl = pageControl;

    //默认颜色
    pageControl.pageIndicatorTintColor = [UIColor black80];

    //高亮颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorPrimary];
    pageControl.myWidth = MyLayoutSize.fill;
    pageControl.myHeight = 15;
    pageControl.myBottom=PADDING_MEDDLE;
    [bannerContainer addSubview:pageControl];
}

- (void)initDatum{
    [super initDatum];
    self.datum = [NSMutableArray array];
}

-(void)bind:(BannerData*)data{
    [self.datum removeAllObjects];
    [self.datum addObjectsFromArray:data.data];
    [self.contentScrollView reloadData];
}

#pragma mark  轮播图数据源

/// 有多少个
/// @param cycleScrollView cycleScrollView description
- (NSInteger)numberOfCellsInCycleScrollView:(GKCycleScrollView *)cycleScrollView{
    return self.datum.count;
}

/// 返回cell
/// @param cycleScrollView cycleScrollView description
/// @param index index description
- (GKCycleScrollViewCell *)cycleScrollView:(GKCycleScrollView *)cycleScrollView cellForViewAtIndex:(NSInteger)index {
    GKCycleScrollViewCell *cell = [cycleScrollView dequeueReusableCell];
    if (!cell) {
        cell = [GKCycleScrollViewCell new];
    }

    Ad *data=[self.datum objectAtIndex:index];
    
    //将地址转为绝对地址
    NSString *uri = @"";
    if ([data.icon hasPrefix:@"http"]){
        uri = data.icon;
    }else{
        uri = [ResourceUtil resourceUri:data.icon];
    }

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:uri]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;

    return cell;
}

/// 点击
/// @param cycleScrollView cycleScrollView description
/// @param index index description
- (void)cycleScrollView:(GKCycleScrollView *)cycleScrollView didSelectCellAtIndex:(NSInteger)index{
    BannerClickEvent *event = [[BannerClickEvent alloc] init];
    event.data = self.datum[index];
    [QTEventBus.shared dispatch:event];
}
@end
