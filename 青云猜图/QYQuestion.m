//
//  QYQuestion.m
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYQuestion.h"

@implementation QYQuestion

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        //
        _answer = dict[@"answer"];
        _icon = dict[@"icon"];
        _title = dict[@"title"];
        _opts = dict[@"options"];
        
        _count = _answer.length;
    }
    
    return self;
}

+ (instancetype)questionWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

@end
