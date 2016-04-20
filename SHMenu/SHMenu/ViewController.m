//
//  ViewController.m
//  SHMenu
//
//  Created by 宋浩文的pro on 16/4/15.
//  Copyright © 2016年 宋浩文的pro. All rights reserved.
//

#import "ViewController.h"
#import "MenuContentViewController.h"
#import "SHMenu.h"

@interface ViewController ()<MenuContentViewControllerDelegate>

@property (nonatomic, strong) SHMenu *menu;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)popMenu:(id)sender {
    
    MenuContentViewController *menuVC = [[MenuContentViewController alloc] init];
    menuVC.delegate = self;
    SHMenu *menu = [[SHMenu alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    _menu = menu;
    menu.contentVC = menuVC;
    menu.anchorPoint = CGPointMake(1, 0);
    menu.contentOrigin = CGPointMake(0, 8);
    [menu showFromPoint:CGPointMake(100, 100)];
    
}

- (void)menuController:(MenuContentViewController *)menuController clickAtRow:(NSUInteger)index
{
    NSLog(@"%ld", index);
    [_menu hideMenu];
}




@end
