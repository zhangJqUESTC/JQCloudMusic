//
//  TopicCell.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/20.
//

#import "BaseTableViewCell.h"
#import "Sheet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopicCell : BaseTableViewCell
/// 封面
@property (nonatomic, strong) UIImageView *iconView;

/// 标题
@property (nonatomic, strong) UILabel *titleView;

/// 更多信息
@property (nonatomic, strong) UILabel *infoView;

/// 右侧容器
@property (nonatomic, strong) MyLinearLayout *rightContainer;

-(void)bindWithSheet:(Sheet *)data;

-(void)bindWithUser:(User *)data;
@end

NS_ASSUME_NONNULL_END
