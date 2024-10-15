//
//  SuperHttpUtil.m
//  JQCloudMusic
//  网络框架封装
//  Created by zhangjq on 2024/10/15.
//

#import "SuperHttpUtil.h"

@implementation SuperHttpUtil

+ (void)requestObjectWith:(Class)clazz url:(NSString *)url parameters:(NSDictionary *)parameters cachePolicy:(MSCachePolicy)cachePolicy method:(MSRequestMethod)method loading:(BOOL)loading controller:(BaseLogicController *)controller success:(SuperHttpSuccess)success failure:(SuperHttpFail)failure{
    
    //检查是否显示Loading
        [self checkShowLoading:loading];
    
    //前置处理
    [self preProcess:controller];
    
    [self requestWithMethod:method url:url parameters:parameters cachePolicy:cachePolicy success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull data) {
        //解析为BaseResponse
        BaseResponse *baseResponse=[[BaseResponse class] mj_objectWithKeyValues:data];
        
        //检查是否隐藏Loading
        [self checkHideLoading:loading];
        
        if ([self isSuccessWithResponse:baseResponse]) {
            //请求成功
            
            //默认data字段有值，因为对于get请求来说，我们默认必须有返回值
            //那如果项目中有这种请求，还需要特殊处理
            //像统计这类api，用post，但有些就是get
            id dataDict=data[@"data"];
            
            //将字典解析为模型
            id result=[clazz mj_objectWithKeyValues:dataDict];
            
            //回调block
            success(baseResponse,result);
        } else {
            //业务请求失败，例如：服务端返回密码错误
            [self handlerResponse:baseResponse error:nil failure:failure task:task placeholder:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //检查是否隐藏Loading
        [self checkHideLoading:loading];
        
        //像网络错误，服务端返回401，400，500等都会都在这里
        NSLog(@"SuperHttpUtil failure %@",error);
        [self handlerResponse:nil error:error failure:failure task:task placeholder:nil];
    }];
}

+(void)checkHideLoading:(BOOL)Loading{
    
}

+(void)checkShowLoading:(BOOL)Loading{
    
}

+(BOOL)isSuccessWithResponse:(BaseResponse *)data{
    //判断对于业务逻辑是否请求正常
    //也就是判断data里面的status
    
    //int,long，double等从字典里面取出来是NSNumber
//    NSNumber *status=data[@"status"];
//    if (status.intValue==0) {
//        return YES;
//    }
    
    return data.status==0;
}

+(void)handlerResponse:(BaseResponse *)data error:(NSError *)error failure:(SuperHttpFail)failure task:(NSURLSessionDataTask *)task placeholder:(nullable NSObject *)placeholder {
//    if (failure && failure(data,error)) {
//        //回调失败block
//        //返回YES，父类不自动处理错误
//
//        //子类需要关闭loading，当前也可以父类关闭
//        //暴露给子类的原因是，有些场景会用到
//        //例如：请求失败后，在调用一个接口，如果中途关闭了
//        //用户能看到多次显示loading，体验没那么好
//    }else{
//        //自动处理错误
//        [self handlerResponseError:data error:error task:task placeholder:placeholder];
//    }
}

+(void)preProcess:(BaseLogicController *)controller{
//    if (controller && controller.placeholderView) {
//        [controller.placeholderView hide];
//    }
}

#pragma mark - 统一网络请求方法
+ (void)requestWithMethod:(MSRequestMethod)method url:(NSString *)url  parameters:(NSDictionary *)parameters cachePolicy:(MSCachePolicy)cachePolicy success:(MSHttpSuccess)success  failure:(MSHttpFail)failure{
    
//    if ([PreferenceUtil isLogin]) {
//        //获取token
//
//        //将token设置到请求头
//        NSString *session = [PreferenceUtil getSession];
//        [MSNetwork setHeader:@{@"Authorization":session}];
//    }
    
    // 发起请求
    [MSNetwork HTTPWithMethod:method url:url parameters:parameters headers:nil cachePolicy:cachePolicy success:^(NSURLSessionDataTask *task,id  _Nonnull responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task,NSError * _Nonnull error) {
        failure(task,error);
    }];
}
@end
