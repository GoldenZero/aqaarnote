//
//  CarUserDataViewController.m
//  alhanove
//
//  Created by GALMarei on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarUserDataViewController.h"
@interface CarUserDataViewController ()
{
    BOOL imageForPassport;
    
    BOOL isUpdating;
    
    EnhancedKeyboard *enhancedKeyboard;
    SBPickerSelector *BookDatePicker;
    
    NSDate* chosenDate;
    UIImage* passportImage;
    UIImage* personalImage;
    
    BOOL isInsuranceAccepted;
    BOOL isGPSAccepted;
    BOOL isChildAccepted;

}
@end

@implementation CarUserDataViewController

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
    
    //1
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;
    
    if ([[UIScreen mainScreen] bounds].size.height != 568){
        self.mainScrollView.contentSize = CGSizeMake(320, 568);
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    self.PriceLbl.text = [NSString stringWithFormat:@"%@ ريال",self.formObj.carCost];
    [self.dateBtn setTitle:[dateFormat stringFromDate:self.formObj.fromDate] forState:UIControlStateNormal];
    
    // Set Custom font
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    [self.homeButton.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
    
    //[self.dateBtn.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
    [self.passportAttachBtn.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
    [self.personalImgAttachBtn.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
    [self.payNowBtn.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
    [self.payLaterBtn.titleLabel setFont:[UIFont mediumGeSSOfSize:12]];
    
    [self.NameText setFont:[UIFont lightGeSSOfSize:12]];
    [self.AddressText setFont:[UIFont lightGeSSOfSize:12]];
    [self.EmailText setFont:[UIFont lightGeSSOfSize:12]];
    [self.MobileText setFont:[UIFont lightGeSSOfSize:12]];
    [self.dateLbl setFont:[UIFont lightGeSSOfSize:12]];
    [self.TotalLbl setFont:[UIFont lightGeSSOfSize:12]];
    //[self.PriceLbl setFont:[UIFont lightGeSSOfSize:12]];
    
    if (self.formObj.UserName!=nil) {
        isUpdating=YES;
        self.NameText.text=self.formObj.UserName;
    }
    
    if (self.formObj.UserEmail!=nil) {
        self.EmailText.text=self.formObj.UserEmail;
    }
    
    if (self.formObj.UserAddress!=nil) {
        self.AddressText.text=self.formObj.UserAddress;
    }
    
    if (self.formObj.UserMobile!=nil) {
        self.MobileText.text=self.formObj.UserMobile;
    }
    //prepare the pickers
    [self preparePickers];
}

#pragma mark - Methods
-(void)preparePickers
{
    BookDatePicker = [SBPickerSelector picker];
    BookDatePicker.tag = 0;
    BookDatePicker.pickerType = SBPickerSelectorTypeDate;
    BookDatePicker.datePickerType=SBPickerSelectorDateTypeOnlyDay;
    BookDatePicker.delegate = self;
    BookDatePicker.doneButtonTitle = @"تم";
    BookDatePicker.cancelButtonTitle = @"إلغاء";
    
}

#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)homeInvoked:(id)sender
{
    [self performSegueWithIdentifier:@"BackToHome" sender:self];
}

- (IBAction)showDateInvoked:(id)sender
{
    [BookDatePicker showPickerOver:self];
}

- (IBAction)passportAttachInvoked:(id)sender
{
    imageForPassport = YES;
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"إلغاء"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"من الكاميرا", @"من مكتبة الصور", nil];
    
    [as showInView:self.view];
}

- (IBAction)personalImgInvoked:(id)sender
{
    imageForPassport = NO;
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"إلغاء"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"من الكاميرا", @"من مكتبة الصور", nil];
    
    [as showInView:self.view];
}

- (IBAction)payNowInvoked:(id)sender
{
    if ([self checkFields]) {
        [self initializeFormObject];
        [self performSegueWithIdentifier:@"showCarPayNow" sender:self];

    }
}

- (IBAction)payLaterInvoked:(id)sender
{
    if ([self checkFields]) {
        [self initializeFormObject];
        [self performSegueWithIdentifier:@"showPayLater" sender:self];
    }
}

-(void)InsuranceCheckPressed:(id)sender
{
    if (!isInsuranceAccepted) {
        self.checkInsuranceBtn.selected = YES;
        [self.checkInsuranceBtn setImage:[UIImage imageNamed:@"btn_check_on_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isInsuranceAccepted = YES;
        //add value to total
        NSInteger temp = [self.formObj.carCost integerValue];
        temp += 250;
        self.formObj.carCost = [NSString stringWithFormat:@"%li",temp];
        self.PriceLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ ريال",self.formObj.carCost ]];
        
    }else
    {
        self.checkInsuranceBtn.selected = NO;
        [self.checkInsuranceBtn setImage:[UIImage imageNamed:@"btn_check_off_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isInsuranceAccepted = NO;
        //remove value to total
        NSInteger temp = [self.formObj.carCost integerValue];
        temp -= 250;
        self.formObj.carCost = [NSString stringWithFormat:@"%li",temp];
        self.PriceLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ ريال",self.formObj.carCost ]];

    }
}

-(void)GPSCheckPressed:(id)sender
{
    if (!isGPSAccepted) {
        self.checkGPSBtn.selected = YES;
        [self.checkGPSBtn setImage:[UIImage imageNamed:@"btn_check_on_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isGPSAccepted = YES;
        //add value to total
        NSInteger temp = [self.formObj.carCost integerValue];
        temp += 50;
        self.formObj.carCost = [NSString stringWithFormat:@"%li",temp];
        self.PriceLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ ريال",self.formObj.carCost ]];

    }else
    {
        self.checkGPSBtn.selected = NO;
        [self.checkGPSBtn setImage:[UIImage imageNamed:@"btn_check_off_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isGPSAccepted = NO;
        //remove value to total
        NSInteger temp = [self.formObj.carCost integerValue];
        temp -= 50;
        self.formObj.carCost = [NSString stringWithFormat:@"%li",temp];
        self.PriceLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ ريال",self.formObj.carCost ]];
        
    }
}

-(void)ChildCheckPressed:(id)sender
{
    if (!isChildAccepted) {
        self.checkChildBtn.selected = YES;
        [self.checkChildBtn setImage:[UIImage imageNamed:@"btn_check_on_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isChildAccepted = YES;
        //add value to total
        NSInteger temp = [self.formObj.carCost integerValue];
        temp += 25;
        self.formObj.carCost = [NSString stringWithFormat:@"%li",temp];
        self.PriceLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ ريال",self.formObj.carCost ]];

    }else
    {
        self.checkChildBtn.selected = NO;
        [self.checkChildBtn setImage:[UIImage imageNamed:@"btn_check_off_focused_holo_light.png"] forState:UIControlStateHighlighted];
        isChildAccepted = NO;
        //remove value to total
        NSInteger temp = [self.formObj.carCost integerValue];
        temp -= 25;
        self.formObj.carCost = [NSString stringWithFormat:@"%li",temp];
        self.PriceLbl.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@ ريال",self.formObj.carCost ]];
        
    }
}

#pragma mark - FormObj
-(void)initializeFormObject
{
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    self.formObj.UserName = self.NameText.text;
    self.formObj.UserAddress = self.AddressText.text;
    self.formObj.UserEmail = self.EmailText.text;
    self.formObj.UserMobile = self.MobileText.text;
    self.formObj.PassportImage = passportImage;
    self.formObj.PersonalImage = personalImage;
    self.formObj.BookingDate = chosenDate;
    [self saveFormData];
}


#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)doneDidTouchDown
{
    if ([self.NameText isEditing]) {
        [self.NameText resignFirstResponder];
    }
    
    else if ([self.AddressText isEditing]) {
        [self.AddressText resignFirstResponder];
    }
    else if ([self.AddressText isEditing]) {
        [self.AddressText resignFirstResponder];
    }
    else if ([self.EmailText isEditing]) {
        [self.EmailText resignFirstResponder];
    }
    else if ([self.MobileText isEditing]) {
        [self.MobileText resignFirstResponder];
    }
    
    
}

#pragma mark - UIActionSheetDelegate Method
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([@"من الكاميرا" isEqualToString:buttonTitle]) {
        [self takePhotoWithCamera];
    }
    else if ([@"من مكتبة الصور" isEqualToString:buttonTitle]) {
        [self selectPhotoFromLibrary];
    }
}


#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (imageForPassport){
        //[self.passportAttachBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.passportAttachBtn setSelected:YES];
        passportImage = image;
    }
    else{
        //[self.personalImgAttachBtn setBackgroundImage:image forState:UIControlStateNormal];
        [self.personalImgAttachBtn setSelected:YES];
        personalImage = image;
    }
    
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData forPassport:imageForPassport];
}

- (void)uploadImage:(NSData *)imageData forPassport:(BOOL)forPassport
{
    
}

-(void) takePhotoWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) selectPhotoFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}



#pragma mark - UIPicker
//if your piker is a traditional selection
-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date
{
    if (selector.tag == 0) {
        chosenDate = date;
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        [self.dateBtn setTitle:[df stringFromDate:date] forState:UIControlStateNormal];
        
    }
}

//when picker value is changing
-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx
{
    
}

//if the user cancel the picker
-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel
{
    
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


-(void)saveFormData
{
    NSError *error;

    if (isUpdating) {
        
        
        NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"BookingEntity"];
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bookingID==%@",[NSNumber numberWithInt:self.formObj.bookingID]];
        fetchRequest.predicate=predicate;
        
        NSManagedObject *newEntry=[[self.managedObjectContext executeFetchRequest:fetchRequest error:nil] firstObject];
    
        [newEntry setValue:self.formObj.MekkaHotelData forKey:@"mekkaHotel"];
        //newEntry.mekkaHotel=self.formObj.MekkaHotelData;
        [newEntry setValue:self.formObj.MadinaHotelData forKey:@"madinaHotel"];
        //newEntry.madinaHotel=self.formObj.MadinaHotelData;
        [newEntry setValue:self.formObj.BookingType forKey:@"bookingType"];
        //newEntry.bookingType=self.formObj.BookingType;
        [newEntry setValue:self.formObj.fromDate forKey:@"fromDate"];
        //newEntry.fromDate=self.formObj.fromDate;
        [newEntry setValue:self.formObj.toDate forKey:@"toDate"];
        //newEntry.toDate=self.formObj.toDate;
        [newEntry setValue:self.formObj.FlightClass forKey:@"flightClass"];
        //newEntry.flightClass=self.formObj.FlightClass;
        [newEntry setValue:[NSNumber numberWithInteger:[self.formObj.FlightCost integerValue]] forKey:@"flightCost"];
        //newEntry.flightCost=[NSNumber numberWithInteger:[self.formObj.FlightCost integerValue]];
        [newEntry setValue:[NSNumber numberWithInteger:self.formObj.guestsNumber] forKey:@"guestsNumber"];
        //newEntry.guestsNumber=[NSNumber numberWithInt:self.formObj.guestsNumber];
        [newEntry setValue:[NSNumber numberWithInteger:self.formObj.roomsNumber] forKey:@"roomsNumber"];
        //newEntry.roomsNumber=[NSNumber numberWithInt:self.formObj.roomsNumber];
        [newEntry setValue:[NSNumber numberWithInteger:self.formObj.rentalDays] forKey:@"rentalDays"];
        //newEntry.rentalDays=[NSNumber numberWithInteger:self.formObj.rentalDays];
        [newEntry setValue:[NSNumber numberWithInt:self.formObj.bookingID] forKey:@"bookingID"];
        //newEntry.bookingID=[NSNumber numberWithInteger:self.formObj.bookingID];

        [newEntry setValue:self.formObj.UserName forKey:@"userName"];
        //newEntry.userName=self.formObj.UserName;
        [newEntry setValue:self.formObj.UserAddress forKey:@"userAddress"];
        //newEntry.userAddress=self.formObj.UserAddress;
        [newEntry setValue:self.formObj.UserEmail forKey:@"userEmail"];
        //newEntry.userEmail=self.formObj.UserEmail;
        [newEntry setValue:self.formObj.UserMobile forKey:@"userMobile"];
        //newEntry.userMobile=self.formObj.UserMobile;
        [newEntry setValue:self.formObj.BookingDate forKey:@"bookingDate"];
        //newEntry.bookingDate=self.formObj.BookingDate;
        
        [newEntry setValue:UIImagePNGRepresentation(self.formObj.PassportImage) forKey:@"passportImage"];
        //newEntry.passportImage=UIImagePNGRepresentation(self.formObj.PassportImage);
        [newEntry setValue:UIImagePNGRepresentation(self.formObj.PersonalImage) forKey:@"personalImage"];
        //newEntry.personalImage=UIImagePNGRepresentation(self.formObj.PersonalImage);
        
        [newEntry setValue:self.formObj.FromPlace forKey:@"fromPlace"];
        //newEntry.fromPlace=self.formObj.FromPlace;
        [newEntry setValue:self.formObj.ToPlace forKey:@"toPlace"];
        //newEntry.toPlace=self.formObj.ToPlace;
        [newEntry setValue:self.formObj.CarData forKey:@"carData"];
        //newEntry.carData=self.formObj.CarData;
        [newEntry setValue:self.formObj.carType forKey:@"carType"];
        //newEntry.carType=self.formObj.carType;

        if (![[self managedObjectContext] save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
    }
    else{
        self.formObj.bookingID= rand();
        BookingEntity * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"BookingEntity" inManagedObjectContext:self.managedObjectContext];
        
        newEntry.mekkaHotel=self.formObj.MekkaHotelData;
        newEntry.madinaHotel=self.formObj.MadinaHotelData;
        newEntry.bookingType=self.formObj.BookingType;
        newEntry.fromDate=self.formObj.fromDate;
        newEntry.toDate=self.formObj.toDate;
        newEntry.flightClass=self.formObj.FlightClass;
        newEntry.flightCost=[NSNumber numberWithInteger:[self.formObj.FlightCost integerValue]];
        newEntry.guestsNumber=[NSNumber numberWithInt:self.formObj.guestsNumber];
        newEntry.roomsNumber=[NSNumber numberWithInt:self.formObj.roomsNumber];
        newEntry.rentalDays=[NSNumber numberWithInteger:self.formObj.rentalDays];
        newEntry.bookingID=[NSNumber numberWithInteger:self.formObj.bookingID];
        newEntry.userName=self.formObj.UserName;
        newEntry.userAddress=self.formObj.UserAddress;
        newEntry.userEmail=self.formObj.UserEmail;
        newEntry.userMobile=self.formObj.UserMobile;
        newEntry.bookingDate=self.formObj.BookingDate;

        newEntry.passportImage=UIImagePNGRepresentation(self.formObj.PassportImage);
        newEntry.personalImage=UIImagePNGRepresentation(self.formObj.PersonalImage);
        
        newEntry.fromPlace=self.formObj.FromPlace;
        newEntry.toPlace=self.formObj.ToPlace;
        newEntry.carData=self.formObj.CarData;
        newEntry.carType=self.formObj.carType;
        
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }

}
}
- (BOOL) checkFields{
    if ([self.NameText.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء إدخال اسم المستخدم" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return false;
        
    }
    else if ([self.AddressText.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء إدخال العنوان" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return false;
        
    }
    
    else if ([self.EmailText.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء إدخال البريد الالكتروني" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return false;
        
    }
    else if ([self.MobileText.text isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عذرا" message:@"الرجاء إدخال رقم الموبايل" delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
        [alert show];
        return false;
        
    }
    else{
        return true;
    }
}


@end
