//
//  EditSectionVC.h
//  AqarNote
//
//  Created by Noor on 4/27/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditSectionDelegate <NSObject>

@optional

- (void) editedSection:(NSString*) sectionName withID:(int) index;

@end

@interface EditSectionVC : UIViewController<UITextFieldDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UITextField *sectionNameTxt;
@property (strong, nonatomic) NSString * sectionName;
@property int sectionIndex;

@property (nonatomic, weak) id <EditSectionDelegate> delegate;

#pragma mark - Actions
- (IBAction)editBtnPrss:(id)sender;
- (IBAction)cancelBtnPrss:(id)sender;

@end
