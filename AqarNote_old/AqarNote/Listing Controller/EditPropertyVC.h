//
//  EditPropertyVC.h
//  AqarNote
//
//  Created by Noor on 5/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnhancedKeyboard.h"
#import "AddNewSectionVC.h"
#import "AGPhotoBrowserView.h"
#import "SBPickerSelector.h"

@protocol EditPropertyDelegate <NSObject>

@optional

- (void) editedProperty:(PFObject*) property withImages:(NSArray*) image andSections:(NSArray*)sections;

@end


@interface EditPropertyVC : UIViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITextFieldDelegate,MBProgressHUDDelegate,EnhancedKeyboardDelegate,SBPickerSelectorDelegate,AddSectionDelegate,AGPhotoBrowserDataSource,AGPhotoBrowserDelegate>
{
    MBProgressHUD *loadingIndicator;
    EnhancedKeyboard *enhancedKeyboard;
    SBPickerSelector *countriesPicker ;
    UIActionSheet *photoAction;
}

#pragma mark - Properties 
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *screenLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (strong, nonatomic) IBOutlet UITextField *cityTxtField;
@property (strong, nonatomic) IBOutlet UITextField *propertyTitleTxtField;
@property (strong, nonatomic) IBOutlet UITextField *countryTxtField;
@property (strong, nonatomic) IBOutlet UILabel *sectionsLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (strong, nonatomic) IBOutlet UIButton *uploadPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *nxtPhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *prevPhotoButton;

#pragma mark - Actions
- (IBAction)addNewSection:(id)sender;
- (IBAction)saveBtnPrss:(id)sender;
- (IBAction)cancelBtnPrss:(id)sender;
- (IBAction)countryBtnPrss:(id)sender;
- (IBAction)uploadPhotoBtnPrss:(id)sender;
- (IBAction)nxtPhotoBtnPrss:(id)sender;
- (IBAction)prevPhotoBtnPrss:(id)sender;

#pragma mark - Objects
@property (strong, nonatomic) PFObject* propertyID;
@property (strong, nonatomic) NSArray * propertyImages;
@property (nonatomic, strong) AGPhotoBrowserView *browserView;
@property (nonatomic, strong) id <EditPropertyDelegate> delegate;

@end
