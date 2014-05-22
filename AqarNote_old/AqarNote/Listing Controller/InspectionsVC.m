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
#import "ODRefreshControl.h"
#import "Globals.h"
@interface InspectionsVC ()
{
    NSMutableArray* inspectionsArray;
    NSMutableArray* propertiesArray;
    PFObject *choosenObject;
    bool isSearchOpen;
    ODRefreshControl *refreshControl;
    MBProgressHUD *HUD;
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

    // Initialize Data
    inspectionsArray = [NSMutableArray new];
    propertiesArray = [NSMutableArray new];
    inspectionsImagesArray = [NSMutableArray new];
    
    // Set loading indicator
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelFont=[UIFont fontWithName:@"Tahoma" size:16];
    [self.view addSubview:HUD];
  
    // Set refresh control
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.inspectionsTable];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    if ([self checkConnection]) {
        [HUD show:YES];
        HUD.labelText = @"جاري التحميل...";
        // Get Data
        [self getInspections];

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
    if (USER_CHANGED) {
        if ([self checkConnection]) {
            [HUD show:YES];
            HUD.labelText = @"جاري التحميل...";
            // Get Data
            [self getInspections];
            
        }
        else{
            AlertView *alert=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
            alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
            alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
            [alert show];
            
        }

    }

}

-(void)getInspections
{
 
  
    if (USER_CHANGED) {
        USER_CHANGED=FALSE;
    }
    if ([PFUser currentUser]) {

        PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
        [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
        [postQuery whereKeyExists:@"lastInspectionDate"];
        [postQuery orderByDescending:@"lastInspectionDate"];

        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (!error) {
                inspectionsArray = [[NSMutableArray alloc]initWithArray:objects];
                inspectionsImagesArray=[[NSMutableArray alloc] init];
                for (int i=0; i<inspectionsArray.count; i++) {
                    
                    PFObject *property = (PFObject*)[inspectionsArray objectAtIndex:i];
                    PFObject *photo=[property objectForKey:@"imageID"];
                    
                    if (photo!=nil) {
                        PFQuery *query = [PFQuery queryWithClassName:@"PropertyPhoto"];
                        [query whereKey:@"objectId" equalTo:photo.objectId];
                        photo=[query getFirstObject];
                        if (photo) {
                            PFFile *img=[photo objectForKey:@"imageFile"];
                            [inspectionsImagesArray addObject:img];
                        }
                        else{
                            PFFile *theImage = [[PFFile alloc] init];
                            [inspectionsImagesArray addObject:theImage];
                        }
                    }
                    else{
                        PFFile *theImage = [[PFFile alloc] init];
                        [inspectionsImagesArray addObject:theImage];
                    }
                }
                [HUD hide:YES];
                [refreshControl endRefreshing];

                [self.inspectionsTable setHidden:NO];
                self.inspectionsTable.backgroundColor=[UIColor whiteColor];
                self.inspectionsTable.separatorColor=[UIColor lightGrayColor];
                self.inspectionsTable.sectionHeaderHeight=31.0;
                
                [self.addNewInspectImage setHidden:YES];
                [self.addNewProperImg setHidden:YES];
                [self.noInspecImage setHidden:YES];
                [self.searchButton setHidden:NO];
                
                if (inspectionsArray.count==0) {
                    
                    self.inspectionsTable.sectionHeaderHeight=0.0;
                    self.inspectionsTable.backgroundColor=[UIColor clearColor];
                    self.inspectionsTable.separatorColor=[UIColor clearColor];
                    
                    [self.addNewInspectImage setHidden:NO];
                    [self.addNewProperImg setHidden:NO];
                    [self.noInspecImage setHidden:NO];
                    [self.searchButton setHidden:YES];
                    
                }
                [self.inspectionsTable reloadData];


            }
            else{
                AlertView *alert=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
                alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                [alert show];
            }
        }];

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

        PFObject *post = [inspectionsArray objectAtIndex:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            PFFile *theImage = (PFFile*)[inspectionsImagesArray objectAtIndex:indexPath.row];
            
            if (theImage!=nil) {
                
                cell.propertyImage.file = (PFFile *)theImage;
                [cell.propertyImage loadInBackground];
                
            }
        });

        cell.propertyImage.contentMode = UIViewContentModeScaleAspectFit;
        cell.propertyImage.backgroundColor=[UIColor blackColor];
        cell.propertyImage.layer.cornerRadius = 5.0;
        cell.propertyImage.layer.masksToBounds = YES;
        
        [cell.propertyTitle setText:[post objectForKey:@"Title"]];
        cell.propertyTitle.font=[UIFont fontWithName:@"HacenSudan" size:12];

        [cell.detailTxtView setText:[post objectForKey:@"Description"]];
        cell.detailTxtView.font=[UIFont fontWithName:@"Tahoma" size:10];

        [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
        cell.propertyLocation.font=[UIFont fontWithName:@"HacenSudan" size:10];

        [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
        cell.propertyDate.font=[UIFont fontWithName:@"HacenSudan" size:12];
        
        [cell.progressLabel setText:[NSString  stringWithFormat:@"%@ %% ",[post objectForKey:@"InspectionRate"]]];
        cell.progressLabel.font=[UIFont fontWithName:@"HacenSudan" size:12];
        if ([[post objectForKey:@"InspectionRate"]integerValue]<50) {
           [cell.progressImage setImage:[UIImage imageNamed:@""]];
            [cell.progressImage setBackgroundColor:[UIColor orangeColor]];
        }


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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addInspectionBtnPrss:(id)sender {
    [self performSegueWithIdentifier:@"showProprties" sender:self];
 
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]){
        
        AddNewInspectionVC *IVC=segue.destinationViewController;
        IVC.isInspection=YES;
        IVC.delegate=self;
        [IVC setPropertyID:choosenObject];
        [IVC setPropArr:propertiesArray];
    }
    else if ([[segue identifier] isEqualToString:@"showProprties"]){
        
        ChoosePropertyVC *IVC=segue.destinationViewController;
        IVC.delegate=self;
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
        
        [self getInspections];
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

#pragma mark - Delegate of choose property 
- (void)chosenProperty:(PFObject *)property withImage:(PFObject *)img{
    
    if (property!=nil) {
        [inspectionsArray insertObject:property atIndex:0];
        
        PFFile *imageFile;
        if (img!=nil){
            imageFile = (PFFile*)[img objectForKey:@"imageFile"];
        }
        else{
            imageFile = [[PFFile alloc] init];
            
        }
        [inspectionsImagesArray insertObject:imageFile atIndex:0];
        [self.inspectionsTable setHidden:NO];
        self.inspectionsTable.backgroundColor=[UIColor whiteColor];
        self.inspectionsTable.separatorColor=[UIColor lightGrayColor];
        self.inspectionsTable.sectionHeaderHeight=31.0;
        [self.inspectionsTable reloadData];
        
        [self.addNewInspectImage setHidden:YES];
        [self.addNewProperImg setHidden:YES];
        [self.noInspecImage setHidden:YES];
        [self.searchButton setHidden:NO];
        
        if (inspectionsArray.count==0) {
            
            self.inspectionsTable.sectionHeaderHeight=0.0;
            self.inspectionsTable.backgroundColor=[UIColor clearColor];
            self.inspectionsTable.separatorColor=[UIColor clearColor];
            
            [self.addNewInspectImage setHidden:NO];
            [self.addNewProperImg setHidden:NO];
            [self.noInspecImage setHidden:NO];
            [self.searchButton setHidden:YES];
            
        }

        [self.inspectionsTable reloadData];
    }
}

#pragma mark - Delegate of property detils
- (void)InspectedProperty:(PFObject *)propertyInspect WithImage:(PFObject *)img{
    
}
@end
