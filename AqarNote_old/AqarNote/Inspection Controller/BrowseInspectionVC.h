//
//  BrowseInspectionVC.h
//  AqarNote
//
//  Created by GALMarei on 2/4/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCDFormInputAccessoryView.h"
#import "BaseViewController.h"
#import "AGPhotoBrowserView.h"

@interface BrowseInspectionVC : BaseViewController<UINavigationControllerDelegate,UIScrollViewDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,AGPhotoBrowserDelegate, AGPhotoBrowserDataSource>
{
    MBProgressHUD *HUD;
    
}
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UILabel *sectionTitle;
@property (strong, nonatomic) PFObject* sectionID;
@property (strong, nonatomic) PFObject* propertyID;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) NSArray* PropArr;
@property (strong, nonatomic) IBOutlet UIButton *uploadImageBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *pagingScrollView;
@property (strong, nonatomic) IBOutlet UIButton *fairButton;
@property (strong, nonatomic) IBOutlet UIButton *dirtyButton;
@property (strong, nonatomic) IBOutlet UIButton *noticeButton;
@property (strong, nonatomic) IBOutlet UIButton *goodButton;
@property (strong, nonatomic) IBOutlet UIButton *cleanButton;
@property (strong, nonatomic) IBOutlet UIButton *buttonBroken;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIButton *addImgBtnPrss;
@property (strong, nonatomic) IBOutlet UIButton *deleteImgButton;
@property (strong, nonatomic) IBOutlet UIButton *nextImgButton;
@property (strong, nonatomic) IBOutlet UIButton *prevImgButton;

@property (nonatomic, strong) AGPhotoBrowserView *browserView;

- (IBAction)deleteImgBtnPrss:(id)sender;
- (IBAction)uploadImagePressed:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)chooseStatusPressed:(id)sender;
- (IBAction)buttonBrokenPrss:(id)sender;
- (IBAction)nxtImgBtnPrss:(id)sender;
- (IBAction)prevImgBtnPrss:(id)sender;
@end
