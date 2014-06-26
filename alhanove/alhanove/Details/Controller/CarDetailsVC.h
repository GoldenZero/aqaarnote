//
//  CarDetailsVC.h
//  alhanove
//
//  Created by GALMarei on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGPhotoBrowserView.h"

@interface CarDetailsVC : UIViewController<AGPhotoBrowserDataSource,AGPhotoBrowserDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

#pragma mark -Properties
@property (nonatomic, strong) AGPhotoBrowserView *browserView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *hotelTitle;

@property (strong, nonatomic) IBOutlet UIView *starsView;
@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UITableView *featuresTableView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UILabel *reviewLabel;
@property (strong, nonatomic) CarEntity *carDetails;

@property (strong, nonatomic) NSMutableArray *pageImages;
@property (strong,nonatomic) NSString *hotelName;
@property (strong,nonatomic) NSString *hotelCost;
@property (strong,nonatomic) NSString *carLocation;
@property (strong, nonatomic) IBOutlet UILabel *titlesScreen;

#pragma mark - Buttons Actions
- (IBAction)backBtnPrss:(id)sender;
- (IBAction)nextBtnPrss:(id)sender;
- (IBAction)contiueBtnPrss:(id)sender;

@end
