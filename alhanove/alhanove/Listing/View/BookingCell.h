//
//  BookingCell.h
//  alhanove
//
//  Created by Noor on 6/19/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingCell : UITableViewCell

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *startPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *endPointLabel;
@property (strong, nonatomic) IBOutlet UILabel *carTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UILabel *paymentLabel;
@property (strong, nonatomic) IBOutlet UILabel *costLabel;
@property (strong, nonatomic) IBOutlet UILabel *bookingNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UILabel *carHeaderLabel;
@property (strong, nonatomic) IBOutlet UIImageView *carHeaderImage;

//headers
@property (strong, nonatomic) IBOutlet UILabel *pickupHead;
@property (strong, nonatomic) IBOutlet UILabel *dropoffHead;
@property (strong, nonatomic) IBOutlet UILabel *priceHead;
@property (strong, nonatomic) IBOutlet UILabel *noteHead;
@property (strong, nonatomic) IBOutlet UILabel *carTypeHead;
@property (strong, nonatomic) IBOutlet UILabel *bookNumHead;
@property (strong, nonatomic) IBOutlet UILabel *toDate;
@property (strong, nonatomic) IBOutlet UILabel *fromDate;
@property (strong, nonatomic) IBOutlet UILabel *acLabel;
@property (strong, nonatomic) IBOutlet UILabel *autoLabel;
@property (strong, nonatomic) IBOutlet UILabel *passengersLabel;

@property (strong, nonatomic) IBOutlet UILabel *doorsLabel;
@end
