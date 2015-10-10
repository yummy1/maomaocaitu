//
//  QYOptionView.m
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYOptionView.h"

@implementation QYOptionView

+ (instancetype)optionView
{
    // 从main bundle中加载xib文件，来构建option view的视图
    return [[NSBundle mainBundle] loadNibNamed:@"QYOptionView" owner:nil options:nil][0];
}

- (IBAction)optBtnClicked:(UIButton *)option {
    if (_optBtnAction) {
        _optBtnAction(option);
    }
}

// 重写setFrame:方法
- (void)setFrame:(CGRect)frame
{
    CGRect originFrame = self.frame;
    originFrame.origin = frame.origin;
    [super setFrame:originFrame];
}

// 重写opts的setter方法
- (void)setOpts:(NSArray *)opts
{
    _opts = opts;
    
    for (int i = 0; i < self.subviews.count; i++) {
        // 遍历_opts数组中的每个元素，取出来之后，依次赋值给option view的子视图(option button)
        [self.subviews[i] setTitle:_opts[i] forState:UIControlStateNormal];
    }
}



@end
