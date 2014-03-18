//
//  NotesVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotesVC : UIViewController

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

#pragma mark - Actions
- (IBAction)logoutBtnPrss:(id)sender;

@end
