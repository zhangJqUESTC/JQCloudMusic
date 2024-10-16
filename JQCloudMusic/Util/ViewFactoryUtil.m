//
//  ViewFactoryUtil.m
//  JQCloudMusic
//  主要用来创建常见View，方便在多个位置使用
//  Created by zhangjq on 2024/10/12.
//



@implementation ViewFactoryUtil

+(QMUIButton *)primaryButton{
    QMUIButton *result = [[QMUIButton alloc] init];
    result.adjustsTitleTintColorAutomatically = NO;
    result.adjustsButtonWhenHighlighted = YES;
    result.titleLabel.font = UIFontMake(TEXT_LARGE);
    result.myWidth = MyLayoutSize.fill;
    result.myHeight = BUTTON_MEDDLE;
    result.backgroundColor = [UIColor colorPrimary];
    result.layer.cornerRadius = SMALL_RADIUS;
    result.tintColor = [UIColor colorLightWhite];
    [result setTitleColor:[UIColor colorLightWhite] forState:UIControlStateNormal];
    return result;
}

+(QMUIButton *)primaryHalfFilletButton{
    QMUIButton *result = [self primaryButton];
    result.layer.cornerRadius = BUTTON_MEDDLE_RADIUS;
    return result;
}

+(QMUIButton *)linkButton{
    QMUIButton *result = [[QMUIButton alloc] init];
    result.adjustsTitleTintColorAutomatically = NO;
    result.titleLabel.font = UIFontMake(TEXT_MEDDLE);
    
    return result;
}

+ (QMUIButton *)primaryOutlineButton{
    QMUIButton *result = [self primaryButton];
    result.layer.cornerRadius = SMALL_RADIUS;
    
    result.tintColor = [UIColor black130];
    result.layer.borderWidth = 1;
    result.layer.borderColor = [[UIColor black130] CGColor];
    result.backgroundColor = [UIColor clearColor];
    [result setTitleColor:[UIColor colorPrimary] forState:UIControlStateNormal];
    
    return result;
}

+(UITableView *)tableView{
    QMUITableView *result = [[QMUITableView alloc] init];
    
    result.backgroundColor = [UIColor clearColor];
    
    //去掉没有数据cell的分割线
    result.tableFooterView = [[UIView alloc] init];
    
    //去掉默认分割线
    result.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //修复默认分割线，向右偏移问题
    result.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    result.myWidth = MyLayoutSize.fill;
    result.myHeight = MyLayoutSize.fill;
    
    //设置所有cell的高度为高度自适应，如果cell高度是动态的请这么设置。 如果不同的cell有差异那么可以通过实现协议方法-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    //如果您最低要支持到iOS7那么请您实现-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath方法来代替这个属性的设置。
    result.rowHeight = UITableViewAutomaticDimension;
    
    result.estimatedRowHeight = UITableViewAutomaticDimension;
    
    //不显示滚动条
    [result setShowsVerticalScrollIndicator:NO];
    
    result.allowsSelection = YES;
    
    return result;
}
@end
