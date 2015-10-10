//
//  QYOptionView.h
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYOptionView : UIView

@property (nonatomic, strong) NSArray *opts;

@property (nonatomic, strong) void (^optBtnAction)(UIButton *);

+ (instancetype)optionView;

@end
