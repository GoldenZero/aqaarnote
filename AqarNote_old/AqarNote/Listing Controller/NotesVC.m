//
//  NotesVC.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "NotesVC.h"
#import "countryObject.h"


#define COUNTRIES_FILE_NAME         @"Countries"
#define COUNTRY_ID_JSONK            @"CountryID"
#define COUNTRY_NAME_JSONK          @"CountryName"
#define COUNTRY_NAME_EN_JSONK       @"CountryNameEn"
#define COUNTRY_CURRENCY_ID_JSONK   @"CurrencyID"
#define COUNTRY_DISPLAY_ORDER_JSONK @"DisplayOrder"
#define COUNTRY_CODE_JSONK          @"CountryCode"

@interface NotesVC (){
    bool isEdit;
    NSArray *countriesArray;
    EnhancedKeyboard *enhancedKeyboard;
    NSString * chosenCountry;
    SBPickerSelector *countriesPicker ;

}

@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

CGFloat animatedDistance;

@implementation NotesVC

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
    [self.aboutTxtView setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    countriesPicker = [SBPickerSelector picker];
    
    // Set custom font
    self.backButton.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    self.editButton.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    self.nameLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.countryLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.emailLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.passwordLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.confirmPassLabel.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:11];
    self.myAccountLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:16];
    self.nameTxtField.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.aboutTxtView.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.countryTxtField.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    self.emailTxtField.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:12];
    
    // Set custom picker
    countriesPicker.delegate = self;
    countriesPicker.pickerType = SBPickerSelectorTypeText;
    countriesPicker.doneButtonTitle = @"تم";
    countriesPicker.cancelButtonTitle = @"إغلاق";

    self.contentScrollView.contentSize =CGSizeMake(320, 470);
    [self loadCountries];
    [self loadUserInfo];
   
}

- (void)viewDidAppear:(BOOL)animated{
    
    isEdit=false;
    self.countryButton.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons Actions

- (IBAction)logoutBtnPrss:(id)sender {
    
    [PFUser logOut];
    self.tabBarController.selectedIndex=0;

}

- (IBAction)editBtnPrss:(id)sender {
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    if (isEdit) {
        // Check if password and its confirmation are equal
        if (![self.confirmPasswordTxtField.text isEqualToString:self.passwordTxtField.text]) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"كلمة المرور غير متطابقة" message:@"الرجاء إدخال كلمة المرور من جديد" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"", nil];
            av.alertViewStyle = UIAlertViewStylePlainTextInput;
            [av textFieldAtIndex:0].delegate = self;
            [av show];
            
            
        }
        else{

            isEdit=false;
            self.backButton.hidden=YES;
            [self.editButton setTitle:@"تعديل" forState:UIControlStateNormal];
            [self.nameTxtField setEnabled:NO];
            [self.emailTxtField setEnabled:NO];
            [self.passwordTxtField setEnabled:NO];
            self.countryButton.hidden=YES;
        //    self.logoutButton.hidden=NO;
            [self.confirmPasswordTxtField setEnabled:NO];
            [self.aboutTxtView setEditable:NO];
            [self updateUserInfo];

        }
    }
    else{
       
        isEdit=true;
        self.backButton.hidden=NO;
        [self.editButton setTitle:@"حفظ" forState:UIControlStateNormal];
        [self.nameTxtField setEnabled:YES];
        [self.emailTxtField setEnabled:YES];
        [self.passwordTxtField setEnabled:YES];
        [self.confirmPasswordTxtField setEnabled:YES];
        [self.aboutTxtView setEditable:YES];
        self.countryButton.hidden=NO;
      //  self.logoutButton.hidden=YES;

    }
}

- (IBAction)backBtnPrss:(id)sender {

    isEdit=false;
    self.backButton.hidden=YES;
    [self.editButton setTitle:@"تعديل" forState:UIControlStateNormal];
    [self.nameTxtField setEnabled:NO];
    [self.emailTxtField setEnabled:NO];
    [self.passwordTxtField setEnabled:NO];
    [self.confirmPasswordTxtField setEnabled:NO];
    [self.aboutTxtView setEditable:NO];
    self.countryButton.hidden=YES;
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    [self loadUserInfo];
}

- (IBAction)countryBtnPrss:(id)sender {
    [self showPicker:nil];
 //   [self showPicker];
}

#pragma mark - TextView Delegate 

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [textView setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    textView.text=@"";
    
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


- (void)textViewDidEndEditing:(UITextView *)atextView {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


#pragma mark - UITextFieldDelegate protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
// --------------------------------------------------------------------
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

// --------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
// --------------------------------------------------------------------

- (void)textFieldDidBeginEditing:(UITextField *)aTextField {
    
    [aTextField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];

    CGRect textFieldRect = [self.view.window convertRect:aTextField.bounds fromView:aTextField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}


#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)doneDidTouchDown
{
    if ([self.nameTxtField isEditing]) {
        [self.nameTxtField resignFirstResponder];
    }
    
    else if ([self.emailTxtField isEditing]) {
        [self.emailTxtField resignFirstResponder];
    }
    else if ([self.passwordTxtField isEditing]){
        [self.passwordTxtField resignFirstResponder];
    }
    else if ([self.confirmPasswordTxtField isEditing]){
        [self.confirmPasswordTxtField resignFirstResponder];
    }
    else{
        [self.aboutTxtView resignFirstResponder];
    }
    
}


#pragma mark - UIPicker view handler
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return countriesArray.count;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // set label
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 50.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:30.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setText:[countriesArray objectAtIndex:row]];
    
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    chosenCountry=(NSString*)[countriesArray objectAtIndex:row];
    self.countryTxtField.text=[NSString stringWithFormat:@"   %@",chosenCountry];
    
}


#pragma mark - Load countries form JSON file

- (void) loadCountries{
    
    NSData *countriesData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:COUNTRIES_FILE_NAME ofType:@"json"]];
    
    NSArray * countriesParsedArray = [NSJSONSerialization JSONObjectWithData:countriesData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray * resultCountries = [NSMutableArray new];
    for (NSDictionary * countryDict in countriesParsedArray)
    {
        //create country object
        countryObject * country = [[countryObject alloc]
                                   initWithCountryIDString:[countryDict objectForKey:COUNTRY_ID_JSONK]
                                   countryName:[countryDict objectForKey:COUNTRY_NAME_JSONK]
                                   countryNameEn:[countryDict objectForKey:COUNTRY_NAME_EN_JSONK]
                                   currencyIDString:[countryDict objectForKey:COUNTRY_CURRENCY_ID_JSONK]
                                   displayOrderString:[countryDict objectForKey:COUNTRY_DISPLAY_ORDER_JSONK]
                                   countryCodeString:[countryDict objectForKey:COUNTRY_CODE_JSONK]
                                   ];
        
        [resultCountries addObject:country.countryName];
    }
    countriesArray=resultCountries;
    
    countriesPicker.pickerData = [[NSMutableArray alloc] initWithArray:countriesArray];
    
}



- (void) updateUserInfo{
    
    if ([self checkConnection]) {
        [[PFUser currentUser] setUsername:self.nameTxtField.text];
        [[PFUser currentUser] setEmail:self.emailTxtField.text];
        [[PFUser currentUser] setPassword:self.passwordTxtField.text];
        [[PFUser currentUser] setObject:self.aboutTxtView.text forKey:@"AboutUser"];
        [[PFUser currentUser] setObject:self.countryTxtField.text forKey:@"Country"];
        [[PFUser currentUser] saveInBackground];
    }
    
    else{
        [[[UIAlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت"
                                    message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا"
                                   delegate:nil
                          cancelButtonTitle:@"موافق"
                          otherButtonTitles:nil] show];
    }
    
}

- (void)loadUserInfo{
    self.nameTxtField.text=(NSString*)[[PFUser currentUser] username];
    self.countryTxtField.text=(NSString*)[[PFUser currentUser] objectForKey:@"Country"];
    self.emailTxtField.text=(NSString*)[[PFUser currentUser] email];
    self.passwordTxtField.text=(NSString*)[[PFUser currentUser]password];
    self.confirmPasswordTxtField.text=(NSString*)[[PFUser currentUser] password];
    if (![[[PFUser currentUser] objectForKey:@"AboutUser"] isEqualToString:@""]) {
        self.aboutTxtView.text=[[PFUser currentUser] objectForKey:@"AboutUser"];
    }
    else{
        self.aboutTxtView.text=@"اكتب عن نفسك في بضعة كلمات";
    }
}

#pragma mark - SBPickerSelectorDelegate

- (void) showPicker:(id)sender{
    self.tabBarController.tabBar.hidden=YES;
    [self.nameTxtField resignFirstResponder];
    [self.aboutTxtView resignFirstResponder];
    [self.emailTxtField resignFirstResponder];
    [self.passwordTxtField resignFirstResponder];
    [self.confirmPasswordTxtField resignFirstResponder];

    CGPoint point = [self.view convertPoint:[sender frame].origin fromView:[sender superview]];
    CGRect frame = [sender frame];
    frame.origin = point;
    //[picker showPickerOver:self]; //classic picker display
    [countriesPicker showPickerIpadFromRect:CGRectZero inView:self.view];
    
}

-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    chosenCountry=(NSString*)[countriesArray objectAtIndex:idx];
    self.countryTxtField.text=chosenCountry ;
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // resultLbl_.text = [dateFormat stringFromDate:date];
}

-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    NSLog(@"press cancel");
}

-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
    if ([value isMemberOfClass:[NSDate class]]) {
        [self SBPickerSelector:selector dateSelected:value];
    }else{
        [self SBPickerSelector:selector selectedValue:value index:idx];
    }
}

#pragma mark - Check internet connection

- (bool) checkConnection{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return false;
    }
    else {
        return true;
    }
    
}

@end
