//
//  EditPropertyVC.m
//  AqarNote
//
//  Created by Noor on 5/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "EditPropertyVC.h"
#import "SectionCell.h"
#import "countryObject.h"
#import "SectionObject.h"

#pragma mark - Country JSON file keys

#define COUNTRIES_FILE_NAME         @"Countries"
#define COUNTRY_ID_JSONK            @"CountryID"
#define COUNTRY_NAME_JSONK          @"CountryName"
#define COUNTRY_NAME_EN_JSONK       @"CountryNameEn"
#define COUNTRY_CURRENCY_ID_JSONK   @"CurrencyID"
#define COUNTRY_DISPLAY_ORDER_JSONK @"DisplayOrder"
#define COUNTRY_CODE_JSONK          @"CountryCode"


@interface EditPropertyVC (){
    
    NSMutableArray* mainSectionsArray;
    NSMutableArray *pageImages;
    NSArray *countriesArray;
    NSMutableArray* sectionsArray;
    NSInteger pageCount;
    NSMutableArray *pageViews;
    NSString * chosenCountry;

}

@end

@implementation EditPropertyVC

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
    
    [self prepareViewComponents];
    
    // Show loading indicator
    loadingIndicator.labelText=@"جاري تحميل الأقسام..";
    [loadingIndicator show:YES];

    
    sectionsArray=[[NSMutableArray alloc] init];
    for (int i=0; i<self.propertySectionsArray.count; i++) {
        PFObject *sect=[self.propertySectionsArray objectAtIndex:i];
        SectionObject *obj=[[SectionObject alloc] initWithObject:sect andChosenFlag:YES andDeletFlag:YES andAddFlag:NO];
        [sectionsArray addObject:obj];
    }
    
    for (int i=0; i<mainSectionsArray.count; i++) {
        BOOL equlFlag=false;
        for (int j=0; j<sectionsArray.count; j++) {
            if ([(NSString*)[mainSectionsArray objectAtIndex:i] isEqualToString:[[(SectionObject*)[ sectionsArray objectAtIndex:j] sectionPFObject] objectForKey:@"name"]]) {
                equlFlag=true;
                break;
            }
        }
        if (!equlFlag) {
            PFObject *newSec = [PFObject objectWithClassName:@"Sections"];
            [newSec setObject:[PFUser currentUser] forKey:@"userID"];
            [newSec setObject:(NSString*)[mainSectionsArray objectAtIndex:i] forKey:@"name"];
            [newSec setObject:@"secIcon.png" forKey:@"icon"];
            [newSec setObject:self.propertyID forKey:@"propertyID"];

            [sectionsArray addObject:[[SectionObject alloc] initWithObject:newSec andChosenFlag:NO andDeletFlag:NO andAddFlag:YES]];
        }
     
    }
    
    [self prepareExistingSections];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"showAddSection"])  //parameter to map for update
    {
        AddNewSectionVC* vc = segue.destinationViewController;
        vc.delegate=self;
        
    }
}

// Prepare fonts & intialize controls & variables
- (void) prepareViewComponents{
   
    // Set custom font
    self.propertyTitleTxtField.font=[UIFont fontWithName:@"Tahoma" size:12];
    self.countryTxtField.font=[UIFont fontWithName:@"Tahoma" size:12];
    self.cityTxtField.font=[UIFont fontWithName:@"Tahoma" size:12];
    self.sectionsLabel.font=[UIFont fontWithName:@"HacenSudan" size:16];
    self.screenLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    self.cancelButton.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    self.saveButton.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    
    // Set custom keyboard
    [self.propertyTitleTxtField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.cityTxtField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    
    // Set picker view
    countriesPicker = [SBPickerSelector picker];
    countriesPicker.delegate = self;
    countriesPicker.pickerType = SBPickerSelectorTypeText;
    countriesPicker.doneButtonTitle = @"تم";
    countriesPicker.cancelButtonTitle = @"إغلاق";
    
    // Set HUD
    loadingIndicator = [[MBProgressHUD alloc] initWithView:self.sectionsTableView];
    loadingIndicator.delegate = self;
    loadingIndicator.labelFont=[UIFont fontWithName:@"Tahoma" size:15];

    // Initialize Main Sections Array
    mainSectionsArray = [NSMutableArray new];
    [mainSectionsArray addObject:@"المطبخ"];
    [mainSectionsArray addObject:@"غرفة المعيشة"];
    [mainSectionsArray addObject:@"غرفة النوم"];
    [mainSectionsArray addObject:@"الحمام"];
    [mainSectionsArray addObject:@"غرفة الطعام"];
    [mainSectionsArray addObject:@"الحديقة"];
    
    // Initialize Variables
    pageImages=[[NSMutableArray alloc] init];
    [self loadCountries];

    // Load Property details to view
    self.propertyTitleTxtField.text = [self.propertyID objectForKey:@"Title"];
    self.countryTxtField.text = [self.propertyID objectForKey:@"country"];
    self.cityTxtField.text=[self.propertyID objectForKey:@"city"];
    
    // Load property images
    pageImages=[[NSMutableArray alloc] initWithArray:self.propertyImages];
    
    pageCount=pageImages.count;
    if (pageCount==1||pageCount==0) {
        [self.nxtPhotoButton setHidden:YES];
        [self.prevPhotoButton setHidden:YES];
    }
    else {
        self.nxtPhotoButton.hidden=NO;
        self.prevPhotoButton.hidden=YES;
        
    }
    [self setScrollView];


}

#pragma mark - Buttons Actions

- (IBAction)addNewSection:(id)sender {
    
    [self performSegueWithIdentifier:@"showAddSection" sender:self];

}

- (IBAction)saveBtnPrss:(id)sender {
    [self.countryTxtField resignFirstResponder];
    [self.cityTxtField resignFirstResponder];
    [self.propertyTitleTxtField resignFirstResponder];
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    
    // Check filling information 
    
    if ([self.propertyTitleTxtField.text length] == 0 || self.propertyTitleTxtField.text == nil || [self.propertyTitleTxtField.text isEqual:@""] == TRUE) {
        
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء إدخال عنوان الشقة" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
        
    }
    else if ([self.cityTxtField.text length] == 0 || self.cityTxtField.text == nil || [self.cityTxtField.text isEqual:@""] == TRUE) {
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء إدخال المدينة" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
        
    }
    
    else if ([chosenCountry isEqual:nil]) {
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء إدخال الدولة" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
        
    }
    
    else{
        // Set HUD
        loadingIndicator = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view.window addSubview:loadingIndicator];
        loadingIndicator.delegate = self;
        loadingIndicator.labelFont=[UIFont fontWithName:@"Tahoma" size:15];
        loadingIndicator.labelText = @"يتم الآن التعديل...";
        [loadingIndicator show:YES];
        
        NSMutableArray  *deletedSections=[[NSMutableArray alloc] init];
        
        for (int i=0; i<sectionsArray.count; i++) {
            
            if ((![(SectionObject*)[sectionsArray objectAtIndex:i] SectionChosen])&&([(SectionObject*)[sectionsArray objectAtIndex:i] DeleteIfRemoved])) {
                [deletedSections addObject:[(SectionObject*)[sectionsArray objectAtIndex:i] sectionPFObject]];
            }
        }
        
        NSMutableArray *toAddSections=[[NSMutableArray alloc] init];

        for (int i=0; i<sectionsArray.count; i++) {
            
            if (([(SectionObject*)[sectionsArray objectAtIndex:i] SectionChosen])&&([(SectionObject*)[sectionsArray objectAtIndex:i] AddIfChosed])) {
                [toAddSections addObject:[(SectionObject*)[sectionsArray objectAtIndex:i] sectionPFObject]];
            }
        }
        

        // 1- Delete photos of deletedSections from SectionsPhotos
        
        for (int i=0; i<deletedSections.count; i++) {
            PFQuery *query = [PFQuery queryWithClassName:@"SectionPhoto"];
            [query whereKey:@"sectionID" equalTo:(PFObject*)[deletedSections objectAtIndex:i]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    [PFObject deleteAll:objects];
                    
                }
                else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }

        // 2- Delete old sections
        if (deletedSections.count!=0) {
            [PFObject deleteAll:deletedSections];
        }
        
        // 3- Delete old properties photo
        PFQuery *currentProperty = [PFQuery queryWithClassName:@"PropertyPhoto"];
        [currentProperty whereKey:@"propertyID" equalTo:self.propertyID];
        [currentProperty findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (!error) {
                [PFObject deleteAll:objects];
                
                // 4- Save new images
                for (int i=0; i<pageImages.count; i++) {
                    NSData *imageData = UIImagePNGRepresentation((UIImage*)[pageImages objectAtIndex:i]);
                    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
                    [imageFile save];
                    PFObject *userPhoto = [PFObject objectWithClassName:@"PropertyPhoto"];
                    [userPhoto setObject:imageFile forKey:@"imageFile"];
                    userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                    PFUser *user = [PFUser currentUser];
                    [userPhoto setObject:user forKey:@"user"];
                    [userPhoto setObject:self.propertyID forKey:@"propertyID"];
                    [userPhoto save];
                    
                }// end for loop
                
                // 5- Add new sections
        
                
                if (toAddSections.count!=0) {
                    [PFObject saveAllInBackground:toAddSections block:^(BOOL succeeded, NSError* error){
                        if (succeeded) {
                            // 6- Update property info
                                [self.propertyID setObject:self.propertyTitleTxtField.text forKey:@"Title"];
                                [self.propertyID setObject:self.countryTxtField.text forKey:@"country"];
                                [self.propertyID setObject:self.cityTxtField.text forKey:@"city"];
                                // [pfObject setObject:self.descriptionsTxtView.text forKey:@"Description"];
                                [self.propertyID setObject:[PFUser currentUser] forKey:@"userID"];
                                [self.propertyID saveInBackgroundWithBlock:^(BOOL done, NSError *error) {
                                        if (done) {
                                            [loadingIndicator hide:YES];
                                            
                                            AlertView *alert2=[[AlertView alloc] initWithTitle:@"تم" message:@"لقد تم تعديل عقارك بنجاح" cancelButtonTitle:nil WithFont:@"Tahoma"];
                                            alert2.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                                            alert2.customButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                                            [alert2 addButtonWithTitle:@"موافق"
                                                                  type:AlertViewButtonTypeCustom
                                                               handler:^(AlertView *alertView, AlertButtonItem *button) {
                                                                   // Dismiss alertview
                                                                   [alertView dismiss];
                                                                   [self.delegate editedProperty:self.propertyID withImages:pageImages andSections:sectionsArray];
                                                                   
                                                                   [self dismissViewControllerAnimated:YES completion:nil];
                                                               }];
                                            
                                            [alert2 show];
                                            
                                        }
                                }]; // End of save property
                            
                        }// end of succeddd if
                    }];//end of save
                }// end of if
                
                else{
                    // Retrieve the object by id
                        [self.propertyID setObject:self.propertyTitleTxtField.text forKey:@"Title"];
                        [self.propertyID setObject:self.countryTxtField.text forKey:@"country"];
                        [self.propertyID setObject:self.cityTxtField.text forKey:@"city"];
                        //  [pfObject setObject:self.descriptionsTxtView.text forKey:@"Description"];
                        //[pfObject setObject:chosenSectionArray forKey:@"sections"];
                        [self.propertyID setObject:[PFUser currentUser] forKey:@"userID"];
                        [self.propertyID saveInBackgroundWithBlock:^(BOOL done, NSError *error) {
                                if (done) {
                                    [loadingIndicator hide:YES];
                                    
                                    AlertView *alert2=[[AlertView alloc] initWithTitle:@"تم" message:@"لقد تم تعديل عقارك بنجاح" cancelButtonTitle:nil WithFont:@"Tahoma"];
                                    alert2.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                                    alert2.customButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                                    [alert2 addButtonWithTitle:@"موافق"
                                                          type:AlertViewButtonTypeCustom
                                                       handler:^(AlertView *alertView, AlertButtonItem *button) {
                                                           // Dismiss alertview
                                                           [alertView dismiss];
                                                           [self.delegate editedProperty:self.propertyID withImages:pageImages andSections:sectionsArray];
                                                           
                                                            [self dismissViewControllerAnimated:YES completion:nil];
                                                       }];
                                    
                                    [alert2 show];
                                }
                        }]; // End of updating property data
                    
                }// end of else
            }
        }];    

    }

}

- (IBAction)cancelBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)countryBtnPrss:(id)sender {
    [self.countryTxtField resignFirstResponder];
    [self.cityTxtField resignFirstResponder];
    [self.propertyTitleTxtField resignFirstResponder];
    [self showPicker:nil];
}

- (IBAction)uploadPhotoBtnPrss:(id)sender {
    // Add uploaded image to the scrollView
    if (pageImages.count==3) {
        
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" cancelButtonTitle:@"إلغاء" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
        
        
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

- (IBAction)nxtPhotoBtnPrss:(id)sender {
    [self.prevPhotoButton setHidden:NO];
    int page=self.pageControl.currentPage;
    if (page<pageImages.count) {
        page++;
        CGRect frame = self.imagesScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.imagesScrollView scrollRectToVisible:frame animated:YES];
        
        if (page==pageImages.count-1){
            [self.nxtPhotoButton setHidden:YES];
        }
        
    }
}

- (IBAction)prevPhotoBtnPrss:(id)sender {
    [self.nxtPhotoButton setHidden:NO];
    int page=self.pageControl.currentPage;
    if (page>0) {
        page--;
        CGRect frame = self.imagesScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.imagesScrollView scrollRectToVisible:frame animated:YES];
        
    }
    if (page==0){
        [self.prevPhotoButton setHidden:YES];
    }

}

#pragma mark - UITextFieldDelegate protocol

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    
    [textField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    
}

#pragma mark - UITableView Delegate Handler

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sectionsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    SectionCell *cell = (SectionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    cell.sectionLabel.text=[[(SectionObject*)[ sectionsArray objectAtIndex:indexPath.row] sectionPFObject] objectForKey:@"name"];
    cell.sectionLabel.font=[UIFont fontWithName:@"Tahoma" size:12];
    [cell.sectionButtonPrssed setBackgroundColor:[UIColor clearColor]];
    if ([(SectionObject*)[sectionsArray objectAtIndex:indexPath.row] SectionChosen]) {
        [cell.sectionButtonPrssed setImage:[UIImage imageNamed:@"green_dot_option.png"] forState:UIControlStateNormal];
        
    }
    else{
        [cell.sectionButtonPrssed setImage:[UIImage imageNamed:@"white_dot_option.png"] forState:UIControlStateNormal];
        
    }
    //    [cell.sectionButtonPrssed addTarget:self action:@selector(sectionPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    cell.sectionButtonPrssed.tag = indexPath.row;
    //
    // Load section icon
    
    if ([cell.sectionLabel.text isEqualToString:@"المطبخ"]||[cell.sectionLabel.text isEqualToString:@"Kitchen"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"cooknig_icon"];
    }
    
    else if ([cell.sectionLabel.text isEqualToString:@"غرفة المعيشة"]||[cell.sectionLabel.text isEqualToString:@"living room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"Lobby_icon"];
    }
    
    else if ([cell.sectionLabel.text isEqualToString:@"غرفة النوم"]||[cell.sectionLabel.text isEqualToString:@"bed room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"badroom_icon"];
    }
    
    else if ([cell.sectionLabel.text isEqualToString:@"الحمام"]||[cell.sectionLabel.text isEqualToString:@"bath room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"bathroom_icon"];
    }
    
    else if ([cell.sectionLabel.text isEqualToString:@"غرفة الطعام"]||[cell.sectionLabel.text isEqualToString:@"dining room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"dining_room_icon"];
    }
    else if ([cell.sectionLabel.text isEqualToString:@"الحديقة"]||[cell.sectionLabel.text isEqualToString:@"garden"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"garden_room_icon"];
    }
    else{
        cell.sectionImage.image=[UIImage imageNamed:@"icon9"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionCell *cell = (SectionCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIButton* btn = (UIButton*)[cell sectionButtonPrssed];
    
    if ([(SectionObject*)[sectionsArray objectAtIndex:indexPath.row] SectionChosen]) {
        [(SectionObject*)[sectionsArray objectAtIndex:indexPath.row] setSectionChosen:NO];
        [btn setImage:[UIImage imageNamed:@"white_dot_option.png"] forState:UIControlStateNormal];
        
    }
    else{
        [(SectionObject*)[sectionsArray objectAtIndex:indexPath.row] setSectionChosen:YES];
        [btn setImage:[UIImage imageNamed:@"green_dot_option.png"] forState:UIControlStateNormal];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)sectionPressed:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    int currentIndex = btn.tag;
    
    if (  [(SectionObject*)[sectionsArray objectAtIndex:currentIndex] SectionChosen]) {
        [(SectionObject*)[sectionsArray objectAtIndex:currentIndex] setSectionChosen:NO];
        [btn setImage:[UIImage imageNamed:@"white_dot_option.png"] forState:UIControlStateNormal];
        
    }
    else{
        [(SectionObject*)[sectionsArray objectAtIndex:currentIndex] setSectionChosen:YES];
        [btn setImage:[UIImage imageNamed:@"green_dot_option.png"] forState:UIControlStateNormal];
        
        
    }
    
    // [self.sectionsTableView reloadData];
}


#pragma mark - UIImagePicker Delegate Handler

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //  [self.uploadImageBtn setBackgroundImage:image forState:UIControlStateNormal];
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    // Add uploaded image to the scrollView
    if (pageImages.count==3) {
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
        
    }
    else{
        UIImage *currentImage=[[UIImage alloc] initWithData:imageData];
        [pageImages addObject:currentImage];
        pageCount=[pageImages count];
        [self setScrollView];
        
    }
}

- (void)setUpImages:(NSArray *)images
{
    
}

#pragma mark - AGPhotoBrowser Delegate Handler

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
	return pageImages.count;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
	return [pageImages objectAtIndex:index];
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
	return @"";
}

- (NSString *)photoBrowser:(AGPhotoBrowserView *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
	return @"";
}

- (BOOL)photoBrowser:(AGPhotoBrowserView *)photoBrowser willDisplayActionButtonAtIndex:(NSInteger)index
{
    
    return YES;
}


- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	// -- Dismiss
	[self.browserView hideWithCompletion:^(BOOL finished){
		NSLog(@"Dismissed!");
	}];
}

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
    photoAction = [[UIActionSheet alloc] initWithTitle:@""
                                              delegate:self
                                     cancelButtonTitle:NSLocalizedString(@"إلغاء", @"Cancel button")
                                destructiveButtonTitle:nil
                                     otherButtonTitles:NSLocalizedString(@"حذف", @"Delete button"),NSLocalizedString(@"إضافة", @"Delete button"), nil];
    photoAction.tag=index;
    
    
    [photoAction showInView:self.view];
}

- (AGPhotoBrowserView *)browserView
{
	if (!_browserView) {
		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
		_browserView.delegate = self;
		_browserView.dataSource = self;
	}
	
	return _browserView;
}

#pragma mark - Enhanced Keyboard Delegate Handler

- (void)doneDidTouchDown
{
    if ([self.propertyTitleTxtField isEditing]) {
        [self.propertyTitleTxtField resignFirstResponder];
    }
    
    else if ([self.cityTxtField isEditing]) {
        [self.cityTxtField resignFirstResponder];
    }
    
    else{
    }
}

#pragma mark - Picker view Delegate Handler
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    chosenCountry=(NSString*)[countriesArray objectAtIndex:idx];
    self.countryTxtField.text=chosenCountry ;
}

-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // resultLbl_.text = [dateFormat stringFromDate:date];
}

-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    NSLog(@"press cancel");
}

-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
    if ([value isMemberOfClass:[NSDate class]]) {
        [self SBPickerSelector:selector dateSelected:value];
    }else{
        [self SBPickerSelector:selector selectedValue:value index:idx];
    }
}

- (void) showPicker:(id)sender{
    
    CGPoint point = [self.view convertPoint:[sender frame].origin fromView:[sender superview]];
    CGRect frame = [sender frame];
    frame.origin = point;
    //[picker showPickerOver:self]; //classic picker display
    
    [countriesPicker showPickerIpadFromRect:CGRectZero inView:self.view];
    
}

#pragma mark - UIActionSheetDelegate Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet==photoAction) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"حذف"]) {
            [self.browserView hideWithCompletion:^(BOOL finished){
                NSLog(@"Dismissed!");
            }];
            [self purgePage:actionSheet.tag];
            [pageImages removeObjectAtIndex:actionSheet.tag];
            pageCount=pageImages.count;
            [self setScrollView];
        }
        else if ([buttonTitle isEqualToString:@"إضافة"]){
            [self.browserView hideWithCompletion:^(BOOL finished){
                NSLog(@"Dismissed!");
            }];
            
            // Add uploaded image to the scrollView
            if (pageImages.count==3) {
                AlertView *alert1=[[AlertView alloc] initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" cancelButtonTitle:@"إلغاء" WithFont:@"Tahoma"];
                alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                [alert1 show];
                
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
        
        
    }
    else{
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([@"من الكاميرا" isEqualToString:buttonTitle]) {
            [self takePhotoWithCamera];
        }
        else if ([@"من مكتبة الصور" isEqualToString:buttonTitle]) {
            [self selectPhotoFromLibrary];
        }
        
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


- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *_currentView in actionSheet.subviews) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            [((UIButton *)_currentView).titleLabel setFont:[UIFont fontWithName:@"HacenSudan" size:14]];
            [((UIButton *)_currentView).titleLabel setTextColor:[UIColor blackColor]];
        }
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

#pragma mark - Load Data

- (void) loadCountries{
    
    NSData *countriesData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:COUNTRIES_FILE_NAME ofType:@"json"]];
    
    NSArray * countriesParsedArray = [NSJSONSerialization JSONObjectWithData:countriesData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray * resultCountries = [NSMutableArray new];
    for (NSDictionary * countryDict in countriesParsedArray)
    {
        //create country object
        countryObject * country = [[countryObject alloc]
                                   initWithCountryIDString:[countryDict objectForKey:COUNTRY_ID_JSONK]
                                   countryName:[countryDict objectForKey:COUNTRY_NAME_JSONK]
                                   countryNameEn:[countryDict objectForKey:COUNTRY_NAME_EN_JSONK]
                                   currencyIDString:[countryDict objectForKey:COUNTRY_CURRENCY_ID_JSONK]
                                   displayOrderString:[countryDict objectForKey:COUNTRY_DISPLAY_ORDER_JSONK]
                                   countryCodeString:[countryDict objectForKey:COUNTRY_CODE_JSONK]
                                   ];
        
        //add country
        [resultCountries addObject:country.countryName];
    }
    countriesArray=resultCountries;
    
    countriesPicker.pickerData = [[NSMutableArray alloc] initWithArray:countriesArray];
    
}


-(void)prepareExistingSections
{
    [self.sectionsTableView reloadData];
    
    CGRect frame = self.sectionsTableView.frame;
    frame.size.height = self.sectionsTableView.contentSize.height;
    self.sectionsTableView.frame = frame;
    
    CGFloat scrollViewHeight = 60.0f;
    scrollViewHeight+=self.imagesScrollView.frame.size.height;
    scrollViewHeight+=self.propertyTitleTxtField.frame.size.height;
    scrollViewHeight+=self.cityTxtField.frame.size.height;
    scrollViewHeight+=self.countryTxtField.frame.size.height;
    scrollViewHeight+=self.sectionsTableView.frame.size.height;
    
    [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
    
    
    [loadingIndicator hide:YES];
}


# pragma mark - Set & Load ScrollView
- (void)setScrollView{
    if (pageImages.count!=0) {
        self.uploadPhotoButton.hidden=YES;
        if (pageCount==1) {
            [self.nxtPhotoButton setHidden:YES];
            [self.prevPhotoButton setHidden:YES];
        }
        else{
            [self.nxtPhotoButton setHidden:NO];
            [self.prevPhotoButton setHidden:NO];
        }
    }
    
    else if (pageImages.count==0) {
        for (UIView *subview in self.imagesScrollView.subviews) {
            [subview removeFromSuperview];
        }
        self.uploadPhotoButton.hidden=NO;
        [self.nxtPhotoButton setHidden:YES];
        [self.prevPhotoButton setHidden:YES];
        
    }
    self.pageControl.currentPage = pageCount;
    self.pageControl.numberOfPages = pageCount;
    CGSize pagesScrollViewSize = self.imagesScrollView.frame.size;
    self.imagesScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [pageViews addObject:[NSNull null]];
    }
    [self loadVisiblePages];
}


- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.imagesScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.imagesScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    
    int pageIndex=self.pageControl.currentPage;
    
    if( (pageImages.count==1)||(pageImages.count==0)) {
        [self.prevPhotoButton setHidden:YES];
        [self.nxtPhotoButton setHidden:YES];
        
        
    }
    else if (pageIndex==0) {
        [self.prevPhotoButton setHidden:YES];
        [self.nxtPhotoButton setHidden:NO];
        
        
    }
    else if (pageIndex==pageImages.count-1){
        [self.nxtPhotoButton setHidden:YES];
        [self.prevPhotoButton setHidden:NO];
        
    }
    else{
        [self.prevPhotoButton setHidden:NO];
        [self.nxtPhotoButton setHidden:NO];
    }
    
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
            CGRect frame = self.imagesScrollView.bounds;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 20.0f, 30.0f);
            
            UIImageView *newPageView = [[UIImageView alloc] initWithImage:[pageImages objectAtIndex:page]];
            newPageView.userInteractionEnabled = YES;
            newPageView.tag=page;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            tap.numberOfTapsRequired = 1;
            tap.cancelsTouchesInView=YES;
            
            [newPageView addGestureRecognizer:tap];
            
            
            newPageView.contentMode = UIViewContentModeScaleAspectFit;
            newPageView.frame = frame;
            [self.imagesScrollView addSubview:newPageView];
            [pageViews replaceObjectAtIndex:page withObject:newPageView];
        }
        
    }
}

-(void)imageTapped:(UITapGestureRecognizer *)gesture
{
    
    [self.browserView showFromIndex:0];
    
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

#pragma mark - Add section delegate handler
- (void) addedSection:(NSString *)sectionName{
    
    if (sectionName==nil) {
        
    }
    else{
        PFObject *newSec = [PFObject objectWithClassName:@"Sections"];
        [newSec setObject:[PFUser currentUser] forKey:@"userID"];
        [newSec setObject:sectionName forKey:@"name"];
        [newSec setObject:@"secIcon.png" forKey:@"icon"];
        [newSec setObject:self.propertyID forKey:@"propertyID"];
        
        [sectionsArray addObject:[[SectionObject alloc] initWithObject:newSec andChosenFlag:YES andDeletFlag:NO andAddFlag:YES]];

        [self.sectionsTableView reloadData];
        CGRect frame = self.sectionsTableView.frame;
        frame.size.height = self.sectionsTableView.contentSize.height;
        self.sectionsTableView.frame = frame;
        CGFloat scrollViewHeight = 60.0f;
        scrollViewHeight+=self.imagesScrollView.frame.size.height;
        scrollViewHeight+=self.propertyTitleTxtField.frame.size.height;
        scrollViewHeight+=self.cityTxtField.frame.size.height;
        scrollViewHeight+=self.countryTxtField.frame.size.height;
        scrollViewHeight+=self.sectionsTableView.frame.size.height;

        [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
        
    }
    
}

@end
