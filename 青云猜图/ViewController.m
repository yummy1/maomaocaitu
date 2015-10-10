//
//  ViewController.m
//  青云猜图
//
//  Created by qingyun on 15/6/30.
//  Copyright (c) 2015年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QYAnswerView.h"
#import "QYOptionView.h"
#import "QYQuestion.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *coin;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (nonatomic, strong) NSArray *questions;
@property (nonatomic, strong) QYAnswerView *answerView;
@property (nonatomic, strong) QYOptionView *optionView;
@property (nonatomic, strong) UIButton *cover;

@property (nonatomic) NSUInteger index;
@property (nonatomic) NSUInteger answerNumber; // 已经点击的答案数
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self updateViewsAndDatas];
}

- (void)updateViewsAndDatas
{
    
    // 1. 如果超出最后一页，则翻转到第0页
    if (_index >= self.questions.count) {
        _index = 0;
    }
    
    QYQuestion *question = self.questions[_index];
    
    // 2. 移除原有的answerView和optionView
    [_answerView removeFromSuperview];
    [_optionView removeFromSuperview];
    
    // 3. 添加answerView
    _answerView = [QYAnswerView answerViewWithCount:question.count];
    [self.view addSubview:_answerView];

    _answerView.frame = CGRectMake(0, 370, 0, 0);
    __weak ViewController *weakSelf = self;
    _answerView.answerBtnAction = ^(UIButton *btn) {
        [weakSelf answerBtnClicked:btn];
    };
    
    // 4. 添加optionView
    _optionView = [QYOptionView optionView];
    [self.view addSubview:_optionView];
    
    _optionView.frame = CGRectMake(0, 450, 0, 0);
    _optionView.optBtnAction = ^(UIButton *btn) {
        [weakSelf optionBtnClicked:btn];
    };
    
    // 5. 更新首页数据
    _num.text = [NSString stringWithFormat:@"%lu/%02lu", _index+1, (unsigned long)self.questions.count];
    _desc.text = question.title;
    _icon.image = [UIImage imageNamed:question.icon];
    _optionView.opts = question.opts;
    
    if (question.isFinished) {
        [self next:nil];
    }
    
    // 6. 清空记录已输入答案个数的全局变量 _answerNumber
    _answerNumber = 0;
}

- (NSArray *)questions
{
    if (_questions == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
        NSArray *dicts = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *models = [NSMutableArray array];
        for (NSDictionary *dict in dicts) {
            QYQuestion *question = [QYQuestion questionWithDictionary:dict];
            [models addObject:question];
        }
        _questions = models;
    }
    return _questions;
}


#pragma mark - button actions
- (IBAction)hint:(id)sender {
    // 1. 没有钱了，弹出警告框
    if ([_coin.currentTitle isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"木钱了!" message:@"Sorry,你的金币花光了，请及时充值!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"去充值", nil];
        [alert show];
        return;
    }
    

    // 2. 如果是该页面第一次提示，则消掉所有答案，并重置_answerView.index为0
    static BOOL isFirst = YES;
    if (isFirst) {
        for (UIButton *answer in _answerView.subviews) {
            [self answerBtnClicked:answer];
        }
        _answerView.index = 0;
        isFirst = NO;
    }
    
    // 3. 取出_answerView上对应index的答案
    QYQuestion *question = self.questions[_index];
    NSString *answerStr = question.answer;
    NSString *btnStr = [answerStr substringWithRange:NSMakeRange(_answerView.index, 1)];
    
    // 4. 找到_optionView上对应答案的按钮，并模拟该按钮被点击的操作，然后进行减金币的操作
    for (UIButton *option in _optionView.subviews) {
        if ([option.currentTitle isEqualToString:btnStr]) {
            // 模拟点击操作
            [self optionBtnClicked:option];
            
            // 减金币
            [self changeScoreByAdding:-1000];
            
            // 只要找到一个optionView上对应的option按钮，就退出循环
            break;
        }
    }
    
}


-(void)smaller:(UIButton *)sender
{
    [UIView animateWithDuration:0.8 animations:^{
        _icon.transform = CGAffineTransformIdentity;
        _cover.alpha = 0;
    } completion:^(BOOL finished) {
        [_cover removeFromSuperview];
    }];
}

- (IBAction)bigger:(id)sender {
    // 1. 添加cover
    _cover = [[UIButton alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_cover];
    _cover.alpha = 0;
    _cover.backgroundColor = [UIColor brownColor];
    [_cover addTarget:self action:@selector(smaller:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2. 把icon移动到视图的最上层
    [self.view bringSubviewToFront:_icon];
    
    // 3. 添加cover颜色渐变及icon放大的动画效果
    [UIView animateWithDuration:0.8 animations:^{
        _icon.transform = CGAffineTransformScale(_icon.transform, 1.6, 1.6);
        _cover.alpha = 0.6;
    }];
}

- (IBAction)next:(id)sender {
    // 如果说，所有页面都答对了，就弹出通关页面
    BOOL isPass = YES;
    for (QYQuestion *question in self.questions) {
        if (!question.isFinished) {
            isPass = NO;
            break;
        }
    }
    
    if (isPass) {
        // 弹出通关页面，并返回
        UIAlertView *passAlert = [[UIAlertView alloc] initWithTitle:@"通关了!" message:@"恭喜你，通关了!" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"再玩一次", nil];
        [passAlert show];
        return;
    }
    _index++;
    [self updateViewsAndDatas];
}

- (void)answerBtnClicked:(UIButton *)answer
{
    // 1. 如果answer按钮没有文字，则直接返回
    if (answer.currentTitle == nil) return;
    
    // 2. 重置答案的颜色为黑色
    [self changeAnswersColor:[UIColor blackColor]];
    
    // 3. 将optionView上对应的按钮的隐藏效果取消 hidden = NO
    for (UIButton *option in _optionView.subviews) {
        if ([option.currentTitle isEqualToString:answer.currentTitle] && option.hidden) {
            option.hidden = NO;
            break;
        }
    }
    
    // 4. 将answerView上的该answer按钮的文字内容清空
    [answer setTitle:nil forState:UIControlStateNormal];
    
    // 5. 更新_answerNumber及_answerView.index
    _answerNumber--;
    if (_answerNumber == 0) { // 代表答案被全部清空了，这个时候，应该让_answerView.index = 0
        _answerView.index = 0;
    } else {
        _answerView.index = [_answerView.subviews indexOfObject:answer];
    }
}

- (void)optionBtnClicked:(UIButton *)option
{
    // 1. 如果已经点满了，并且还不正确，则直接返回
    QYQuestion *question = self.questions[_index];
    if (_answerNumber == question.count) {
        return;
    }
    
    // 2. 将点击的btn的title更新到answerView上，并更新answerTitle
    NSUInteger index = _answerView.index;
    UIButton *answer = _answerView.subviews[index];
    // 如果该answer按钮已经有字了，则模拟其被点击的操作
    if (answer.currentTitle) {
        [self answerBtnClicked:answer];
    }
    // 更新answer按钮的title
    [answer setTitle:option.currentTitle forState:UIControlStateNormal];
    
    // 3. 隐藏optionView上对应的该option按钮
    option.hidden = YES;
    
    // 4. 更新_questionNumber和_answerView.index
    _answerNumber++;
    _answerView.index++;
    
    // 5. 判断是否满足full条件
    BOOL isFull = NO;
    if (_answerNumber == question.count) {
        isFull = YES;
    }
    
    // 6. 验证答案是否正确，并进行相应逻辑处理
    if (isFull) {
        // 拼接现有答案
        NSMutableString *answerStr = [NSMutableString string];
        for (UIButton *answer in _answerView.subviews) {
            [answerStr appendString:answer.currentTitle];
        }
        
        // 判断答案是否正确
        BOOL isOK = NO;
        if ([answerStr isEqualToString:question.answer]) {
            isOK = YES;
        }
        
        if (isOK) { //正确
            // 颜色置为绿色
            [self changeAnswersColor:[UIColor greenColor]];
            
            // 加钱
            [self changeScoreByAdding:1000];
            
            // 记录该页面已经完成
            question.isFinished = YES;
            
            // 延迟0.3s进入下一页
            [self performSelector:@selector(next:) withObject:nil afterDelay:0.3];
        } else {
            // 颜色置为红色
            [self changeAnswersColor:[UIColor redColor]];
        }
    }
}

- (void)changeAnswersColor:(UIColor *)color
{
    for (UIButton *button in _answerView.subviews) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }
}

- (void)changeScoreByAdding:(int)value
{
    NSString *scoreStr = _coin.currentTitle;
    NSUInteger currentScore = [scoreStr intValue];
    currentScore += value;
  
    // 因为titleLabel是只读的，必须通过setter方法来设置title
//    _coin.titleLabel.text = [@(currentScore) stringValue];
    [_coin setTitle:[@(currentScore) stringValue] forState:UIControlStateNormal];
}

@end
