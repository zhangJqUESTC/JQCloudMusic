//
//  PlayListView.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/13.
//

#import "BaseLinearLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayListView : BaseLinearLayout <UITableViewDataSource,UITableViewDelegate>
/// 音乐数量view
@property (nonatomic, strong) UILabel *countView;

/// TableView
@property (nonatomic, strong) UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
