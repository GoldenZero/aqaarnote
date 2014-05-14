//
//  AlertItem.h
//  AlertViewDemo
//
//  Created by ChrisXu on 13/9/12.
//  Copyright (c) 2013年 ChrisXu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AlertView.h"
typedef NS_ENUM(NSInteger, AlertViewButtonType) {
    AlertViewButtonTypeDefault = 0,
    AlertViewButtonTypeCustom = 1,
    AlertViewButtonTypeCancel = 2
};

@class AlertView;
@class AlertButtonItem;
typedef void(^AlertButtonHandler)(AlertView *alertView, AlertButtonItem *button);

@interface AlertButtonItem : UIButton


@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) AlertViewButtonType type;
@property (nonatomic, copy) AlertButtonHandler action;
@property (nonatomic) BOOL defaultRightLineVisible;

@end
