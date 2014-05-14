//
//  AlertViewController.h
//  AlertViewDemo
//
//  Created by ChrisXu on 13/9/12.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertView.h"

@interface AlertViewController : UIViewController

@property (nonatomic, strong) AlertView *alertView;

@property (nonatomic, assign) BOOL rootViewControllerPrefersStatusBarHidden;

@end
