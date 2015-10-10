//
//  QYQuestion.h
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYQuestion : NSObject

@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *opts;
@property (nonatomic) BOOL isFinished;

// 用来标记答案的个数
@property (nonatomic) NSUInteger count;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)questionWithDictionary:(NSDictionary *)dict;

@end
