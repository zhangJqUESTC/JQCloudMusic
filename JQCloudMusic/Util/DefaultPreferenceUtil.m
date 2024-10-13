//
//  DefaultPreferenceUtil.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/10/13.
//

#import "DefaultPreferenceUtil.h"
static NSString * const TERMS_SERVICE = @"TERMS_SERVICE";

@implementation DefaultPreferenceUtil

+ (BOOL)isAcceptTermsServiceAgreement{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:TERMS_SERVICE]==nil) {
        //默认值
        return NO;
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:TERMS_SERVICE];
}

+ (void)setAcceptTermsServiceAgreement:(BOOL)data{
    //保存值
    [[NSUserDefaults standardUserDefaults] setBool:data forKey:TERMS_SERVICE];
    
    //同步，相当于写到文件
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
