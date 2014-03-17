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
@interface HomePageVC ()
{
    NSMutableArray* propertiesArray;
    NSMutableArray* propertiesImagesArray;
    PFObject *choosenObject;
    NSMutableArray * filteredArray;
}
@end

@implementation HomePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    propertiesArray = [NSMutableArray new];
    propertiesImagesArray = [NSMutableArray new];
    
    
        /*
    [PFCloud callFunctionInBackground:@"hello"
                       withParameters:@{}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {
                                        // result is @"Hello world!"
                                    }
                                }];
    
    */
    
	// Do any additional setup after loading the view, typically from a nib.
}



-(void)viewWillAppear:(BOOL)animated
{
    
    if ([PFUser currentUser]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self getProperties];
        
        [self.welcomeView setHidden:YES];
        
        [self showTabBar:self.tabBarController];
        //[self getPropertyImages];
        
    }
    else{
        
        [self.welcomeView setHidden:NO];
        [self hideTabBar:self.tabBarController];
        
    }
    
}

-(void)getProperties
{
   
    //Create query for all Post object by the current user
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
    [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    
   
    
    // Run the query
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject* pf in objects) {
                PFObject *imagesObj = pf[@"imageID"];
                [imagesObj fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    [propertiesImagesArray addObject:object];
                    [self.propertiesTable reloadData];

                }];
            }
            //Save results and update the table
            propertiesArray = [[NSMutableArray alloc]initWithArray:objects];

        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (propertiesArray.count>0) {
            [self.propertiesTable reloadData];
            
            [self.propertiesTable setHidden:NO];
            [self.addNewImage setHidden:YES];
            [self.searchButton setHidden:NO];
        }
        else{
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
                NSLog(@"got the object image");
            }
        }
    }];
}

-(PFFile*)getCurrentImageForProperty:(PFObject*)currObj
{
    PFFile *theImage;
    for (PFObject* ob in propertiesImagesArray) {
        if ([currObj.objectId isEqualToString:ob.objectId]) {
            theImage = [ob objectForKey:@"imageFile"];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PropertyCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];

    // Configure the cell with the textContent of the Post as the cell's text label
    PFObject *post = [propertiesArray objectAtIndex:indexPath.row];
    
    // This method sets up the downloaded images and places them nicely in a grid
   // PFObject *post = [propertiesArray objectAtIndex:indexPath.row];
    PFObject *eachObject = [post objectForKey:@"imageID"];
    __block NSData *imageData;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
       PFFile *theImage = [self getCurrentImageForProperty:eachObject];
        imageData = [theImage getData];


    });
     dispatch_async(dispatch_get_main_queue(), ^{
    UIImage *image = [UIImage imageWithData:imageData];
    // Dispatch to main thread to update the UI
    [cell.propertyImage setImage:image];
     });
    
    [cell.propertyTitle setText:[post objectForKey:@"Title"]];
    [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
    [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
    
    [cell.moreButton addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreButton.tag = indexPath.row;

    return cell;
}

-(void)morePressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    int currentIndex = btn.tag;
    choosenObject = [propertiesArray objectAtIndex:currentIndex];
  
    [self performSegueWithIdentifier:@"showPropretyDetail" sender:self];


}

#pragma mark login delegate
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"%@",user);
    [self.welcomeView setHidden:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getProperties];
    
    [self showTabBar:self.tabBarController];
    //[self getPropertyImages];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
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
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"%@",user);
    [self.welcomeView setHidden:YES];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getProperties];
        
    [self showTabBar:self.tabBarController];
    //[self getPropertyImages];
    
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

- (IBAction)logoutPressed:(id)sender {
    
    [PFUser logOut];
    [self.welcomeView setHidden:NO];
    [self.propertiesTable setHidden:YES];
    propertiesArray = [NSMutableArray new];
    propertiesImagesArray = [NSMutableArray new];

    [self hideTabBar:self.tabBarController];
    
}

- (IBAction)signupBtnPrss:(id)sender {

    // Customize the Sign Up View Controller
    SignUpVC *signUpViewController = [[SignUpVC alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
    
    // Present Sign Up View Controller
    [self presentViewController:signUpViewController animated:YES completion:NULL];

}

- (IBAction)loginBtnPrss:(id)sender {
    
    // Customize the Log In View Controller
    LoginVC *logInViewController = [[LoginVC alloc] init];
    logInViewController.delegate = self;
    logInViewController.facebookPermissions = @[@"friends_about_me"];
    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton;
    
    // Customize the Sign Up View Controller
    SignUpVC *signUpViewController = [[SignUpVC alloc] init];
    signUpViewController.delegate = self;
    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
    logInViewController.signUpController = signUpViewController;
    
    // Present Log In View Controller
    [self presentViewController:logInViewController animated:YES completion:NULL];

}

- (IBAction)searchBtnPrss:(id)sender {
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"البحث عن عقار" message:@"أدخل عنوان العقار" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:@"ابحث", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];

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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self getProperties];
        
    }
    else{
        filteredArray=[[NSMutableArray alloc] init];
        for (int i=0; i<propertiesArray.count; i++) {
            PFObject *post = [propertiesArray objectAtIndex:i];

            if ([[post objectForKey:@"Title"] isEqualToString:title]) {
                [filteredArray addObject:post];
            }
        }

        propertiesArray = filteredArray;
        [self.propertiesTable reloadData];

    }
}
@end
