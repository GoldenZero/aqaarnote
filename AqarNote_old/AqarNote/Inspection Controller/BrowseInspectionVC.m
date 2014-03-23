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
    NSMutableArray *pageImages;
    NSInteger pageCount;
    NSMutableArray *pageViews;
    
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
    
    pageImages=[[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
    self.sectionTitle.text = [self.sectionID objectForKey:@"name"];
    self.inputAccessoryView = [XCDFormInputAccessoryView new];
    [self loadSectionPhoto];

}

-(void)viewWillAppear:(BOOL)animated{
    [self setScrollView];

}

#pragma mark - Buttons Actions


- (IBAction)uploadImagePressed:(id)sender {
    
    // Add uploaded image to the scrollView
    if (pageImages.count==3) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil, nil];
        
        av.alertViewStyle = UIAlertViewStyleDefault;
        [av show];
        
    }
    else{
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"إلغاء"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"من الكاميرا", @"من مكتبة الصور", nil];
        
        [as showInView:self.view];
    }
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //[self.uploadImageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
  
        // Add uploaded image to the scrollView
        if (pageImages.count==3) {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:nil, nil];
            
            av.alertViewStyle = UIAlertViewStyleDefault;
            [av show];
            
        }
        else{
            UIImage *currentImage=[[UIImage alloc] initWithData:imageData];
            [pageImages addObject:currentImage];
            pageCount=[pageImages count];
            [self setScrollView];
            
        }

}


- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"post new inspection");
    // update sections
    PFQuery *query = [PFQuery queryWithClassName:@"Sections"];
    [query whereKey:@"userID" equalTo:[PFUser currentUser]];
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"يتم الآن الحفظ";
    [HUD show:YES];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    for (int i=0; i<pageImages.count; i++) {
        NSData *imageData = UIImagePNGRepresentation((UIImage*)[pageImages objectAtIndex:i]);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        
        // Save PFFile
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
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
                }
            
                else{
                // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
        else{
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
        
    }// end for loop
    
    [HUD hide:YES];
    
    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.sectionID.objectId block:^(PFObject *CurrSection, NSError *error) {
        
        // Now let's update it with some new data.
        // will get sent to the cloud.
        CurrSection[@"status"] = sectionStatus;
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



#pragma mark - paging & scrollView

-(void)setScrollView{
    self.pageControl.currentPage = pageCount;
    self.pageControl.numberOfPages = pageCount;
    CGSize pagesScrollViewSize = self.pagingScrollView.frame.size;
    self.pagingScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [pageViews addObject:[NSNull null]];
    }
    [self loadVisiblePages];
    
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.pagingScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.pagingScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    for (NSInteger i=lastPage+1; i<pageImages.count; i++) {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= pageImages.count) {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    else{
        // Load an individual page, first checking if you've already loaded it
        UIView *pageView = [pageViews objectAtIndex:page];
        
        if ((NSNull*)pageView == [NSNull null]) {
            CGRect frame = self.pagingScrollView.bounds;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 10.0f, 0.0f);
            
            UIImageView *newPageView = [[UIImageView alloc] initWithImage:[pageImages objectAtIndex:page]];
            
            newPageView.contentMode = UIViewContentModeScaleAspectFit;
            newPageView.frame = frame;
            [self.pagingScrollView addSubview:newPageView];
            [pageViews replaceObjectAtIndex:page withObject:newPageView];
        }
        
    }
}

- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

//
-(void)loadSectionPhoto{
    
    PFQuery *currentSection = [PFQuery queryWithClassName:@"SectionPhoto"];
    [currentSection whereKey:@"sectionID" equalTo:self.sectionID];
    [currentSection whereKey:@"propertyID" equalTo:self.propertyID];
    
    [currentSection findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            PFFile *theImage;
            for (PFObject* ob in objects) {
                theImage = [ob objectForKey:@"imageFile"];
                UIImage *image=[UIImage imageWithData:[theImage getData]];
                [pageImages addObject:image];
            }
        }
        pageCount=pageImages.count;
        
        [self setScrollView];
    }];
    
}
@end
