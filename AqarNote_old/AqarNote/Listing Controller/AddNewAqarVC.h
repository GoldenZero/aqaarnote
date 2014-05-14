//
//  AddNewAqarVC.h
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnhancedKeyboard.h"
#import "BaseViewController.h"
#import "AddNewSectionVC.h"
#import "EditSectionVC.h"
#import "AGPhotoBrowserView.h"
#import "SBPickerSelector.h"

@protocol AddPropertyDelegate <NSObject>

@optional

- (void) addedProperty:(PFObject*) property withImage:(PFObject*) image;

@end

@interface AddNewAqarVC :BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,EnhancedKeyboardDelegate,UIScrollViewDelegate,AddSectionDelegate,EditSectionDelegate,AGPhotoBrowserDelegate, AGPhotoBrowserDataSource,SBPickerSelectorDelegate,UIActionSheetDelegate>

{
    MBProgressHUD *HUD;

}
@property (strong, nonatomic) IBOutlet UITextView *descriptionsTxtView;
@property (strong, nonatomic) IBOutlet UITextField *propertyTitle;
@property (strong, nonatomic) IBOutlet UITextField *country;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UIButton *uploadImageBtn;
@property (strong, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (strong, nonatomic) IBOutlet UIButton *showPickerButton;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) PFObject* propertyID;
@property BOOL isEditable;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UIButton *addImgesButton;
@property (strong, nonatomic) IBOutlet UIButton *deletePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *nextImgButton;
@property (strong, nonatomic) IBOutlet UIButton *prevImgButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *sesctionsLabel;

@property (nonatomic, strong) AGPhotoBrowserView *browserView;

@property (nonatomic, strong) id <AddPropertyDelegate> delegate;


- (IBAction)openCountryPickerBtnPrss:(id)sender;
- (IBAction)uploadImagePressed:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (IBAction)addButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)addSectionBtnPrss:(id)sender;
- (IBAction)deletePhotoBtnPrss:(id)sender;
- (IBAction)nxtImgBtnPrss:(id)sender;
- (IBAction)prevImgBtnPrss:(id)sender;
@end
