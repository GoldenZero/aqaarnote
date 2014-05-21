//
//  UserDataViewController.m
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "UserDataViewController.h"

@interface UserDataViewController ()
{
    BOOL imageForPassport;
    
    EnhancedKeyboard *enhancedKeyboard;
    SBPickerSelector *BookDatePicker;

    NSDate* chosenDate;
    UIImage* passportImage;
    UIImage* personalImage;
}
@end

@implementation UserDataViewController

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
    
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;

    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    
    //prepare the pickers
    [self preparePickers];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
-(void)preparePickers
{
    BookDatePicker = [SBPickerSelector picker];
    BookDatePicker.tag = 0;
    BookDatePicker.pickerType = SBPickerSelectorTypeDate;
    BookDatePicker.delegate = self;
    BookDatePicker.doneButtonTitle = @"تم";
    BookDatePicker.cancelButtonTitle = @"إلغاء";
    
    
}

#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender
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
    //show the credit card dialog page
    [self performSegueWithIdentifier:@"showPayNow" sender:self];
}

- (IBAction)payLaterInvoked:(id)sender
{
    // show pay later page
    [self performSegueWithIdentifier:@"showPayLater" sender:self];

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
    if (imageForPassport)
        [self.passportAttachBtn setBackgroundImage:image forState:UIControlStateNormal];
    else
        [self.personalImgAttachBtn setBackgroundImage:image forState:UIControlStateNormal];


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
