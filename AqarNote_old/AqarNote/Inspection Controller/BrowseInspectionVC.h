//
//  BrowseInspectionVC.h
//  AqarNote
//
//  Created by GALMarei on 2/4/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCDFormInputAccessoryView.h"

@interface BrowseInspectionVC : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    
}
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;

@property (strong, nonatomic) IBOutlet UILabel *sectionTitle;
@property (strong, nonatomic) PFObject* sectionID;
@property (strong, nonatomic) PFObject* propertyID;
@property (strong, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) NSArray* PropArr;
@property (strong, nonatomic) IBOutlet UIButton *uploadImageBtn;

- (IBAction)uploadImagePressed:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (IBAction)backButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)chooseStatusPressed:(id)sender;
@end
