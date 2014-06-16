//
//  SearchDetailsVC.h
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDetailDelegate <NSObject>

@optional

- (void) chosenPlace:(NSString*)place;

@end

@interface SearchDetailsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

#pragma mark - Properties

@property (strong, nonatomic) IBOutlet UITableView *searchsTableView;
@property (nonatomic, strong) id <SearchDetailDelegate> delegate;

#pragma mark - Buttons Actions
- (IBAction)backButtonPressed:(id)sender;

@end

