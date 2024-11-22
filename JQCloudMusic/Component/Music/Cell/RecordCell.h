//
//  RecordCell.h
//  JQCloudMusic
//  黑胶唱片Cell
//  Created by zhangjq on 2024/11/19.
//

#import "BaseCollectionViewCell.h"
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecordCell : BaseCollectionViewCell
/// 封面
@property (nonatomic, strong) UIImageView *iconView;

/// 内容容器
@property (nonatomic, strong) MyRelativeLayout *contentContainer;

@property (nonatomic, strong) Song *data;

-(void)bind:(Song *)data;

-(void)rotate;
@end

NS_ASSUME_NONNULL_END
