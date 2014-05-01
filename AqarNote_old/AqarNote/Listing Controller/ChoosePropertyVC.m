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
    NSArray* propertiesImagesArray;
    PFObject* propertySenderID;
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
    
    [self getProperties];
   // [self getPropertyImages];
}

-(void)getProperties
{
    if ([PFUser currentUser]) {
        //Create query for all Post object by the current user
        PFQuery *postQuery = [PFQuery queryWithClassName:@"Properties"];
        [postQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
        
        // Run the query
        [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //Save results and update the table
                propertiesArray = [[NSMutableArray alloc]initWithArray:objects];
                [self.propertiesTable reloadData];
            }
        }];
    }
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

        // Configure the cell with the textContent of the Post as the cell's text label
        PFObject *post = [propertiesArray objectAtIndex:indexPath.row];
        cell.propertyImage.contentMode  = UIViewContentModeScaleAspectFit;
        
        PFQuery *photoQuery = [PFQuery queryWithClassName:@"PropertyPhoto"];
        [photoQuery whereKey:@"propertyID" equalTo:post];
        
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
                        cell.propertyImage.image=image;
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
        [cell.propertyTitle setText:[post objectForKey:@"Title"]];
        [cell.propertyLocation setText:[NSString stringWithFormat:@"%@ - %@",[post objectForKey:@"country"],[post objectForKey:@"city"]]];
        [cell.detailsTxtView setText:[post objectForKey:@"Description"]];
        [cell.detailsTxtView setFont:[UIFont fontWithName:@"System" size:8.0f]];
        cell.detailsTxtView.textAlignment=NSTextAlignmentRight;
        cell.detailsTxtView.textColor=[UIColor grayColor];
        [cell.propertyDate setText:[df stringFromDate:post.createdAt]];
        


    }
    
    
    
//    // This method sets up the downloaded images and places them nicely in a grid
//    // PFObject *post = [propertiesArray objectAtIndex:indexPath.row];
//    //[cell.activityIndicator startAnimating];
//    PFObject *eachObject = [post objectForKey:@"imageID"];
//    __block NSData *imageData;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        PFFile *theImage = [self getCurrentImageForProperty:eachObject];
//        imageData = [theImage getData];
//        
//        
//    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//  //      [cell.activityIndicator setHidden:YES];
//    //    [cell.activityIndicator stopAnimating];
//        if (imageData!=nil) {
//            UIImage *image = [UIImage imageWithData:imageData];
//            // Dispatch to main thread to update the UI
//            [cell.propertyImage setImage:image];
//        }
//    
//    });
//    
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
