//
//  AddNewAqarVC.m
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AddNewAqarVC.h"

@interface AddNewAqarVC ()
{
    NSMutableArray* mainSectionsArray;
    NSMutableArray* sectionsArray;
    NSMutableArray* chosenSectionArray;
    PFObject * currentImageID;
    int view_y;
    
}
@end

@implementation AddNewAqarVC

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
    mainSectionsArray = [NSMutableArray new];
    [mainSectionsArray addObject:@"kitchen"];
    [mainSectionsArray addObject:@"living room"];
    [mainSectionsArray addObject:@"bed room"];
    [mainSectionsArray addObject:@"bath room"];
    [mainSectionsArray addObject:@"dining room"];
    [mainSectionsArray addObject:@"garden"];
    
    [self getExistSection];
//    [self prepareSections];
	// Do any additional setup after loading the view.
}

-(void)getExistSection
{
    PFQuery *sectionQuery = [PFQuery queryWithClassName:@"Sections"];
    [sectionQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    
    // Run the query
    [sectionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Save results and update the table
            if ([objects count] == 0) {
                [self prepareSections];
            }else
            {
                sectionsArray = [[NSMutableArray alloc] initWithArray:objects];
                chosenSectionArray = [[NSMutableArray alloc] initWithArray:objects];
                
                sectionsArray = [self compareSectionsArray:mainSectionsArray andArray:sectionsArray];
                
                [self prepareExistingSections];
            }
        }
    }];
}

-(void)prepareSections
{
    view_y = 0;

    sectionsArray = [NSMutableArray new];
    chosenSectionArray = [NSMutableArray new];
    sectionsArray = mainSectionsArray;
    
    
    for (int i = 0; i < [sectionsArray count]; i++) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, view_y, 320, 50)];
        UIImage* img = [UIImage imageNamed:@"secIcon.png"];
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 15, 15, 15)];
        [imgView setImage:img];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = [sectionsArray objectAtIndex:i];
        
        UIButton* secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        secBtn.frame = CGRectMake(0, 0, 320, 50);
        secBtn.backgroundColor = [UIColor clearColor];
        [secBtn setBackgroundImage:[UIImage imageNamed:@"UnActiveSelectDefuilt.png"] forState:UIControlStateNormal];
        [secBtn setBackgroundImage:[UIImage imageNamed:@"activeSelectDefuilt.png"] forState:UIControlStateSelected];
        [secBtn addTarget:self action:@selector(sectionPressed:) forControlEvents:UIControlEventTouchUpInside];
        secBtn.tag = i;
        
        if (i == 0 || i == 1 || i == 3) {
            [secBtn setSelected:YES];
            [chosenSectionArray addObject:[sectionsArray objectAtIndex:i]];
        }
        
        [v addSubview:titleLabel];
        [v addSubview:imgView];
        [v addSubview:secBtn];
        
        [self.sectionScrollView addSubview:v];
        if (view_y > 236) {
            self.sectionScrollView.contentSize = CGSizeMake(320, view_y + 50);
        }
        view_y += 50;
        
        
        
    }


}


-(void)prepareExistingSections
{
    view_y = 0;
    chosenSectionArray = [NSMutableArray new];

    
    for (int i = 0; i < [mainSectionsArray count]; i++) {
        
        //PFObject* sect = [sectionsArray objectAtIndex:i];
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, view_y, 320, 50)];
        UIImage* img = [UIImage imageNamed:@"secIcon.png"]; // TODO [sect objectForKey:@"icon"];
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 15, 15, 15)];
        [imgView setImage:img];
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = [mainSectionsArray objectAtIndex:i];
        
        UIButton* secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        secBtn.frame = CGRectMake(0, 0, 320, 50);
        secBtn.backgroundColor = [UIColor clearColor];
        [secBtn setBackgroundImage:[UIImage imageNamed:@"UnActiveSelectDefuilt.png"] forState:UIControlStateNormal];
        [secBtn setBackgroundImage:[UIImage imageNamed:@"activeSelectDefuilt.png"] forState:UIControlStateSelected];
        [secBtn addTarget:self action:@selector(sectionPressed:) forControlEvents:UIControlEventTouchUpInside];
        secBtn.tag = i;
        
        if (![self isExistingInArray:[mainSectionsArray objectAtIndex:i] andArray:sectionsArray]) {
            [secBtn setSelected:YES];
            [chosenSectionArray addObject:[mainSectionsArray objectAtIndex:i]];

        }
        
       // [secBtn setSelected:![self isExistingInArray:[mainSectionsArray objectAtIndex:i] andArray:sectionsArray]];
        
        [v addSubview:titleLabel];
        [v addSubview:imgView];
        [v addSubview:secBtn];
        
        [self.sectionScrollView addSubview:v];
        if (view_y > 236) {
            self.sectionScrollView.contentSize = CGSizeMake(320, view_y + 50);
        }
        view_y += 50;
    }
}

-(NSMutableArray*)compareSectionsArray:(NSMutableArray*)arrOfString andArray:(NSMutableArray*)arrOfObject
{
    NSMutableArray* comparedArr = [NSMutableArray new];
    BOOL isMatching;
    for (NSString* pfString in arrOfString) {
        for (PFObject* pf in arrOfObject) {
            if ([[pf objectForKey:@"name"] isEqualToString:pfString]) {
                isMatching = YES;
                break;
            }else
            {
                isMatching = NO;
                continue;
            }
        }
        if (!isMatching) {
            [comparedArr addObject:pfString];
        }
    }
    
    return comparedArr;
}

-(BOOL)isExistingInArray:(NSString*)SecString andArray:(NSMutableArray*)arrOfString
{
    BOOL isMatching;
        for (NSString* pf in arrOfString) {
            if ([pf isEqualToString:SecString]) {
                isMatching = YES;
                break;
            }else
            {
                isMatching = NO;
                continue;
            }
        }
    
    return isMatching;
}

-(void)sectionPressed:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int currentIndex = btn.tag;
    [chosenSectionArray addObject:[mainSectionsArray objectAtIndex:currentIndex]];
    [btn setSelected:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
            PFObject *userPhoto = [PFObject objectWithClassName:@"PropertyPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            
            // Set the access control list to current user for security purposes
            userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            PFUser *user = [PFUser currentUser];
            [userPhoto setObject:user forKey:@"user"];
            
            [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    PFQuery *photoQuery = [PFQuery queryWithClassName:@"PropertyPhoto"];
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

- (void)setUpImages:(NSArray *)images
{
    
}

#pragma mark uitextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (IBAction)addButtonPressed:(id)sender {
    
  
}

- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"post new property");
    // Create Post
    PFObject *newPost = [PFObject objectWithClassName:@"Properties"];
   
    // Set property
    [newPost setObject:self.propertyTitle.text forKey:@"Title"];
    [newPost setObject:self.country.text forKey:@"country"];
    [newPost setObject:self.city.text forKey:@"city"];
    //[newPost setObject:chosenSectionArray forKey:@"sections"];
    if (currentImageID)
        [newPost setObject:currentImageID forKey:@"imageID"];
    
    [newPost setObject:[PFUser currentUser] forKey:@"userID"];

    //set section with property
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:newPost];
    for (int i = 0; i < [mainSectionsArray count]; i++) {
        PFObject *newSec = [PFObject objectWithClassName:@"Sections"];
        [newSec setObject:[PFUser currentUser] forKey:@"userID"];
        [newSec setObject:[chosenSectionArray objectAtIndex:i] forKey:@"name"];
        [newSec setObject:@"secIcon.png" forKey:@"icon"];
        [newSec setObject:newPost forKey:@"propertyID"];
        [arr addObject:newSec];

    }

    [PFObject saveAllInBackground:arr block:^(BOOL succeeded, NSError* error)
     {
         if (!error) {
             
             // [newSec setObject:[PFUser currentUser] forKey:@"userID"];
             
             [self dismissViewControllerAnimated:YES completion:nil];
         }
         
     }];
    
    // Create relationship
   // [newPost setObject:[PFUser currentUser] forKey:@"owner"];
    
    // Save the new post
  /*  [newPost saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
           // [newSec setObject:[PFUser currentUser] forKey:@"userID"];

            [self dismissViewControllerAnimated:YES completion:nil];

        }
    }];*/

    
    //[self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cancelButtonPressed:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate Method

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
