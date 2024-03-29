//
//  HomePageVC.m
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HomePageVC.h"
#import "LoginVC.h"
#import "SignUpVC.h"
#import "MBProgressHUD.h"
#import "AddNewInspectionVC.h"
#import "ODRefreshControl.h"
#import "Globals.h"
@interface HomePageVC ()
{
    NSMutableArray* propertiesArray;
    NSMutableArray* propertiesImagesArray;
    PFObject *choosenObject;
    NSMutableArray * filteredArray;
    MBProgressHUD *HUD;
    ODRefreshControl *refreshControl;
    bool isSearchOpen;
}
@end

@implementation HomePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Initialize button
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if([UIScreen mainScreen].bounds.size.height == 568){
            [self.signupButton setFrame:CGRectMake(43, 413, 235, 45)];
            [self.loginButton setFrame:CGRectMake(43, 466, 235, 45)];

        }
        else{
            [self.signupButton setFrame:CGRectMake(43, 360, 235, 45)];
            [self.loginButton setFrame:CGRectMake(43, 413, 235, 45)];        }
     
    }
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:66.0/255 green:151.0/255 blue:56.0/255 alpha:1.0f]];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:66.0/255 green:151.0/255 blue:56.0/255 alpha:1.0f]];

    // 1- initialize data
    propertiesArray = [NSMutableArray new];
    propertiesImagesArray = [NSMutableArray new];
    self.propertiesTable.userInteractionEnabled=YES;
    
    // 2- Set loading indicator
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    [self.view addSubview:HUD];
    HUD.labelFont=[UIFont fontWithName:@"Tahoma" size:16];
    
    // 3- Set refresh control
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.propertiesTable];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    // 4- check internet connection
    if ([self checkConnection]) {
        
        // 5- Check if user control
        if ([PFUser currentUser]) {
            [HUD show:YES];
            HUD.labelText = @"جاري التحميل...";
            [self getProperties];
        }
    }
    else{
        AlertView *alert=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];
    }
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [self hideSearchView];
    isSearchOpen=false;

    // User logged in
    if([PFUser currentUser]){
        [self.welcomeView setHidden:YES];
        [self showTabBar:self.tabBarController];

    }
    
    // User not logged in
    else{
        [HUD hide:YES];
        [self.welcomeView setHidden:NO];
        [self.propertiesTable setHidden:YES];
        propertiesArray = [NSMutableArray new];
        propertiesImagesArray = [NSMutableArray new];
        [self hideTabBar:self.tabBarController];

    }
}

-(void)getProperties
{

    PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
    [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            propertiesArray = [[NSMutableArray alloc]initWithArray:objects];
            propertiesImagesArray=[[NSMutableArray alloc] init];
            for (int i=0; i<objects.count; i++) {
                
                PFObject *property = (PFObject*)[propertiesArray objectAtIndex:i];
                PFObject *photo=[property objectForKey:@"imageID"];
            
                if (photo!=nil) {
                    PFQuery *query = [PFQuery queryWithClassName:@"PropertyPhoto"];
                    [query whereKey:@"objectId" equalTo:photo.objectId];
                    photo=[query getFirstObject];
                    if (photo) {
                        PFFile *img=[photo objectForKey:@"imageFile"];
                        [propertiesImagesArray addObject:img];
                    }
                    else{
                        PFFile *theImage = [[PFFile alloc] init];
                        [propertiesImagesArray addObject:theImage];
                    }
                }
                else{
                    PFFile *theImage = [[PFFile alloc] init];
                    [propertiesImagesArray addObject:theImage];
                }
            }
            [HUD hide:YES];
            [refreshControl endRefreshing];
            [self.propertiesTable setHidden:NO];
            [self.addNewImage setHidden:YES];
            [self.searchButton setHidden:NO];
            self.propertiesTable.backgroundColor=[UIColor whiteColor];
            self.propertiesTable.separatorColor=[UIColor lightGrayColor];
            [self.propertiesTable reloadData];

            if (propertiesArray.count==0) {
                
                self.propertiesTable.backgroundColor=[UIColor clearColor];
                self.propertiesTable.separatorColor=[UIColor clearColor];
                [self.addNewImage setHidden:NO];
                [self.searchButton setHidden:YES];
                
            }

        }
        else{
            AlertView *alert=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
            alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
            alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
            [alert show];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return propertiesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell == nil) {
        cell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PropertyCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
    
        
        PFObject *post = (PFObject*)[propertiesArray objectAtIndex:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                PFFile *theImage = (PFFile*)[propertiesImagesArray objectAtIndex:indexPath.row];
                
                if (theImage!=nil) {
                    
                    cell.propertyImage.file = (PFFile *)theImage;
                    [ cell.propertyImage loadInBackground];
                    
                }
            }
        );
        
        [cell.propertyTitle setText:[post objectForKey:@"Title"]];
        cell.propertyTitle.font=[UIFont fontWithName:@"HacenSudan" size:12];

        cell.propertyImage.layer.cornerRadius = 5.0;
        cell.propertyImage.layer.masksToBounds = YES;

        [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
        cell.propertyLocation.font=[UIFont fontWithName:@"HacenSudan" size:10];

        [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
        cell.propertyDate.font=[UIFont fontWithName:@"HacenSudan" size:12];

        [cell.detailsTxtView setText:[post objectForKey:@"Description"]];
        cell.detailsTxtView.font=[UIFont fontWithName:@"Tahoma" size:10];
        cell.detailsTxtView.textAlignment=NSTextAlignmentRight;
        cell.detailsTxtView.textColor=[UIColor grayColor];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    choosenObject = [propertiesArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showPropretyDetail" sender:self];
    

}
#pragma mark - login delegate
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    

    // Check if both fields are completed
    if ((username && password && username.length != 0 && password.length != 0)&&([self NSStringIsValidEmail:username])) {
        return YES; // Begin login process
    }
    else if (username.length==0){
        AlertView *alert=[[AlertView alloc] initWithTitle:@"معلومات ناقصة" message:@"الرجاء إدخال عنوان البريد الإلكتروني" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];
        return NO; // Interrupt login process

    }
    
    else if (password.length==0) {
        AlertView *alert=[[AlertView alloc] initWithTitle:@"معلومات ناقصة" message:@"الرجاء إدخال كلمة المرور" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];

        return NO; // Interrupt login process

    }
    else if(![self NSStringIsValidEmail:username]){
        
        AlertView *alert=[[AlertView alloc] initWithTitle:@"معلومات ناقصة" message:@"إن عنوان البريد الإلكتروني المدخل غير صالح. الرجاء إعادة الإدخال." cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];
        return NO; // Interrupt login process

    }
    else{
        
        AlertView *alert=[[AlertView alloc] initWithTitle:@"خطأ" message:@"لقد حدث خطأ أثناء الدخول. الرجاء المحاولة لاحقاً." cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];

    
        return NO; // Interrupt login process

    }
    
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"%@",user);
    if ([user.email isEqual:[NSNull null]]) {
        [user setEmail:[user username]];
        [user saveInBackground];

    }
    [HUD show:YES];
    HUD.labelText = @"جاري التحميل...";
    USER_CHANGED=TRUE;
    [self getProperties];
    
    [self showTabBar:self.tabBarController];
    //[self getPropertyImages];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    
    AlertView *alert=[[AlertView alloc] initWithTitle:@"فشل الدخول" message:@"لقد حدث خطأ أثناء الدخول. الرجاء المحاولة لاحقاً." cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
    alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
    alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
    [alert show];

}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - signUp delegate
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    USER_CHANGED=TRUE;

    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        
        AlertView *alert=[[AlertView alloc] initWithTitle:@"معلومات ناقصة" message:@"الرجاء التأكد من إدخال كافة المعلومات!" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];

    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"%@",user);
    [user setEmail:[user username]];
    [user saveInBackground];
    
    [self.welcomeView setHidden:YES];
   

    [HUD show:YES];
    HUD.labelText = @"جاري التحميل...";
    [self getProperties];
        
    [self showTabBar:self.tabBarController];
    
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    AlertView *alert=[[AlertView alloc] initWithTitle:@"فشل التسجيل" message:@"لقد حدث خطأ أثناء التسجيل. الرجاء المحاولة لاحقاً." cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
    alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
    alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
    [alert show];
    
   

}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Buttons Actions


- (IBAction)signupBtnPrss:(id)sender {

    // Customize the Sign Up View Controller
    SignUpVC *signUpViewController = [[SignUpVC alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsAdditional|PFSignUpFieldsUsernameAndPassword|PFSignUpFieldsSignUpButton|PFSignUpFieldsDismissButton;
    
    // Present Sign Up View Controller
    [self presentViewController:signUpViewController animated:YES completion:NULL];

}

- (IBAction)loginBtnPrss:(id)sender {
    
    // Customize the Log In View Controller
    LoginVC *logInViewController = [[LoginVC alloc] init];
    logInViewController.delegate = self;
    logInViewController.facebookPermissions = @[@"friends_about_me"];
 

    logInViewController.fields = PFLogInFieldsUsernameAndPassword |PFLogInFieldsPasswordForgotten | PFLogInFieldsDismissButton |PFLogInFieldsLogInButton;
    
    // Customize the Sign Up View Controller
    SignUpVC *signUpViewController = [[SignUpVC alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields =  PFSignUpFieldsAdditional|PFSignUpFieldsUsernameAndPassword|PFSignUpFieldsSignUpButton|PFSignUpFieldsDismissButton;
    logInViewController.signUpController = signUpViewController;
    
    // Present Log In View Controller
    [self presentViewController:logInViewController animated:YES completion:NULL];

}

- (IBAction)searchBtnPrss:(id)sender {
    if (isSearchOpen) {
        isSearchOpen=false;
        self.propertiesTable.userInteractionEnabled=YES;
        [self hideSearchView];
    }
    else{
        isSearchOpen=true;
        [self showSearchView];
        self.propertiesTable.userInteractionEnabled=NO;
    }
    //    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"البحث عن عقار" message:@"أدخل عنوان العقار" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:@"ابحث", nil];
//    av.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [av textFieldAtIndex:0].delegate = self;
//    [av show];

}

- (IBAction)searchPanlBtnPrss:(id)sender {
    [self.titleSearchTxtField resignFirstResponder];
    [self hideSearchView];
    isSearchOpen=false;
    self.propertiesTable.userInteractionEnabled=YES;

    [self filterPropertiesWithTitle:self.titleSearchTxtField.text];

}

- (IBAction)cancelSearchBtnPrss:(id)sender {
    [self.titleSearchTxtField resignFirstResponder];
    [self hideSearchView];
    self.propertiesTable.userInteractionEnabled=YES;

    isSearchOpen=false;

}


#pragma mark - Hide Tab bar

// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    float offset;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            offset=431.0f;
        }
        if(result.height == 568)
        {
            offset=519.0f;
        }
    }

    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, offset+ 100, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, offset)];
        }
    }
    
    [UIView commitAnimations];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    float offset;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
        {
            offset=431.0f;
        }
        if(result.height == 568)
        {
            offset=519.0f;
        }
    }
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        NSLog(@"%@", view);
        
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, offset, view.frame.size.width, view.frame.size.height)];
            
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, offset)];
        }
    }
    
    [UIView commitAnimations];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPropretyDetail"]){
        
        AddNewInspectionVC *IVC=segue.destinationViewController;
        [IVC setPropertyID:choosenObject];
        [IVC setPropArr:propertiesArray];
        
    }
    
    else if ([[segue identifier] isEqualToString:@"showAddProperty"]){
        
        AddNewAqarVC *IVC=segue.destinationViewController;
        IVC.delegate=self;
    }
    
    
}

#pragma mark - UIAlertView Delegate handler

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // if cancel
    if (buttonIndex==0) {
        // [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    // if add
    else{
        [self filterPropertiesWithTitle:[[alertView textFieldAtIndex:0] text]];
        
    }
}

#pragma mark - Show search view

-(void)showSearchView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.searchView.hidden = NO;
    self.searchView.frame = CGRectMake(self.searchView.frame.origin.x,  50, self.searchView.frame.size.width, self.searchView.frame.size.height);
    [UIView commitAnimations];
  //  [self.searchView setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    
    [self.searchView becomeFirstResponder];
}

-(void)hideSearchView
{
    [self.searchView resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
//    self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, ([[UIScreen mainScreen] bounds].size.height == 568) ? 568 : 480, self.searchView.frame.size.width, self.searchView.frame.size.height);
    self.searchView.frame = CGRectMake(self.searchView.frame.origin.x, -self.searchView.frame.size.height, self.searchView.frame.size.width, self.searchView.frame.size.height);
    [UIView commitAnimations];
  //  self.searchView.hidden = YES;

}


- (void) filterPropertiesWithTitle:(NSString*) title{
    if ([title isEqualToString:@""]||[title isEqualToString:@" "]) {
        [HUD show:YES];
        HUD.labelText = @"جاري البحث ...";
        
        [self getProperties];
        
    }
    else{
        filteredArray=[[NSMutableArray alloc] init];
        for (int i=0; i<propertiesArray.count; i++) {
            PFObject *post = [propertiesArray objectAtIndex:i];
            
            if (!([[post objectForKey:@"Title"] rangeOfString:title].location == NSNotFound)){
                //if ([[post objectForKey:@"Title"] isEqualToString:title]) {
                [filteredArray addObject:post];
            }
        }
        
        propertiesArray = filteredArray;
        [self.propertiesTable reloadData];
        
    }
}

#pragma mark - TextField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


#pragma mark - Refresh control delegate
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.view addSubview:HUD];
        [HUD show:YES];
        HUD.labelText = @"جاري التحميل...";

        [self getProperties];
    });
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


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Add new property

- (void)addedProperty:(PFObject *)property withImage:(PFObject *)image{
    if (property!= nil) {
        [propertiesArray insertObject:property atIndex:0];
        PFFile *imageFile;
        if (image!=nil){
            imageFile = (PFFile*)[image objectForKey:@"imageFile"];
        }
        else{
            imageFile = [[PFFile alloc] init];

        }
        [propertiesImagesArray insertObject:imageFile atIndex:0];

    }

    if (property!=nil) {
        [HUD show:YES];
        [self.propertiesTable reloadData];
        [HUD hide:YES];
    }
}
- (IBAction)addPropertyBtnPrss:(id)sender {
    [self performSegueWithIdentifier:@"showAddProperty" sender:self];
    
}
@end
