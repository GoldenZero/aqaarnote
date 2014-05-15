//
//  AddNewInspectionVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseInspectionVC.h"
#import "EnhancedKeyboard.h"
#import "AGPhotoBrowserView.h"
#import "BrowseInspectionVC.h"
#import "EditPropertyVC.h"

@protocol InspectPropertyDelegate <NSObject>

@optional

- (void) InspectedProperty:(PFObject*)propertyInspect WithImage:(PFObject*) img;

@end
@interface AddNewInspectionVC : UIViewController<UINavigationControllerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate,EnhancedKeyboardDelegate,AGPhotoBrowserDelegate, AGPhotoBrowserDataSource,InspectSectionDelegate,EditPropertyDelegate>
{
    MBProgressHUD *HUD1;
    MBProgressHUD *HUD2;
    
}
@property (strong, nonatomic) IBOutlet UILabel *screenLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *sectionScrollView;
@property (strong, nonatomic) IBOutlet UILabel *propertyTitle;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) PFObject* propertyID;
@property (strong, nonatomic) NSArray* PropArr;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property BOOL isInspection;
@property (strong, nonatomic) IBOutlet UITextView *notesTxtView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *imgScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *noteBgImg;
@property (strong, nonatomic) IBOutlet UILabel *sectionsLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextImgButton;
@property (strong, nonatomic) IBOutlet UIButton *prevImgButton;

@property (nonatomic, strong) AGPhotoBrowserView *browserView;

@property (nonatomic, strong) id <InspectPropertyDelegate> delegate;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
- (IBAction)nxtImgBtnPrss:(id)sender;
- (IBAction)prevImgBtnPrss:(id)sender;
@end
