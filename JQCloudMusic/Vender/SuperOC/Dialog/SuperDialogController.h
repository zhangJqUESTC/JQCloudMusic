//
//  SuperDialogController.h
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/6.
//

#import "BaseController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SuperDialogController : BaseController
@property(nonatomic, strong) QMUIModalPresentationViewController *modalController;

@property(nonatomic, strong) MyBaseLayout *superRootContainer;
@property(nonatomic, strong) MyBaseLayout *superContentContainer;
@property(nonatomic, strong) MyBaseLayout *superFooterContainer;

/// 标题
@property(nonatomic, strong) UILabel *titleView;

/// 单行输入
@property (nonatomic, strong) QMUITextField *textFieldView;

/// 按钮列表，类型为QMUIButton
@property(nonatomic, strong) NSMutableArray *buttons;

@property(nonatomic, strong) NSString *titleText;

/// 设置确认按钮
/// @param title title description
/// @param target target description
/// @param action selector description
-(SuperDialogController *)setConfirmButton:(NSString *)title target:(nullable id)target action:(SEL)action;

/// 设置警告按钮
-(SuperDialogController *)setWarningButton:(NSString *)title target:(nullable id)target action:(SEL)action;

/// 设置取消按钮
-(SuperDialogController *)setCancelButton:(NSString *)title target:(nullable id)target action:(SEL)action;

/// 标题，输入框，确认按钮
-(SuperDialogController *)titleInputConfirmStyle;

/// 显示
-(void)show;

-(void)hide;
@end

NS_ASSUME_NONNULL_END
