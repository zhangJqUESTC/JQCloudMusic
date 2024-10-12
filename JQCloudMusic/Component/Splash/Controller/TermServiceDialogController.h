//
//  TermServiceDialogController.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/12.
//

#import "BaseController.h"
#import <QMUIKit/QMUIKit.h>
#include <MyLayout/MyLayout.h>
NS_ASSUME_NONNULL_BEGIN

@interface TermServiceDialogController : BaseController
@property (nonatomic, strong) QMUIModalPresentationViewController *modalController;
@property (nonatomic, strong) MyBaseLayout *rootContainer;
@property (nonatomic, strong) MyBaseLayout *contentContainer;
@property (nonatomic, strong) MyBaseLayout *footContainer;
/// 标题控件
@property (nonatomic, strong) UILabel *titleView;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) QMUIButton *primaryButton;
@property (nonatomic, strong) QMUIButton *disagreeButton;

-(void)show;
-(void)hide;
@end

NS_ASSUME_NONNULL_END
