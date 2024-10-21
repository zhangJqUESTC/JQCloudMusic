//
//  SuperWebController.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/21.
//

//webview和js交互框架
//#import <WebViewJavascriptBridge.h>
#import "SuperWebController.h"


#pragma mark - html前后字符串
//设置缩放，字体，图片，pre等标签样式
static NSString * const CONTENT_WRAPPER_START = @"<!DOCTYPE html><html><head><title></title><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no\"><style type=\"text/css\"> body{font-family: Helvetica Neue,Helvetica,PingFang SC,Hiragino Sans GB,Microsoft YaHei,\\5FAE\8F6F\96C5\9ED1,Arial,sans-serif;word-wrap: break-word;word-break: normal;} h2{text-align: center;} img {max-width: 100%;} pre{word-wrap: break-word!important;overflow: auto;}</style></head><body>";

//HTML结束标签
static NSString * const CONTENT_WRAPPER_END = @"</body></html>";

//这样webview中，以//开头的图片才会显示
static NSString * const WEBVIEW_BASE_URL = @"http://ixuea.com";

@interface SuperWebController ()
@property(nonatomic, strong) UIProgressView *progressView;

//@property(nonatomic, strong) WebViewJavascriptBridge* bridge;
@end

@implementation SuperWebController

- (void)initViews{
    [super initViews];
    [self initRelativeLayoutSafeArea];
    
    //设置右侧按钮
    [self addRightImageButton:[R.image.close withTintColor]];
    
    //web控件
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[SuperWebController defaultConfiguration]];
    self.webView.myWidth = MyLayoutSize.fill;
    self.webView.myHeight = MyLayoutSize.fill;
    [self.container addSubview:self.webView];
    
    //进度条
    _progressView = [UIProgressView new];
    _progressView.myWidth = MyLayoutSize.fill;
    _progressView.myHeight = 1;
    
    //设置进度条的颜色
    _progressView.progressTintColor = [UIColor colorPrimary];
    [self.container addSubview:_progressView];
    
    if ([self.uri containsString:@"bride.html"]) {
        //测试原生和js交互按钮
        //控制容器
        self.superFooterContentContainer.padding=UIEdgeInsetsMake(PADDING_SMALL, 0, PADDING_SMALL, 0);
        
        MyBaseLayout *bottomContainer=[[MyLinearLayout alloc] initWithOrientation:MyOrientation_Horz];
        bottomContainer.myWidth = MyLayoutSize.fill;
        bottomContainer.myHeight = MyLayoutSize.wrap;;
        bottomContainer.gravity = MyGravity_Vert_Bottom;
        bottomContainer.paddingLeft=PADDING_LARGE;
        bottomContainer.paddingRight=PADDING_LARGE;
        bottomContainer.subviewSpace = PADDING_LARGE;
        bottomContainer.gravity=MyGravity_Vert_Center;
        [self.superFooterContentContainer addSubview:bottomContainer];
        
        QMUIButton *button1 = [ViewFactoryUtil primaryHalfFilletButton];
        [button1 setTitle:R.string.localizable.callMethod1 forState:UIControlStateNormal];
        button1.weight=1;
        [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [bottomContainer addSubview:button1];
        
        QMUIButton *button2 = [ViewFactoryUtil primaryHalfFilletButton];
        [button2 setTitle:R.string.localizable.callMethod2 forState:UIControlStateNormal];
        button2.weight=1;
        [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
        [bottomContainer addSubview:button2];
    }
}

- (void)initDatum{
    [super initDatum];
//    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    
    //注册一个方法，在js那边调用，参数，结果是字符串
//    [self.bridge registerHandler:@"nativeMethod1" handler:^(id data, WVJBResponseCallback responseCallback) {

//        NSString *result=[NSString stringWithFormat:@"nativeMethod1 result:%@",data];
//
//        NSLog(@"nativeMethod1: %@ %@", data,result);
//
//        //返回结果
//        responseCallback(result);
//    }];

    //注册一个方法，在js那边调用，参数，结果是字典
//    [self.bridge registerHandler:@"nativeMethod2" handler:^(id data, WVJBResponseCallback responseCallback) {
//
//        NSDictionary *param = data;
//
//        NSString *result=[NSString stringWithFormat:@"nativeMethod2 result:%@",param[@"nickname"]];
//
//        NSMutableDictionary *results=[NSMutableDictionary dictionaryWithDictionary:param];
//
//        results[@"nickname"]=result;
//
//        NSLog(@"nativeMethod2: %@ %@", data,results);
//
//        responseCallback(results);
//    }];
    
    //设置标题
    if ([StringUtil isNotBlank:self.myTitle]) {
        self.title=self.myTitle;
    }
    
    if ([StringUtil isNotBlank:self.uri]) {
        //显示网址内容
        //创建一个Request
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.uri]];
        
        //请求
        [self.webView loadRequest:request];
    }else if ([StringUtil isNotBlank:self.content]){
        //显示字符串
        
        //由于服务端，返回的字符串，不是一个完整的HTML字符串
        //同时本地可能希望添加一些字体设置，所以要前后拼接为一个
        //完整的HTML字符串
        NSMutableString * buffer=[NSMutableString stringWithString:CONTENT_WRAPPER_START];
        
        //添加内容
        [buffer appendString:self.content];
        
        [buffer appendString:CONTENT_WRAPPER_END];
        
        //加载字符串
        [self.webView loadHTMLString:buffer baseURL:[NSURL URLWithString:WEBVIEW_BASE_URL]];
    }else{
        //TODO 参数错误
    }
}

- (void)initListeners{
    [super initListeners];
    
    if (!_myTitle) {
        //监听网页标题
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    //监听加载进度
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}

/// KVO监听回调
/// @param keyPath keyPath description
/// @param object object description
/// @param change change description
/// @param context context description
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (object == self.webView) {
        if ([keyPath isEqualToString:@"title"]){
            //标题
            self.title = self.webView.title;
        }else if ([keyPath isEqualToString:@"estimatedProgress"]) {
            //进度
            
            //0~1
            float progress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            _progressView.progress = progress;
            
            if (progress < 1) {
                _progressView.visibility = MyVisibility_Visible;
                
                //完全不透明
                _progressView.alpha = 1.0;
            } else if (progress >= 1) {
                @weakify(self);
                
                [UIView animateWithDuration:0.35 delay:0.15 options:7 animations:^{
                    self.progressView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        @strongify(self);
                        self.progressView.visibility = MyVisibility_Gone;
                        self.progressView.progress=0;
                        self.progressView.alpha = 1.0;
                    }
                }];
            }
        }
    }
}


/// 获取配置
+ (WKWebViewConfiguration *)defaultConfiguration {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    
    if ([configuration respondsToSelector:@selector(setAllowsInlineMediaPlayback:)]) {
        [configuration setAllowsInlineMediaPlayback:YES];
    }
    if (@available(iOS 10.0, *)) {
        if ([configuration respondsToSelector:@selector(setMediaTypesRequiringUserActionForPlayback:)]){
            [configuration setMediaTypesRequiringUserActionForPlayback:WKAudiovisualMediaTypeNone];
        }
    } else if (@available(iOS 9.0, *)) {
        if ([configuration respondsToSelector:@selector(setRequiresUserActionForMediaPlayback:)]) {
            [configuration setRequiresUserActionForMediaPlayback:NO];
        }
    } else {
        if ([configuration respondsToSelector:@selector(setMediaPlaybackRequiresUserAction:)]) {
            [configuration setMediaPlaybackRequiresUserAction:NO];
        }
    }
    return configuration;
}

/// 拦截点击返回按钮
- (void)onLeftClick:(QMUIButton *)sender{
    if ([self.webView canGoBack]) {
        //如果浏览器能返回上一页，就直接返回上一页
        [_webView goBack];
        return;
    }
    [self finish];
}

- (void)onRightClick:(QMUIButton *)sender{
    [self finish];
}

#pragma mark - 启动界面
+ (void)start:(UINavigationController *)controller title:(nullable NSString *)title uri:(NSString *)uri{
    [self start:controller title:title uri:uri content:nil];
}

+ (void)start:(UINavigationController *)controller title:(nullable NSString *)title content:(NSString *)content{
    [self start:controller title:title uri:nil content:content];
}

+ (void)start:(UINavigationController *)controller title:(nullable NSString *)title uri:(NSString *)uri content:(NSString *)content{
    SuperWebController *newController=[[SuperWebController alloc] init];
    
    //将传递过来的数据设置到controller中
    newController.myTitle=title;
    newController.uri=uri;
    newController.content=content;
    
    [controller pushViewController:newController animated:YES];
}

@end
