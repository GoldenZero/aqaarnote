//
//  InspectionsVC.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "InspectionsVC.h"

@interface InspectionsVC ()
{
    NSMutableArray* inspectionsArray;
    NSMutableArray* propertiesArray;

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
    [super viewWillAppear:YES];
    [self getInspections];
    if (inspectionsArray.count>0) {
        [self.inspectionsTable setHidden:NO];
        [self.addNewInspectImage setHidden:YES];
        [self.addNewProperImg setHidden:YES];
        
    }
    else{
        [self.inspectionsTable setHidden:YES];
        [self.addNewInspectImage setHidden:NO];
        [self.addNewProperImg setHidden:NO];

    }
    [self getInspectionsImages];
}

-(void)getInspections
{
    if ([PFUser currentUser]) {
        //Create query for all Post object by the current user
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
        [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
        [postQuery whereKeyExists:@"lastInspectionDate"];
        
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
                inspectionsImagesArray = objects;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    InspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[InspectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"InspectionCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    // Configure the cell with the textContent of the Post as the cell's text label
    PFObject *post = [inspectionsArray objectAtIndex:indexPath.row];
    
    // This method sets up the downloaded images and places them nicely in a grid
    // PFObject *post = [propertiesArray objectAtIndex:indexPath.row];
    PFObject *eachObject = [post objectForKey:@"imageID"];
    __block NSData *imageData;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        PFFile *theImage = [self getCurrentImageForInpesction:eachObject];
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
    
    return cell;
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

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end