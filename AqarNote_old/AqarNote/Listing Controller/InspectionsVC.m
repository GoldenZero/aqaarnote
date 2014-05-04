//
//  InspectionsVC.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "InspectionsVC.h"
#import "MBProgressHUD.h"
#import "AddNewInspectionVC.h"

@interface InspectionsVC ()
{
    NSMutableArray* inspectionsArray;
    NSMutableArray* propertiesArray;
    PFObject *choosenObject;
    bool isSearchOpen;

    NSMutableArray* inspectionsImagesArray;
}
@end

@implementation InspectionsVC

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
	// Do any additional setup after loading the view.
    inspectionsArray = [NSMutableArray new];
    propertiesArray = [NSMutableArray new];
    inspectionsImagesArray = [NSMutableArray new];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [self hideSearchView];
    isSearchOpen=false;

    [super viewWillAppear:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //TODO : chached data
    [self getInspections];
    

}

-(void)getInspections
{
    if ([PFUser currentUser]) {
        //Create query for all Post object by the current user
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
        [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
        [postQuery whereKeyExists:@"lastInspectionDate"];
        [postQuery orderByDescending:@"createdAt"];

        // Run the query
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                
                for (PFObject* pf in objects) {
                    PFObject *imagesObj = pf[@"imageID"];
                    [imagesObj fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        [inspectionsImagesArray addObject:object];
                        [self.inspectionsTable reloadData];
                        
                    }];
                }
                //Save results and update the table
                inspectionsArray = [[NSMutableArray alloc]initWithArray:objects];
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (inspectionsArray.count>0) {
                
                [self.inspectionsTable reloadData];
                [self.inspectionsTable setHidden:NO];
                [self.addNewInspectImage setHidden:YES];
                [self.addNewProperImg setHidden:YES];
                [self.noInspecImage setHidden:YES];
                [self.searchButton setHidden:NO];
               // [self getInspectionsImages];
            }
            else{
                [self.inspectionsTable setHidden:YES];
                [self.addNewInspectImage setHidden:NO];
                [self.addNewProperImg setHidden:NO];
                [self.noInspecImage setHidden:NO];
                [self.searchButton setHidden:YES];
            }

        }];
    }
}

-(void)getInspectionsImages
{
    PFQuery *photoQuery = [PFQuery queryWithClassName:@"SectionPhoto"];
    [photoQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    
    // Run the query
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([objects count] != 0) {
                inspectionsImagesArray =(NSArray*) objects;
                //Save results and update the table
                NSLog(@"got the object image");
            }
        }
    }];
}

-(PFFile*)getCurrentImageForInpesction:(PFObject*)currObj
{
    PFFile *theImage;
    for (PFObject* ob in inspectionsImagesArray) {
        if ([currObj.objectId isEqualToString:ob.objectId]) {
            theImage = [ob objectForKey:@"imageFile"];
            break;
        }
    }
    return theImage;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        //[logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        //[logInViewController setFields: PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return inspectionsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    InspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell == nil) {
        cell = [[InspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InspectionCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        [cell.activityIndicator startAnimating];
        // Configure the cell with the textContent of the Post as the cell's text label
        PFObject *post = [inspectionsArray objectAtIndex:indexPath.row];
        
        
        cell.propertyImage.contentMode  = UIViewContentModeScaleAspectFit;
        
        PFQuery *photoQuery = [PFQuery queryWithClassName:@"PropertyPhoto"];
        [photoQuery whereKey:@"propertyID" equalTo:post ];
        
        // Run the query
        [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [cell.activityIndicator stopAnimating];
                [cell.activityIndicator setHidden:YES];
                if ([objects count] != 0) {
                    PFFile *theImage = [(PFObject*)[objects objectAtIndex:0] objectForKey:@"imageFile"];
                    //Save results and update the table
                    NSData* imageData = [theImage getData];
                    if (imageData!=nil) {
                        UIImage *image = [UIImage imageWithData:imageData];
                        // Dispatch to main thread to update the UI
                        CGRect frame=cell.propertyImage.frame;
                        cell.propertyImage.image=image;
                        cell.propertyImage.backgroundColor=[UIColor blackColor];
                        cell.propertyImage.contentMode = UIViewContentModeScaleAspectFit;
                        cell.propertyImage.layer.cornerRadius = 5.0;
                        cell.propertyImage.layer.masksToBounds = YES;
                        cell.propertyImage.frame=frame;
                        
                    }
                    else{
                        [cell.propertyImage setImage:[UIImage imageNamed:@"default_image_home.png"]];
                    }
                    
                    NSLog(@"got the object image");
                }
            }
        }];
        
        //    // This method sets up the downloaded images and places them nicely in a grid
        //    // PFObject *post = [propertiesArray objectAtIndex:indexPath.row];
        //    PFObject *eachObject = [post objectForKey:@"imageID"];
        //    [cell.activityIndicator startAnimating];
        //    __block NSData *imageData;
        //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //    dispatch_async(queue, ^{
        //        PFFile *theImage = [self getCurrentImageForInpesction:eachObject];
        //        imageData = [theImage getData];
        //
        //
        //    });
        //    dispatch_async(dispatch_get_main_queue(), ^{
        //        [cell.activityIndicator stopAnimating];
        //        [cell.activityIndicator setHidden:YES];
        //        if (imageData!=nil) {
        //            UIImage *image = [UIImage imageWithData:imageData];
        //            [cell.propertyImage setImage:image];
        //        }
        //        });
        //
        [cell.propertyTitle setText:[post objectForKey:@"Title"]];
        [cell.detailTxtView setText:[post objectForKey:@"Description"]];
        
        [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
        [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
        
        
        //    [cell.moreButton addTarget:self action:@selector(morePressed:) forControlEvents:UIControlEventTouchUpInside];
        //    cell.moreButton.tag = indexPath.row;

    }
    
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    choosenObject = [inspectionsArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showDetails" sender:self];
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIImage *myImage = [UIImage imageNamed:@"select_property"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.contentMode = UIViewContentModeCenter;

    imageView.frame = CGRectMake(0,0,195,31);
    imageView.image=myImage;
    return imageView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 31;
}



-(void)morePressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    int currentIndex = btn.tag;
    choosenObject = [inspectionsArray objectAtIndex:currentIndex];
    
    [self performSegueWithIdentifier:@"showDetails" sender:self];
    
    
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
    [self getInspections];
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
        [[[UIAlertView alloc] initWithTitle:@"معلومات ناقصة"
                                    message:@"تأكد من إدخال كافة المعلومات!"
                                   delegate:nil
                          cancelButtonTitle:@"موافق"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"%@",user);
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


- (IBAction)searchBtnPrss:(id)sender {

    if (isSearchOpen) {
        isSearchOpen=false;
        [self hideSearchView];
        self.inspectionsTable.userInteractionEnabled=YES;

    }
    else{
        isSearchOpen=true;
        [self showSearchView];
        self.inspectionsTable.userInteractionEnabled=NO;

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
    self.inspectionsTable.userInteractionEnabled=YES;

    [self filterPropertiesWithTitle:self.titleSearchTxtField.text];
    
}

- (IBAction)cancelSearchBtnPrss:(id)sender {
    [self.titleSearchTxtField resignFirstResponder];
    self.inspectionsTable.userInteractionEnabled=YES;

    [self hideSearchView];
    isSearchOpen=false;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
        
        [self getInspections];
        
    }
    else{
        NSMutableArray * filteredArray=[[NSMutableArray alloc] init];
        for (int i=0; i<inspectionsArray.count; i++) {
            PFObject *post = [inspectionsArray objectAtIndex:i];
            
            if (!([[post objectForKey:@"Title"] rangeOfString:title].location == NSNotFound)){
                [filteredArray addObject:post];
            }
        }
        
        inspectionsArray = filteredArray;
        [self.inspectionsTable reloadData];
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]){
        
        AddNewInspectionVC *IVC=segue.destinationViewController;
        [IVC setPropertyID:choosenObject];
        [IVC setPropArr:propertiesArray];
        
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

@end
