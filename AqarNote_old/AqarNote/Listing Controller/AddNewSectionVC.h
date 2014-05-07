//
//  AddNewSectionVC.h
//  AqarNote
//
//  Created by Noor on 4/27/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddSectionDelegate <NSObject>

@optional

- (void) addedSection:(NSString*) sectionName;

@end


@interface AddNewSectionVC : UIViewController<UITextFieldDelegate>

#pragma mark - Properties 

@property (strong, nonatomic) IBOutlet UITextField *sectionNameTxt;

@property (nonatomic, weak) id <AddSectionDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;


#pragma mark - Actions
- (IBAction)saveBtnPrss:(id)sender;
- (IBAction)cancelBtnPrss:(id)sender;
- (IBAction)addSectionBtnPrss:(id)sender;

@end
