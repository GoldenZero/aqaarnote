//
//  AlertButtonContainerView.h
//  AlertViewDemo
//
//  Created by ChrisXu on 13/9/25.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertView.h"

@interface AlertButtonContainerView : UIScrollView

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic) BOOL defaultTopLineVisible;

- (void)addButtonWithTitle:(NSString *)title type:(AlertViewButtonType)type handler:(AlertButtonHandler)handler;

@end
