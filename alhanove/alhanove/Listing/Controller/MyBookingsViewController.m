//
//  MyBookingsViewController.m
//  alhanove
//
//  Created by Noor on 6/19/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "MyBookingsViewController.h"
#import "FormObject.h"
#import "BookingCell.h"

@interface MyBookingsViewController ()

@end

@implementation MyBookingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark table view source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _bookings.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 353;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"historyTableViewCell";
    
    NSDictionary* booking = [_bookings objectAtIndex:indexPath.row];
    
    BookingCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell){
        cell = [[BookingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray* topLevelObjects;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Default_Language"] isEqualToString:@"ar"])
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ActiveBookingCell" owner:self options:nil];
        else
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ActiveBookingCell_en" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
    }

    
    [cell.cancelButton addTarget:self action:@selector(cancelBooking:) forControlEvents:UIControlEventTouchUpInside];

    [cell.continueButton addTarget:self action:@selector(updateBooking:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

@end
