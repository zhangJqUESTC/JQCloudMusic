//
//  Constant.h
//  JQCloudMusic
//  常量文件
//  Created by zhangjq on 2024/10/12.
//

#ifndef Constant_h
#define Constant_h


static NSString * const URL_VIDEO = @"v1/videos";

#pragma mark - 文本尺寸
static float const TEXT_SMALL = 12;
static float const TEXT_MEDDLE = 14;
static float const TEXT_LARGE = 16;
static float const TEXT_LARGE2 = 17;
static float const TEXT_LARGE3 = 18;
static float const TEXT_LARGE4 = 22;
static float const TEXT_PRICE = 30;

#pragma mark - 按钮尺寸
static float const BUTTON_SMALL = 30;
static float const BUTTON_MEDDLE = 42;
static float const BUTTON_LARGE = 55;
static float const BUTTON_WIDTH_MEDDLE = 150;

#pragma mark - 圆角尺寸
static float const SMALL_RADIUS = 5;
static float const MEDDLE_RADIUS = 10;
static float const BUTTON_SMALL_RADIUS = 15;
static float const BUTTON_MEDDLE_RADIUS = 21;

#pragma mark - 边距尺寸
//小小间歇
static float const PADDING_MIN = 1;

//小间歇
static float const PADDING_SMALL = 5;

//中间歇
static float const PADDING_MEDDLE = 10;

//边距间歇
static float const PADDING_OUTER = 16;

//大间歇
static float const PADDING_LARGE = 20;

//大间歇2
static float const PADDING_LARGE2 = 30;

//列表类型枚举，所有类型都定义到这里，方便统一管理，当然也可以按模块，界面拆分
typedef NS_ENUM(NSUInteger, ListStyle) {
    StyleNone,
    StyleBanner,
    StyleButton,
    StyleSheet,
    StyleSong,
    StyleFooter,
    StyleSheetMore,
    StyleSongMore,
    StyleOpenDrawer,
    StyleRerfresh,
    StyleMe,
    StyleMessageTextLeft, //左边，文本消息，其他人发的
    StyleMessageTextRight, //右边，文本消息，我发的
    StyleMessageImageLeft, //左边，图片消息，其他人发的
    StyleMessageImageRight, //右边，图片消息，我发的
    StylePhoneLogin,
    StyleForgotPassword,
    StyleComment,
    StyleVideo,
    StyleVideoInfo,
    StyleTitle,
    StyleAdd,
    StyleDownloadManager,
    StyleLocal,
    StyleCancel,
    StyleTencentMap,
    StyleBaiduMap,
    StyleAMap,
    StyleSystemMap,
    StyleFriend,
    StyleFans,
    StyleComfirmOrder,
    StyleOrder,
    StyleSelect,
    StyleIncrement,
    StyleDecrement,
    StylePlayList
};

#endif /* Constant_h */
