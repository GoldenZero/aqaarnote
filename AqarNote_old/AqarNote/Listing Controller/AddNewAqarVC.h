//
//  AddNewAqarVC.h
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewAqarVC : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

{
    MBProgressHUD *HUD;

}
@property (strong, nonatomic) IBOutlet UITextField *propertyTitle;
@property (strong, nonatomic) IBOutlet UITextField *country;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UIButton *uploadImageBtn;
@property (strong, nonatomic) IBOutlet UITableView *sectionsTableView;
@property (strong, nonatomic) IBOutlet UITextField *countryCodeTxt;

- (IBAction)uploadImagePressed:(id)sender;
- (void)uploadImage:(NSData *)imageData;
- (void)setUpImages:(NSArray *)images;
- (IBAction)addButtonPressed:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)addSectionBtnPrss:(id)sender;
@end
