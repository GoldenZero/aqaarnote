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
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@property (strong, nonatomic) IBOutlet UIView *starsView;
@property (strong, nonatomic) IBOutlet UITextView *locationTxtView;

@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UITextView *describTxtView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
#pragma mark - Buttons Actions
- (IBAction)backBtnPrss:(id)sender;

- (IBAction)nextBtnPrss:(id)sender;
- (IBAction)contiueBtnPrss:(id)sender;
@end
