//
//  SHMenu.m
//  SHMenu
//
//  Created by 宋浩文的pro on 16/4/15.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "SHMenu.h"

#define ZoomAnimationDuration 0.3


@interface SHBoardView ()

@end

@implementation SHBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(SHBoardViewIsTouched:)]) {
        [self.delegate SHBoardViewIsTouched:self];
    }
}

+ (instancetype)getBoardView
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

@end






@interface SHMenu ()<SHBoardViewDelegate>

@property (nonatomic, strong) UIImageView *containerView;

@property (nonatomic, strong) SHBoardView *boardView;

@end

@implementation SHMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.containerView = [[UIImageView alloc] init];
        self.containerView.userInteractionEnabled = YES;
        self.containerView.image = [UIImage imageNamed:@"home_menubackground"];
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.containerView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.containerView];
        
    }
    return self;
}

// 从view下面显示menu
- (void)showFromView:(UIView *)view
{
    CGFloat x = view.center.x;
    CGFloat y = CGRectGetMaxY(view.frame);
    [self showFromPoint:CGPointMake(x, y)];
}

// 从某个点显示menu
- (void)showFromPoint:(CGPoint)point
{
    if (_state == MenuShow) return;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:ZoomAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.boardView.alpha = 0.2;
    }];
    
    // frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
    // frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
    self.layer.position = CGPointMake(self.layer.anchorPoint.x * self.frame.size.width + point.x, self.layer.anchorPoint.y * self.frame.size.height + point.y);
    
    _state = MenuShow;
}

// 隐藏menu
- (void)hideMenu
{
    [UIView animateWithDuration:ZoomAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.boardView.alpha = 0;
    }];
    
    _state = MenuDismiss;
}

#pragma mark - 遮罩代理方法
- (void)SHBoardViewIsTouched:(SHBoardView *)SHBoardView
{
    [self hideMenu];
}

#pragma mark - setter && getter
/** 给Menu传一个内容 */
- (void)setContent:(UIView *)content
{
    _content = content;
    
    content.frame = self.containerView.frame;
    [self.containerView addSubview:content];
}

/** 给Menu传一个内容控制器 */
- (void)setContentVC:(UIViewController *)contentVC
{
    _contentVC = contentVC;
    
    self.content = contentVC.view;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    self.layer.anchorPoint = anchorPoint;
}

- (void)setBackgroundImage:(NSString *)backgroundImage
{
    _backgroundImage = backgroundImage;
    
    self.containerView.image = [UIImage imageNamed:backgroundImage];
}

- (void)setContentOrigin:(CGPoint)contentOrigin
{
    _contentOrigin = contentOrigin;
    // 改变内容view的偏移
    CGRect frame = _content.frame;
    frame.origin = contentOrigin;
    _content.frame = frame;
}

- (SHBoardView *)boardView
{
    if (_boardView == nil) {
        _boardView = [SHBoardView getBoardView];
        _boardView.alpha = 0;
        _boardView.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window insertSubview:_boardView belowSubview:self];
    }
    return _boardView;
}

@end
