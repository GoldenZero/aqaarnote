//
//  AddNewInspectionVC.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AddNewInspectionVC.h"

@interface AddNewInspectionVC ()
{
    NSMutableArray* sectionsArray;
    NSMutableArray* chosenSectionArray;
    PFObject * currentImageID;
    PFObject* mySection;
    int view_y;
    
}
@end

@implementation AddNewInspectionVC

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
    self.propertyTitle.text = [self.propertyID objectForKey:@"title"];
    self.locationLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.propertyID objectForKey:@"country"],[self.propertyID objectForKey:@"city"]];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for (UIView *subview in self.sectionScrollView.subviews) {
        [subview removeFromSuperview];
    }
    [self getSectionsForProperty:self.propertyID];
    //[self prepareSections];

}

-(void)getSectionsForProperty:(PFObject*)propID
{
    
    PFQuery *secQuery = [PFQuery queryWithClassName:@"Sections"];
    [secQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    [secQuery whereKey:@"propertyID" equalTo:self.propertyID];

    
    // Run the query
    [secQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Save results and update the table
            sectionsArray = [[NSMutableArray alloc]initWithArray:objects];
            chosenSectionArray = [[NSMutableArray alloc]initWithArray:objects];

            [self prepareSections];
        }
    }];
}

-(void)prepareSections
{
    view_y = 0;
    
    //sectionsArray = [NSMutableArray new];
    //chosenSectionArray = [NSMutableArray new];
    
    
    for (int i = 0; i < [sectionsArray count]; i++) {
        PFObject* sect = [sectionsArray objectAtIndex:i];
       
        
        UIImage* arrowImg = [UIImage imageNamed:@"list_side_arrow"];
        UIImageView* arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 9, 16)];
        [arrowImgView setImage:arrowImg];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = [sect objectForKey:@"name"];
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, view_y, 320, 50)];
        UIImage* img;
        if ([titleLabel.text isEqualToString:@"kitchen"]) {
            img = [UIImage imageNamed:@"cooknig_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"living room"]) {
           img = [UIImage imageNamed:@"Lobby_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"bed room"]) {
           img = [UIImage imageNamed:@"badroom_icon"];

        }
        
        else if ([titleLabel.text isEqualToString:@"bath room"]) {
            img = [UIImage imageNamed:@"bathroom_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"dining room"]) {
            img = [UIImage imageNamed:@"dining_room_icon"];
        }
        else if ([titleLabel.text isEqualToString:@"garden"]) {
           img = [UIImage imageNamed:@"garden_room_icon"];
        }
        else{
           img = [UIImage imageNamed:@""];

        }
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 15, 15, 15)];
        [imgView setImage:img];
        
        UILabel* statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 40, 50)];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        statusLabel.text = [self getStatusOfSection:[sect objectForKey:@"status"]];
        
        UIButton* secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        secBtn.frame = CGRectMake(0, 0, 320, 50);
        secBtn.backgroundColor = [UIColor clearColor];
        //[secBtn setBackgroundImage:[UIImage imageNamed:@"UnActiveSelectDefuilt.png"] forState:UIControlStateNormal];
        //[secBtn setBackgroundImage:[UIImage imageNamed:@"activeSelectDefuilt.png"] forState:UIControlStateSelected];
        [secBtn addTarget:self action:@selector(sectionPressed:) forControlEvents:UIControlEventTouchUpInside];
        secBtn.tag = i;
        
        //if (i == 0 || i == 1 || i == 3) {
            //[secBtn setSelected:YES];
          //  [chosenSectionArray addObject:[sectionsArray objectAtIndex:i]];
       // }
        
        [v addSubview:titleLabel];
        [v addSubview:imgView];
        [v addSubview:statusLabel];
        [v addSubview:arrowImgView];
        [v addSubview:secBtn];
        
        [self.sectionScrollView addSubview:v];
        if (view_y > 236) {
            self.sectionScrollView.contentSize = CGSizeMake(320, view_y + 51);
        }
        view_y += 51;
        
        
    }
    
    [MBProgressHUD  hideHUDForView:self.view animated:YES];
    
}

-(NSString*)getStatusOfSection:(NSNumber*)status
{
    switch ([status integerValue]) {
        case 0:
            return @"عادل";
            break;
            
        case 1:
            return @"قذر";
            break;
            
        case 2:
            return @"ملحوظ";
            break;
            
        case 3:
            return @"جيد";
            break;
            
        case 4:
            return @"نظيف";
            break;
            
        case 5:
            return @"تالف";
            break;
            
        default:
            return @"لا شئ";
            break;
    }
}

-(void)sectionPressed:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int currentIndex = btn.tag;
    mySection = [sectionsArray objectAtIndex:currentIndex];
    [self performSegueWithIdentifier:@"showAddInspectVC" sender:self];

    //[chosenSectionArray addObject:[sectionsArray objectAtIndex:currentIndex]];
    //[btn setSelected:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAddInspectVC"])
    {
        BrowseInspectionVC* vc = segue.destinationViewController;
        vc.propertyID = self.propertyID;
        vc.sectionID = mySection;
    }
}


- (IBAction)uploadImagePressed:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        //[self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Dismiss controller
    // [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Upload image
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
}

- (void)uploadImage:(NSData *)imageData
{
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    
    //HUD creation here (see example for code)
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hide old HUD, show completed HUD (see example for code)
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
            // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            
            // Create a PFObject around a PFFile and associate it with the current user
            PFObject *userPhoto = [PFObject objectWithClassName:@"SectionPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            /*int indexOfProp = 0;
            for (PFObject* pf in self.PropArr) {
                if ([pf.objectId isEqualToString:self.propertyID.objectId]) {
                    break;
                }
                indexOfProp++;
            }*/
//            PFObject *propertyObject = [self.PropArr objectAtIndex:indexOfProp];
            [userPhoto setObject:self.propertyID forKey:@"propertyID"];

            
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    PFQuery *photoQuery = [PFQuery queryWithClassName:@"SectionPhoto"];
                    [photoQuery whereKey:@"user" equalTo:[PFUser currentUser]];
                    
                    // Run the query
                    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            if ([objects count] != 0) {
                                PFObject *post = [objects objectAtIndex:[objects count] - 1];
                                //Save results and update the table
                                currentImageID = post;
                                NSLog(@"got the object image");
                            }
                        }
                    }];
                    
                    //[self refresh:nil];
                }
                else{
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
}

- (IBAction)editButtonPressed:(id)sender {
    
    
}

- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"post new property");
    // Create Post
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)backButtonPressed:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
