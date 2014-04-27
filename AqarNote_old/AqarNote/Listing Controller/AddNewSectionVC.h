//
//  AddNewSectionVC.h
//  AqarNote
//
//  Created by Noor on 4/27/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewSectionVC : UIViewController<UITextFieldDelegate>

#pragma mark - Properties 

@property (strong, nonatomic) IBOutlet UITextField *sectionNameTxt;


#pragma mark - Actions
- (IBAction)saveBtnPrss:(id)sender;
- (IBAction)cancelBtnPrss:(id)sender;
- (IBAction)addSectionBtnPrss:(id)sender;


@end
