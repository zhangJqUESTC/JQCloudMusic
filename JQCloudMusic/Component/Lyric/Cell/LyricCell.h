//
//  LyricCell.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "BaseTableViewCell.h"
#import "LyricLineView.h"

NS_ASSUME_NONNULL_BEGIN

@interface LyricCell : BaseTableViewCell
/// 歌词控件
//@property (nonatomic, strong) UILabel *lineView;

/// 歌词控件（自定义）
@property (nonatomic, strong) LyricLineView *lineView;

-(void)bind:(NSObject *)data accurate:(BOOL)accurate;
@end

NS_ASSUME_NONNULL_END
