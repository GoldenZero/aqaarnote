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
    countryObject * chosenCountry;

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
    [self loadCountries];

}

- (void)viewDidAppear:(BOOL)animated{
    
    isEdit=false;
    self.countryButton.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons Actions

- (IBAction)logoutBtnPrss:(id)sender {
    
    [PFUser logOut];
    
    self.tabBarController.selectedIndex=0;

}

- (IBAction)editBtnPrss:(id)sender {
    [self closePicker];
    if (isEdit) {
        isEdit=false;
        self.backButton.hidden=YES;
        [self.editButton setTitle:@"تعديل" forState:UIControlStateNormal];
        [self.nameTxtField setEnabled:NO];
        [self.emailTxtField setEnabled:NO];
        [self.passwordTxtField setEnabled:NO];
        self.countryButton.hidden=YES;
        [self.confirmPasswordTxtField setEnabled:NO];
        [self.aboutTxtView setEditable:NO];

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

        // Check if password and its confirmation are equal
        
        // Upload the data

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

    [self closePicker];
}

- (IBAction)chooseCountryBtnPrss:(id)sender {
    [self closePicker];
}

- (IBAction)countryBtnPrss:(id)sender {
    [self showPicker];
}

#pragma mark - TextView Delegate 

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
    [self closePicker];
    
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
    [self closePicker];
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
    
    [label setText:[[countriesArray objectAtIndex:row]countryName]];
    
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    chosenCountry=(countryObject*)[countriesArray objectAtIndex:row];
    self.countryTxtField.text=[NSString stringWithFormat:@"   %@",[chosenCountry countryName]];
    
}

#pragma mark - Show and hide picker

-(IBAction)closePicker
{
    self.tabBarController.tabBar.hidden=NO;
   [self.pickerView setHidden:YES];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x,
                                           [[UIScreen mainScreen] bounds].size.height,
                                           self.pickerView.frame.size.width,
                                           self.pickerView.frame.size.height);
    }];
}


-(IBAction)showPicker
{
    self.tabBarController.tabBar.hidden=YES;
   
    [self.pickerView setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x,
                                           [[UIScreen mainScreen] bounds].size.height-self.self.pickerView.frame.size.height,
                                           self.pickerView.frame.size.width,
                                           self.pickerView.frame.size.height);
    }];
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
        
        //add country
        [resultCountries addObject:country];
    }
    countriesArray=resultCountries;
    [self.countryPicker reloadAllComponents];
}


@end
