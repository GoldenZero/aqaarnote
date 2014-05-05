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
    propertiesArray = [NSMutableArray new];
    propertiesImagesArray = [NSMutableArray new];
    self.propertiesTable.userInteractionEnabled=YES;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.propertiesTable];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

}



-(void)viewWillAppear:(BOOL)animated
{
    [self hideSearchView];
    
    isSearchOpen=false;

    if ([PFUser currentUser]) {
        [self.view addSubview:HUD];
        
        [HUD show:YES];
        HUD.labelText = @"جاري التحميل...";
        
        [self getProperties];
        [self.welcomeView setHidden:YES];
        
        [self showTabBar:self.tabBarController];
        //   [self getPropertyImages];
        
    }
    
    else{
        [self.view addSubview:HUD];

        [self.welcomeView setHidden:NO];
        [self.propertiesTable setHidden:YES];
        propertiesArray = [NSMutableArray new];
        propertiesImagesArray = [NSMutableArray new];
        
        [self hideTabBar:self.tabBarController];
        
    }

}

-(void)getProperties
{
   
    //Create query for all Post object by the current user
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
    [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    [postQuery orderByDescending:@"createdAt"];

    // Run the query
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            propertiesImagesArray=[[NSMutableArray alloc] init];
            propertiesArray = [[NSMutableArray alloc]initWithArray:objects];
            int i=0;
            while (i<propertiesArray.count) {
                
    
                PFQuery *photoQuery = [PFQuery queryWithClassName:@"PropertyPhoto"];
                PFObject *post = (PFObject*)[propertiesArray objectAtIndex:i];
                [photoQuery whereKey:@"propertyID" equalTo:post];
                [photoQuery orderByDescending:@"createdAt"];
                [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *photos, NSError *error) {
                    if (!error) {
                        if (photos.count!=0) {
                            PFFile *theImage = [(PFObject*)[photos objectAtIndex:0] objectForKey:@"imageFile"];
                            [propertiesImagesArray addObject:theImage];

                        }
                        else{
                            PFFile *theImage = [[PFFile alloc] init];
                            [propertiesImagesArray addObject:theImage];

                        }
                    }
                    if (propertiesArray.count==propertiesImagesArray.count) {
                        [HUD hide:YES];
                        [refreshControl endRefreshing];

                        [self.propertiesTable setHidden:NO];
                        [self.addNewImage setHidden:YES];
                        [self.searchButton setHidden:NO];
                        [self.propertiesTable reloadData];
                        [self.propertiesTable reloadData];
                    }
                }];
                i++;

            }
        }

        if (propertiesArray.count==0) {
            [HUD hide:YES];
            [refreshControl endRefreshing];

            [self.propertiesTable setHidden:YES];
            [self.addNewImage setHidden:NO];
            [self.searchButton setHidden:YES];
        }
    }];

}


-(void)getPropertyImages
{
    PFQuery *photoQuery = [PFQuery queryWithClassName:@"PropertyPhoto"];
    [photoQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // Run the query
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] != 0) {
                propertiesImagesArray = [[NSMutableArray alloc]initWithArray:objects];
                //Save results and update the table
            }
        }
    }];
}

-(PFFile*)getCurrentImageForProperty:(PFObject*)currObj
{
    PFFile *theImage;
    for (PFObject* ob in propertiesImagesArray) {
        if ([ [ob objectForKey:@"propertyID"] isEqual:currObj]) {
            theImage = [ob objectForKey:@"imageFile"];
            NSLog(@"got the object image");

            break;
        }
    }
    return theImage;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
        // Configure the cell with the textContent of the Post as the cell's text label
    
        
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
        cell.propertyImage.layer.cornerRadius = 5.0;
        cell.propertyImage.layer.masksToBounds = YES;

        [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
        [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
        [cell.detailsTxtView setText:[post objectForKey:@"Description"]];
        [cell.detailsTxtView setFont:[UIFont fontWithName:@"System" size:8.0f]];
        cell.detailsTxtView.textAlignment=NSTextAlignmentRight;
        cell.detailsTxtView.textColor=[UIColor grayColor];
    }
    
    
   

    return cell;
}


-(void)morePressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    int currentIndex = btn.tag;
    choosenObject = [propertiesArray objectAtIndex:currentIndex];
  
    [self performSegueWithIdentifier:@"showPropretyDetail" sender:self];


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    choosenObject = [propertiesArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showPropretyDetail" sender:self];
    

}
#pragma mark login delegate
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"معلومات ناقصة"
                                message:@"تأكد من إدخال جميع المعلومات!"
                               delegate:nil
                      cancelButtonTitle:@"موافق"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"%@",user);
    [self.welcomeView setHidden:YES];
    
 //   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getProperties];
    
    [self showTabBar:self.tabBarController];
    //[self getPropertyImages];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"خطأ في الإدخال" message:@"الرجاء إعادة إدخال اسم المستخدم و كلمة المرور" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:nil, nil];
    
    av.alertViewStyle = UIAlertViewStyleDefault;
    [av show];

}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark signUp delegate
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
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
        [[[UIAlertView alloc] initWithTitle:@"معلومات ناقصة"
                                    message:@"الرجاء التأكد من إدخال كافة المعلومات!"
                                   delegate:nil
                          cancelButtonTitle:@"موافق"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"%@",user);
    [self.welcomeView setHidden:YES];
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getProperties];
        
    [self showTabBar:self.tabBarController];
    [self getPropertyImages];
    
    [self dismissViewControllerAnimated:YES completion:nil]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");


}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Buttons Actions


- (IBAction)signupBtnPrss:(id)sender {

    // Customize the Sign Up View Controller
    SignUpVC *signUpViewController = [[SignUpVC alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault;
    
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
    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}


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

@end
