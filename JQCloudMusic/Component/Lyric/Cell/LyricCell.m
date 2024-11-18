//
//  LyricCell.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "LyricCell.h"

@implementation LyricCell

- (void)initViews{
    [super initViews];
    
    //底部的距离，由下一个控件设置，除非不方便设置
    self.container.padding = UIEdgeInsetsMake(0, 16, 0, 16);
    
    //系统控件，只支逐行高亮效果
//    _lineView = [UILabel new];
//    _lineView.myWidth = MyLayoutSize.fill;
//    _lineView.textColor=[UIColor whiteColor];
//    _lineView.textAlignment = NSTextAlignmentCenter;
    
    //自定义控件
    _lineView = [LyricLineView new];
    _lineView.myWidth = MyLayoutSize.fill;
    
    //固定高度，方便计算占位数量
    _lineView.myHeight = 44;
    [self.container addSubview:_lineView];
}

-(void)bind:(NSObject *)data accurate:(BOOL)accurate{
    //使用Label实现
//    if ([data isKindOfClass:[NSString class]]) {
//        //是占位数据
//        _lineView.text = @"";
//    } else {
//        //真实歌词数据
//        LyricLine *lyricLine = data;
//        _lineView.text = lyricLine.data;
//    }
    
    //自定义控件
    if ([data isKindOfClass:[NSString class]]) {
        //是占位数据
        _lineView.data = nil;
        _lineView.accurate = NO;
    } else {
        //真实歌词数据
        LyricLine *lyricLine = data;
        _lineView.data = lyricLine;
        _lineView.accurate = accurate;
    }
}

/// 当TableView选中或者取消选中调用
/// @param selected selected description
/// @param animated animated description
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    self.lineView.lineSelected=selected;
    [self.lineView setNeedsDisplay];
}

@end
