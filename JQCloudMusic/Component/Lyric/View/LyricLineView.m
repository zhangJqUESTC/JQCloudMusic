//
//  LyricLineView.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/18.
//

#import "LyricLineView.h"

//默认歌词字大小
static CGFloat const DEFAULT_LYRIC_TEXT_SIZE = 16.0f;

@implementation LyricLineView

- (instancetype)init{
    self=[super init];
    //去除默认背景
    self.backgroundColor = [UIColor clearColor];
    
    //设置默认值
    self.lyricTextSize = DEFAULT_LYRIC_TEXT_SIZE;
    self.lyricTextColor = [UIColor lightGrayColor];
    self.lyricSelectedTextColor = [UIColor colorPrimary];
    self.gravity = LyricLineGravityCenter;
    
    return self;
}

//绘制
//相当于Android中的View的onDraw
- (void)drawRect:(CGRect)rect{
    //如果没有歌词就返回
    if (self.data==nil) {
        return;
    }
    
    NSString *wordString=self.data.data;
    
    //富文本字典
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    //字体大小
    [attributes setObject:[UIFont systemFontOfSize:self.lyricTextSize] forKey:NSFontAttributeName];
    
    //设置绘制颜色
    attributes[NSForegroundColorAttributeName]=self.lyricTextColor;
    
    //获取歌词宽高
    CGSize size=[wordString sizeWithAttributes:attributes];
    
    //水平居中坐标
    CGFloat centerX = 0;
    if (self.gravity == LyricLineGravityCenter){
        //水平居中
        centerX=(self.frame.size.width-size.width)/2;
    }
    
    //当前这行歌词绘制开始点，字的左上角
    CGPoint point=CGPointMake(centerX, (self.frame.size.height-size.height)/2);
    
    //获取图形绘制上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.accurate) {
        //精确到字歌词
        //创建歌词的frame，大小正好和歌词宽高
        //同时，左侧和point一样
        CGRect frame=CGRectMake(point.x, point.y, size.width, size.height);

        //保存上下文
        //类似Android中View中在onDraw方法保存画图板状态
        CGContextSaveGState(context);

        //裁剪一个矩形区域
        CGContextClipToRect(context, frame);

        //绘制背景文字
        [wordString drawAtPoint:point withAttributes:attributes];

        //恢复上下文
        CGContextRestoreGState(context);

        if (self.lineSelected) {
            //绘制高亮颜色

            if (_lyricCurrentWordIndex==-1) {
                //该行已经播放完了
                self.lineLyricPlayedWidth=size.width;
            }else{
                //获取当前时间前面的文字
                NSString *beforeText=[self getBeforeText];

                //前面的文字宽度
                CGSize beforeTextSize=[beforeText sizeWithAttributes:attributes];

                //当前字
                NSString *currentWord=self.data.words[_lyricCurrentWordIndex];

                //当前字宽度
                //可以能大家觉得，字宽度都是一定的
                //但要考虑英文，所以要算
                CGSize currentWordSize=[currentWord sizeWithAttributes:attributes];

                //当前字已经播放的宽度

                //计算方法：
                //例如：当前字宽度为100px
                //当前字持续时间为50
                //那么 1px宽度=当前字宽度/当前字持续时间
                //已经播放的宽度=1px宽度*已经播放的时间

                //当前字持续时间
                NSNumber *currentWordDurationNumber= self.data.wordDurations[_lyricCurrentWordIndex];
                int currentWordDuration=[currentWordDurationNumber intValue];

                float currentWordWidth=currentWordSize.width/currentWordDuration*_wordPlayedTime;

                //当前行已经播放的宽度
                self.lineLyricPlayedWidth=beforeTextSize.width+currentWordWidth;
            }

            //选中的矩形
            CGRect selectedRect=frame;
            selectedRect.size.width=self.lineLyricPlayedWidth;

            //绘制高亮
            CGContextSaveGState(context);
            CGContextClipToRect(context, selectedRect);

            [attributes setObject:self.lyricSelectedTextColor forKey:NSForegroundColorAttributeName];

            [wordString drawAtPoint:point withAttributes:attributes];

            CGContextRestoreGState(context);
        }
    }else{
        //精确到行歌词
        CGContextSaveGState(context);
        
        if (self.lineSelected) {
            //选中颜色
            [attributes setObject:self.lyricSelectedTextColor forKey:NSForegroundColorAttributeName];
        }
        
        [wordString drawAtPoint:point withAttributes:attributes];
        
        CGContextRestoreGState(context);
    }

}

/// 获取该索引前面字符串
-(NSString *)getBeforeText{
    NSMutableString *result = [[NSMutableString alloc]init];
    for (int i=0; i<_lyricCurrentWordIndex; i++) {
        [result appendString:_data.words[i]];
    }
    
    return result;
}

@end
