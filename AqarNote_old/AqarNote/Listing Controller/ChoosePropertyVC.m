//
//  ChoosePropertyVC.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "ChoosePropertyVC.h"

@interface ChoosePropertyVC ()
{
    NSMutableArray* propertiesArray;
    NSMutableArray* propertiesImagesArray;
    PFObject* propertySenderID;
    MBProgressHUD *HUD;

}
@end

@implementation ChoosePropertyVC

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
    
    // Set custom font
    self.cancelButton.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];
    
    // initialize data
    propertiesArray = [NSMutableArray new];
    propertiesImagesArray = nil;
    
    // Set loading indicator
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelFont=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:16];
     if ([self checkConnection]) {
        [HUD show:YES];
        HUD.labelText = @"جاري التحميل...";
        [self.view addSubview:HUD];
        [self getProperties];

    }
     else{
         [[[UIAlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت"
                                     message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا"
                                    delegate:nil
                           cancelButtonTitle:@"موافق"
                           otherButtonTitles:nil] show];
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    if (![self isBeingPresented]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma  mark - loading data
-(void)getProperties
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
    [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    [postQuery orderByDescending:@"createdAt"];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            propertiesImagesArray=[[NSMutableArray alloc] initWithCapacity:objects.count];
            propertiesArray = [[NSMutableArray alloc]initWithArray:objects];
            for (int i=0; i<propertiesArray.count; i++) {
                PFQuery *photoQuery = [PFQuery queryWithClassName:@"PropertyPhoto"];
                PFObject *post = (PFObject*)[propertiesArray objectAtIndex:i];
                [photoQuery whereKey:@"propertyID" equalTo:post];
                NSArray *photos= [photoQuery findObjects];
                if (photos.count!=0) {
                    PFFile *theImage = [(PFObject*)[photos objectAtIndex:0] objectForKey:@"imageFile"];
                    [propertiesImagesArray insertObject:theImage atIndex:i];
                }
                else{
                    PFFile *theImage = [[PFFile alloc] init];
                    [propertiesImagesArray insertObject:theImage atIndex:i];
                }
                
                if (propertiesArray.count==propertiesImagesArray.count) {
                    [HUD hide:YES];
                    [self.propertiesTable setHidden:NO];
                    [self.propertiesTable reloadData];
                }
            }
        }
        
        if (propertiesArray.count==0) {
            [HUD hide:YES];
            [self.propertiesTable setHidden:YES];
        }
    }];

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return propertiesArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell == nil) {
        cell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PropertyCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"yyyy-MM-dd"];
        [cell.activityIndicator startAnimating];

        
        PFObject *post = (PFObject*)[propertiesArray objectAtIndex:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            PFFile *theImage = (PFFile*)[propertiesImagesArray objectAtIndex:indexPath.row];
            
            if (theImage!=nil) {
                
                cell.propertyImage.file = (PFFile *)theImage;
                [ cell.propertyImage loadInBackground];
                
            }
        });
        
        [cell.propertyTitle setText:[post objectForKey:@"Title"]];
        cell.propertyTitle.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:12];

        cell.propertyImage.layer.cornerRadius = 5.0;
        cell.propertyImage.layer.masksToBounds = YES;
        
        [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
        cell.propertyLocation.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:10];

        [cell.detailsTxtView setText:[post objectForKey:@"Description"]];
        cell.detailsTxtView.font=[UIFont fontWithName:@"GESSTwoLight-Light" size:10];
        cell.detailsTxtView.textAlignment=NSTextAlignmentRight;
        cell.detailsTxtView.textColor=[UIColor grayColor];
        [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
        cell.propertyDate.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:12];
    }
 
      return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //show add new inspection page
    propertySenderID = [propertiesArray objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showAddNewInspection" sender:self];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddNewInspection"])
    {
        AddNewInspectionVC* vc = segue.destinationViewController;
        vc.propertyID = propertySenderID;
        vc.PropArr = propertiesArray;

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
