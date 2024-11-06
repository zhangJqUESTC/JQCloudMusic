//
//  NSString+SuperOC.m
//  JQCloudMusic
//
//  Created by zhangjq on 2024/11/5.
//

#import "NSString+SuperOC.h"

@implementation NSString (SuperOC)
-(NSString *)trim{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *result = [self stringByTrimmingCharactersInSet:characterSet];
    return result;
}
@end
