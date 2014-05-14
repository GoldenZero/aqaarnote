//
//  ChoosePropertyVC.h
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddNewInspectionVC.h"

@protocol ChoosePropertyDelegate <NSObject>

@optional

- (void) chosenProperty:(PFObject*)property withImage:(PFObject*) img;

@end

@interface ChoosePropertyVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,InspectPropertyDelegate>

@property (strong, nonatomic) IBOutlet UITableView *propertiesTable;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIImageView *noInspecImg;

@property (nonatomic, strong) id <ChoosePropertyDelegate> delegate;

- (IBAction)cancelButtonPressed:(id)sender;

@end
