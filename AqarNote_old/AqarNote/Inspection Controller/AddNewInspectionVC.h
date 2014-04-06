//
//  AddNewInspectionVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowseInspectionVC.h"

@interface AddNewInspectionVC : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *sectionScrollView;
@property (strong, nonatomic) IBOutlet UILabel *propertyTitle;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) PFObject* propertyID;
@property (strong, nonatomic) NSArray* PropArr;

@property (strong, nonatomic) IBOutlet UITextView *notesTxtView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *imgScrollView;

- (IBAction)uploadImagePressed:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;
@end
