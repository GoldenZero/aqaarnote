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
	// Do any additional setup after loading the view.
    propertiesArray = [NSMutableArray new];
    propertiesImagesArray = nil;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelFont=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:16];
    self.cancelButton.titleLabel.font=[UIFont fontWithName:@"GESSTwoMedium-Medium" size:14];

    [self.view addSubview:HUD];
    
    [HUD show:YES];
    HUD.labelText = @"جاري التحميل...";

    [self getProperties];
   // [self getPropertyImages];
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
                        [self.propertiesTable setHidden:NO];
                        [self.propertiesTable reloadData];
                        [self.propertiesTable reloadData];
                    }
                }];
                i++;
                
            }
        }
        
        if (propertiesArray.count==0) {
            [HUD hide:YES];
            [self.propertiesTable setHidden:YES];
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
                propertiesImagesArray = objects;
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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



- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
