//
//  CallUsViewController.h
//  AqarNote
//
//  Created by GALMarei on 2/5/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CallUsViewController : UIViewController<MFMailComposeViewControllerDelegate>

- (IBAction)sendMailPressed:(id)sender;
@end
