//
//  QYAnswerView.m
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "QYAnswerView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width

@implementation QYAnswerView

+ (instancetype)answerViewWithCount:(NSUInteger)count
{
    // 1. 创建answerView视图
    QYAnswerView *answerView = [[self alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    
    // 设置answerView的背景颜色为透明色
    answerView.backgroundColor = [UIColor clearColor];
    answerView.count = count;

    
    for (int i = 0; i < count; i++) {
        // 2. 创建anser button
        CGFloat margin = 10;
        CGFloat answerW = 40;
        CGFloat answerH = 40;
        CGFloat baseX = (kScreenW-(count*answerW)-(count-1)*margin) / 2;
        CGFloat answerX = baseX + i * (answerW+margin);
        CGFloat answerY = 0;
        UIButton *answer = [[UIButton alloc] initWithFrame:CGRectMake(answerX, answerY, answerW, answerH)];
        // 3. 添加到answerView上
        [answerView addSubview:answer];
        
        // 4. 设置answer的背景颜色和文字颜色
        [answer setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [answer setBackgroundColor:[UIColor whiteColor]];
        
        // 5. 添加点击事件
        [answer addTarget:answerView action:@selector(answerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return answerView;
}
#warning block
// answer按钮的点击事件
- (void)answerBtnClicked:(UIButton *)answer
{
    if (_answerBtnAction) {
        _answerBtnAction(answer);
    }
}

// 重写setFrame:方法
- (void)setFrame:(CGRect)frame
{
    CGRect originFrame = self.frame;
    originFrame.origin = frame.origin;
    // 这个地方不能像下面（62行）那样写，那样，会造成死循环
//    self.frame = originFrame;
    
    // 应该这样写，调用父类的setFrame:方法，因为，父类的该方法是直接赋值
    [super setFrame:originFrame];
}

// 重写setIndex:方法，避免index越界
- (void)setIndex:(NSUInteger)index
{
    // 如果index超出范围，就归0
    if (index >= _count) {
        _index = 0;
        return;
    }
    
    _index = index;
}


@end
