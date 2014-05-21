//
//  HotelDetailsVC.h
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"
#import "AGPhotoBrowserView.h"

@interface HotelDetailsVC : UIViewController<UIScrollViewDelegate,DYRateViewDelegate,AGPhotoBrowserDataSource,AGPhotoBrowserDelegate>

#pragma mark -Properties
@property (nonatomic, strong) AGPhotoBrowserView *browserView;


#pragma mark - Buttons Actions
- (IBAction)backBtnPrss:(id)sender;

- (IBAction)nextBtnPrss:(id)sender;
@end
