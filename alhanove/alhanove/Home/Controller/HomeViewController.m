//
//  HomeViewController.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    NSMutableArray* listMenu;
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    self.navigationController.title = @"الهنوف للحجوزات";
    //get the data for the menu
    [self getListMenuData];
    
    //reflect to the table
   // [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
-(void)getListMenuData
{
    listMenu = [NSMutableArray new];
    NSDictionary *MenuDict = @{@"Title" : @"حج",
                             @"Image" : @"badge1"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"عمرة",
                               @"Image" : @"badge2"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"طيران",
                               @"Image" : @"badge3"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"فنادق",
                               @"Image" : @"badge4"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"سيارات",
                               @"Image" : @"badge5"};
    [listMenu addObject:MenuDict];
    
}
//
//#pragma mark - UITableView
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//    
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [listMenu count];
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60.0;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"MenuCell";
//    NSDictionary* dictionary = [listMenu objectAtIndex:indexPath.row];
//    
//    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//
//        NSArray* topLevelObjects;
//            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
//        
//        cell = [topLevelObjects objectAtIndex:0];
//        
//    }
//    cell.titleLbl.text = dictionary[@"Title"];
//    [cell.menuImg setImage:[UIImage imageNamed:dictionary[@"Image"]]];
//    
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    //al haj
//    if (indexPath.row == 0) {
//        
//        [self performSegueWithIdentifier:@"showFormVC" sender:self];
//    }else if (indexPath.row == 1) {
//        [self performSegueWithIdentifier:@"showFormVC" sender:self];
//    }
//}

#pragma mark - storyBoard delegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
        if ([[segue identifier] isEqualToString:@"showMekkaListing"])   //parameter to login page
        {
            HotelListingViewController* vc = segue.destinationViewController;
            vc.listingType = ListingTypeMekka;
        }
}

#pragma mark - Buttons Actions
- (IBAction)oumraBtnPrss:(id)sender {
    [self performSegueWithIdentifier:@"showFormVC" sender:self];

}

- (IBAction)hajBtnPrss:(id)sender {
    [self performSegueWithIdentifier:@"showFormVC" sender:self];

}

- (IBAction)carsBtnPrss:(id)sender {
    
    [self performSegueWithIdentifier:@"showCarFormVC" sender:self];

    /*
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"هذه الخدمة غير متوفرة حاليا" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;
     */
}

- (IBAction)flightBtnPrss:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"هذه الخدمة غير متوفرة حاليا" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

- (IBAction)hotelsBtnPrss:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"هذه الخدمة غير متوفرة حاليا" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;
}

- (IBAction)bookingsBtnPrss:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"هذه الخدمة غير متوفرة حاليا" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    [alert show];
    return;
}
@end
