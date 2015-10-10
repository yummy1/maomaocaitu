//
//  QYAnswerView.h
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAnswerView : UIView
@property (nonatomic, strong) void (^answerBtnAction)(UIButton *);
@property (nonatomic) NSUInteger count;
@property (nonatomic) NSUInteger index;

+ (instancetype)answerViewWithCount:(NSUInteger)count;
@end
