//
//  BrowseInspectionVC.m
//  AqarNote
//
//  Created by GALMarei on 2/4/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "BrowseInspectionVC.h"

@interface BrowseInspectionVC ()
{
    NSNumber* sectionStatus;
    PFObject * currentImageID;
    
    
}
@end

@implementation BrowseInspectionVC

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
    self.sectionTitle.text = [self.sectionID objectForKey:@"name"];
    self.inputAccessoryView = [XCDFormInputAccessoryView new];
    
}

#pragma mark - Buttons Actions 


- (IBAction)uploadImagePressed:(id)sender {
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"إلغاء"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"من الكاميرا", @"من مكتبة الصور", nil];
    
    [as showInView:self.view];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.uploadImageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
            
            
            [userPhoto setObject:self.propertyID forKey:@"propertyID"];
            [userPhoto setObject:self.sectionID forKey:@"sectionID"];
            
            
            
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


- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"post new inspection");
    // update sections
    PFQuery *query = [PFQuery queryWithClassName:@"Sections"];
    [query whereKey:@"userID" equalTo:[PFUser currentUser]];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.sectionID.objectId block:^(PFObject *CurrSection, NSError *error) {
        
        // Now let's update it with some new data.
        // will get sent to the cloud.
        CurrSection[@"status"] = sectionStatus;
        if (currentImageID)
            CurrSection[@"imageID"] = currentImageID;
        if ([self.noteTextView.text length] > 0)
            CurrSection[@"note"] = self.noteTextView.text;
        
        [CurrSection saveInBackgroundWithBlock:^(BOOL succeeded , NSError* error)
         {
             if (succeeded) {
                 PFObject *newPost = [PFObject objectWithClassName:@"Inspections"];
                 [newPost setObject:self.propertyID forKey:@"propertyID"];
                 [newPost setObject:[PFUser currentUser] forKey:@"userID"];
                 [newPost saveInBackground];
                 
                 PFQuery *query = [PFQuery queryWithClassName:@"Properties"];
                 [query whereKey:@"userID" equalTo:[PFUser currentUser]];
                 [query getObjectInBackgroundWithId:self.propertyID.objectId block:^(PFObject *CurrProperty, NSError *error) {
                     CurrProperty[@"lastInspectionDate"] = [NSDate date];
                     [CurrProperty saveInBackground];
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }];
             }
         }];
        
    }];
    
    
}

- (IBAction)backButtonPressed:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseStatusPressed:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int statusType = btn.tag;
    
    switch (statusType) {
        case 0:
            //fair
            sectionStatus = [NSNumber numberWithInt:0];
            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_green_btn"] forState:UIControlStateNormal];
            [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_btn"] forState:UIControlStateNormal];
            [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_btn"] forState:UIControlStateNormal];
            [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_btn"] forState:UIControlStateNormal];
            [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_btn"] forState:UIControlStateNormal];
            [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_btn"] forState:UIControlStateNormal];

            break;
        case 1:
            //dirty
            sectionStatus = [NSNumber numberWithInt:1];
            [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_green_btn"] forState:UIControlStateNormal];
            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_btn"] forState:UIControlStateNormal];
            [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_btn"] forState:UIControlStateNormal];
            [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_btn"] forState:UIControlStateNormal];
            [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_btn"] forState:UIControlStateNormal];
            [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_btn"] forState:UIControlStateNormal];
            

            break;
        case 2:
            //noticed
            sectionStatus = [NSNumber numberWithInt:2];
            [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_green_btn"] forState:UIControlStateNormal];
            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_btn"] forState:UIControlStateNormal];
            [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_btn"] forState:UIControlStateNormal];
            [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_btn"] forState:UIControlStateNormal];
            [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_btn"] forState:UIControlStateNormal];
            [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_btn"] forState:UIControlStateNormal];
            

            break;
        case 3:
            //good
            sectionStatus = [NSNumber numberWithInt:3];
            [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_green_btn"] forState:UIControlStateNormal];
            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_btn"] forState:UIControlStateNormal];
            [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_btn"] forState:UIControlStateNormal];
            [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_btn"] forState:UIControlStateNormal];
            [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_btn"] forState:UIControlStateNormal];
            [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_btn"] forState:UIControlStateNormal];
            

            break;
        case 4:
            //cleaned
            sectionStatus = [NSNumber numberWithInt:4];
            [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_green_btn"] forState:UIControlStateNormal];
            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_btn"] forState:UIControlStateNormal];
            [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_btn"] forState:UIControlStateNormal];
            [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_btn"] forState:UIControlStateNormal];
            [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_btn"] forState:UIControlStateNormal];
            [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_btn"] forState:UIControlStateNormal];

            break;
//        case 5:
//            //corrupt
//            sectionStatus = [NSNumber numberWithInt:5];
//            [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_green_btn"] forState:UIControlStateNormal];
//            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_btn"] forState:UIControlStateNormal];
//            [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_btn"] forState:UIControlStateNormal];
//            [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_btn"] forState:UIControlStateNormal];
//            [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_btn"] forState:UIControlStateNormal];
//            [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_btn"] forState:UIControlStateNormal];
//         
//            break;
            
        default:
            sectionStatus = [NSNumber numberWithInt:0];
            [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_green_btn"] forState:UIControlStateNormal];

            break;
    }
}

- (IBAction)buttonBrokenPrss:(id)sender {
    sectionStatus = [NSNumber numberWithInt:5];
    [self.buttonBroken setImage:[UIImage imageNamed:@"broken_circle_green_btn"] forState:UIControlStateNormal];
    [self.fairButton setImage:[UIImage imageNamed:@"ok_circle_btn"] forState:UIControlStateNormal];
    [self.dirtyButton setImage:[UIImage imageNamed:@"dirty_circle_btn"] forState:UIControlStateNormal];
    [self.noticeButton setImage:[UIImage imageNamed:@"notice_circle_btn"] forState:UIControlStateNormal];
    [self.goodButton setImage:[UIImage imageNamed:@"good_circvle_btn"] forState:UIControlStateNormal];
    [self.cleanButton setImage:[UIImage imageNamed:@"clean_circle_btn"] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([@"من الكاميرا" isEqualToString:buttonTitle]) {
        [self takePhotoWithCamera];
    }
    else if ([@"من مكتبة الصور" isEqualToString:buttonTitle]) {
        [self selectPhotoFromLibrary];
    }
}

-(void) takePhotoWithCamera {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        
        // Delegate is self
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        
        // Show image picker
        //[self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

-(void) selectPhotoFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}



@end
