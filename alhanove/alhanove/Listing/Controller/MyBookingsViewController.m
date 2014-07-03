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
#import "UIScrollView+SVPullToRefresh.h"
#import "BookingEntity.h"
#import "CarFormViewController.h"

@interface MyBookingsViewController (){
    
    NSMutableArray * bookingsArray;
    FormObject *formObj;
}

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
    
    [self.titleLabel setFont:[UIFont mediumGeSSOfSize:17]];

    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    bookingsArray=[[NSMutableArray alloc] initWithArray:[appDelegate getAllBookings]];
    [self.bookingsTable reloadData];
    
//    [self geAccessToken];
//    __block MyBookingsViewController* hvc = self;
//
//    //get bookings
//    [_bookingsTable addPullToRefreshWithActionHandler:^{
//        [[NetworkEngine getInstance] getLatestBookings:^(NSObject *o)
//         {
//             self.bookingsTable.hidden = NO;
//             
//             [hvc.bookingsTable.pullToRefreshView stopAnimating];
//             NSArray* temp = [NSArray arrayWithArray:(NSArray*)o];
//             
//             for (NSDictionary* dict in temp) {
//                 if (dict[@"pk"] != [NSNull null]){
//                     if ([dict[@"pickup_type"] isEqualToString:@"now"]) {
//                         [hvc.bookings insertObject:dict atIndex:0];
//                     }
//                     else{
//                         [hvc.bookings addObject:dict];
//                         
//                     }
//                     
//                 }
//             }
//             //hvc.bookings = [NSMutableArray arrayWithArray:self.bookings];
//         }
//                                          failureBlock:^(NSError *e)
//         {
//             if (e.code == 403 || e.code == 401) {
//                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"session_title", @"") message:NSLocalizedString(@"please_login", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
//                 alert.tag = 66;
//                 [alert show];
//                 return;
//             }else
//                 [hvc.bookingsTable.pullToRefreshView stopAnimating];
//         }];
//    }];
//    
//
//    _bookingsTable.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [_bookingsTable.pullToRefreshView setTitle:NSLocalizedString(@"booking_list_pull_to_refresh_loading", @"") forState:SVPullToRefreshStateLoading];
//    [_bookingsTable.pullToRefreshView setTitle:NSLocalizedString(@"booking_list_pull_to_refresh_pull", @"") forState:SVPullToRefreshStateStopped];
//    [_bookingsTable.pullToRefreshView setTitle:NSLocalizedString(@"booking_list_pull_to_refresh_release", @"") forState:SVPullToRefreshStateTriggered];
//    _bookingsTable.pullToRefreshView.titleLabel.font = [UIFont lightOpenSansOfSize:15];


}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showEditCarFormVC"])   //parameter to login page
    {
        
        CarFormViewController* vc = segue.destinationViewController;
        vc.form =formObj ;
    }

}


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
        return bookingsArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 353;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookingCell";
    BookingEntity* dictionary = [bookingsArray objectAtIndex:indexPath.row];
    
    BookingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BookingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BookingCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    cell.startPointLabel.text=dictionary.fromPlace;
    
    cell.endPointLabel.text=dictionary.toPlace;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    cell.dateLabel.text=[dateFormat stringFromDate:dictionary.fromDate];
    
    cell.timeLabel.text=[dateFormat stringFromDate:dictionary.toDate];
    
    cell.paymentLabel.text=[NSString stringWithFormat:@"%@", dictionary.carData.cost_all];
    
    cell.carTypeLabel.text= dictionary.carType;
    
    [cell.cancelButton addTarget:self action:@selector(cancelBooking:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.cancelButton.tag=indexPath.row;
    
    cell.continueButton.tag=indexPath.row;

    [cell.continueButton addTarget:self action:@selector(updateBooking:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}


-(void)cancelBooking:(UIButton*)sender
{
    UIButton* btn = (UIButton*)sender;
    NSInteger index = btn.tag;

//    NSDictionary* booking = _bookings[index];
//    __block NSInteger idx = index;
//    
//    NSString *message = NSLocalizedString(@"booking_cancel_confirmation_message", @"");
//    
//    NSInteger cancelFeeThreshold = 1;
//    if ( cancelFeeThreshold > 0 ) {
//        
//        NSString* pickupTime = booking[@"pickup_time"];
//        NSDate* pt = [pickupTime dateFromRFC3339String];
//        
//        NSTimeInterval diff = [pt timeIntervalSinceNow];
//        
//        if (diff > 0 && diff < (cancelFeeThreshold * 60)) {
//            message = [NSString stringWithFormat:NSLocalizedString(@"booking_cancel_cancellation_fee_warning_fmt", @""), cancelFeeThreshold];
//        }
//    }
//    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_confirmation_title", @"") message:[NSString stringWithFormat:@"%@ , %@",NSLocalizedString(@"booking_cancel_confirmation_message", @""),NSLocalizedString(@"booking_cancel_reason_hint", @"")] delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_yes", @"") otherButtonTitles:NSLocalizedString(@"dialog_button_no", @""), nil];
    alert.tag = index;
    [alert show];
    return;

}

-(void)updateBooking:(UIButton*)sender
{
    UIButton* btn = (UIButton*)sender;
    NSInteger index = btn.tag;
    BookingEntity *dic=[bookingsArray objectAtIndex:index];
    formObj=[[FormObject alloc] init];
    formObj.FromPlace=dic.fromPlace;
    formObj.ToPlace=dic.toPlace;
    formObj.fromDate=dic.fromDate;
    formObj.toDate=dic.toDate;
    formObj.FlightClass=dic.flightClass;
    formObj.FlightCost=[NSString stringWithFormat:@"%@", dic.flightCost];
    formObj.carType=dic.carType;
    formObj.CarData=dic.carData;
    formObj.UserAddress=dic.userAddress;
    formObj.UserEmail=dic.userEmail;
    formObj.UserMobile=dic.userMobile;
    formObj.UserName=dic.userName;
    formObj.MekkaHotelData=dic.mekkaHotel;
    formObj.MadinaHotelData=dic.madinaHotel;
    formObj.guestsNumber=[dic.guestsNumber intValue];
    formObj.roomsNumber=[dic.roomsNumber intValue];
    formObj.rentalDays=[dic.rentalDays intValue];
    formObj.bookingID=[dic.bookingID intValue];
    formObj.PassportImage=[UIImage imageWithData:dic.passportImage];
    formObj.PersonalImage=[UIImage imageWithData:dic.personalImage];
    [self performSegueWithIdentifier:@"showEditCarFormVC" sender:self];

    

}

-(void)geAccessToken
{
    if (![GenericMethods connectedToInternet])
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen];
        return;
    }
    [self downloadBookings];
}

- (void)downloadBookings
{
    self.bookings = [NSMutableArray new];

    //get last bookings
    [[NetworkEngine getInstance] getLatestBookings:^(NSObject *o) {
        NSArray* temp = [NSArray arrayWithArray:(NSArray*)o];
        
        for (NSDictionary* dict in temp) {
            if (dict[@"pk"] != [NSNull null]){
                if ([dict[@"pickup_type"] isEqualToString:@"now"]) {
                    [self.bookings insertObject:dict atIndex:0];
                }
                else{
                    [self.bookings addObject:dict];
                    
                }
                
            }
        }
        
        if ([self.bookings count] == 0) {
            self.bookingsTable.hidden = YES;
        }else
            [_bookingsTable reloadData];
    }
                                      failureBlock:^(NSError *e) {
                                          if (e.code == 403 || e.code == 401) {
                                              UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"session_title", @"") message:NSLocalizedString(@"please_login", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                                              alert.tag = 66;
                                              [alert show];
                                              return;
                                          }else
                                              self.bookingsTable.hidden = YES;
                                      }];
    
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {
        
    }

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (alertView.tag == 66) {
//            [UserSettings setAccessToken:nil];
//            [UserSettings setRefreshToken:nil];
            
            [self performSegueWithIdentifier:@"showLoginPage" sender:self];
        }
        else{
            
            if (buttonIndex == 0) {
                NSDictionary* booking = _bookings[alertView.tag];
                NSInteger index = alertView.tag;
                
                __block NSInteger idx = index;
                [self.managedObjectContext deleteObject:[bookingsArray objectAtIndex:index]];
                [bookingsArray removeObjectAtIndex:index];
                [self.bookingsTable reloadData];
/*
                [[NetworkEngine getInstance] cancelBooking:booking[@"id"]
                                    WithcancellationReason:self.reasonText.text
                                           completionBlock:^(NSObject *object) {
                                               [self.bookings removeObjectAtIndex:idx];
                                               [self.bookingsTable beginUpdates];
                                               [self.bookingsTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]]
                                                                        withRowAnimation:UITableViewRowAnimationAutomatic];
                                               [self.bookingsTable endUpdates];
                                               [self.bookingsTable reloadData];
                                               if ([self.bookings count] == 0) {
                                                   self.bookingsTable.hidden = YES;
                                               }
                                           }
                                              failureBlock:^(NSError *error) {
                                                  if (error.code == 403 || error.code == 401) {
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"session_title", @"") message:NSLocalizedString(@"please_login", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                                                      alert.tag = 66;
                                                      [alert show];
                                                      return;
                                                  }else{
                                                      self.bookingsTable.hidden = YES;
                                                      UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"dialog_error_title",@"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"dialog_button_ok", @"") otherButtonTitles:nil, nil];
                                                      [alert show];
                                                      return;
                                                  }
                                              }];
                if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] onErrorScreen]) {
                    
                }
             */   
            }
            else
                alertView.hidden = YES;
        }

}

@end
