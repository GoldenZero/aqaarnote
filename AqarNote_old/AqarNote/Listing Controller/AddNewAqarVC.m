//
//  AddNewAqarVC.m
//  AqarNote
//
//  Created by GALMarei on 2/2/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AddNewAqarVC.h"
#import "SectionCell.h"
#import "countryObject.h"
#import "SectionObject.h"
#import "PropertyImageObj.h"

#define COUNTRIES_FILE_NAME         @"Countries"
#define COUNTRY_ID_JSONK            @"CountryID"
#define COUNTRY_NAME_JSONK          @"CountryName"
#define COUNTRY_NAME_EN_JSONK       @"CountryNameEn"
#define COUNTRY_CURRENCY_ID_JSONK   @"CurrencyID"
#define COUNTRY_DISPLAY_ORDER_JSONK @"DisplayOrder"
#define COUNTRY_CODE_JSONK          @"CountryCode"


@interface AddNewAqarVC ()
{
    NSMutableArray* mainSectionsArray;
    NSMutableArray* sectionsArray;
    PFObject * currentImageID;
    NSArray *countriesArray;
    EnhancedKeyboard *enhancedKeyboard;
    NSString * chosenCountry;
    NSMutableArray *pageImages;
    NSInteger pageCount;
    UIActionSheet *photoAction;
    SBPickerSelector *countriesPicker ;
    NSMutableArray *pageViews;
    
    PFObject *newProperty;
    AlertView * alert;
}
@end
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

CGFloat animatedDistance;

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
    
   // Initializing view
    [self prepareViewComponents];
   
    // Loading sections
    if ([self checkConnection]) {
        [HUD show:YES];
        [self.sectionsTableView addSubview:HUD];
        HUD.labelText = @"جاري تحميل الأقسام..";
        [self getExistSection];
    }
    // There is no internet connection
    else{
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
    }
}


- (void) prepareViewComponents{
    
    // Init loading indicator
    HUD = [[MBProgressHUD alloc] initWithView:self.sectionsTableView];
    HUD.delegate = self;

    
    // Set custom font
    self.propertyTitle.font=[UIFont fontWithName:@"Tahoma" size:12];
    self.country.font=[UIFont fontWithName:@"Tahoma" size:12];
    self.city.font=[UIFont fontWithName:@"Tahoma" size:12];
    self.sesctionsLabel.font=[UIFont fontWithName:@"HacenSudan" size:16];
    self.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    self.cancelButton.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    self.saveButton.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    
    // Set picker view
    countriesPicker = [SBPickerSelector picker];
    countriesPicker.delegate = self;
    countriesPicker.pickerType = SBPickerSelectorTypeText;
    countriesPicker.doneButtonTitle = @"تم";
    countriesPicker.cancelButtonTitle = @"إغلاق";

    // Initialize Main Array
    mainSectionsArray = [NSMutableArray new];
    [mainSectionsArray addObject:@"المطبخ"];
    [mainSectionsArray addObject:@"غرفة المعيشة"];
    [mainSectionsArray addObject:@"غرفة النوم"];
    [mainSectionsArray addObject:@"الحمام"];
    [mainSectionsArray addObject:@"غرفة الطعام"];
    [mainSectionsArray addObject:@"الحديقة"];

    // Initialize keyboard
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;
    [self.propertyTitle setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.city setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    
    // Load countries
    [self loadCountries];
    
    pageImages=[[NSMutableArray alloc] init];

    // Intialize propety
    newProperty = [PFObject objectWithClassName:@"Properties"];
    [newProperty setObject:self.propertyTitle.text forKey:@"Title"];
    [newProperty setObject:[NSNull null] forKey:@"country"];
    [newProperty setObject:self.city.text forKey:@"city"];
    [newProperty setObject:[PFUser currentUser] forKey:@"userID"];

}

-(void)viewWillAppear:(BOOL)animated{
    pageCount=pageImages.count;

    [self setScrollView];
}
-(void)getExistSection
{
    PFQuery *sectionQuery = [PFQuery queryWithClassName:@"Sections"];
    [sectionQuery whereKey:@"userID" equalTo:[PFUser currentUser]];
    
    // Run the query
    [sectionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            sectionsArray=[[NSMutableArray alloc] init];

            //Save results and update the table
            if ([objects count] == 0) {
                for (int i=0; i<mainSectionsArray.count; i++) {
                        PFObject *newSec = [PFObject objectWithClassName:@"Sections"];
                        [newSec setObject:[PFUser currentUser] forKey:@"userID"];
                        [newSec setObject:(NSString*)[mainSectionsArray objectAtIndex:i] forKey:@"name"];
                        [newSec setObject:@"secIcon.png" forKey:@"icon"];
                        [newSec setObject:newProperty forKey:@"propertyID"];
                        
                        [sectionsArray addObject:[[SectionObject alloc] initWithObject:newSec andChosenFlag:NO andDeletFlag:NO andAddFlag:NO]];
                }

                [self prepareSections];
            }else
            {
                for (int i=0; i<objects.count; i++) {
                    bool flage=false;
                    for (int j=0; j<i; j++) {
                        if ([(NSString*)[(PFObject*)[objects objectAtIndex:j]objectForKey:@"name"] isEqualToString:(NSString*)[(PFObject*)[objects objectAtIndex:i]objectForKey:@"name"]]) {
                            flage=true;
                            break;
                        }
                    }
                    if (!flage) {
                        PFObject *sect=[objects objectAtIndex:i];
                        
                        PFObject *newSec = [PFObject objectWithClassName:@"Sections"];
                        [newSec setObject:[PFUser currentUser] forKey:@"userID"];
                        [newSec setObject:[sect objectForKey:@"name"] forKey:@"name"];
                        [newSec setObject:@"secIcon.png" forKey:@"icon"];
                        [newSec setObject:newProperty forKey:@"propertyID"];
                        
                        SectionObject *obj=[[SectionObject alloc] initWithObject:newSec andChosenFlag:YES andDeletFlag:NO andAddFlag:NO];
                        [sectionsArray addObject:obj];
                    }
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
                        [newSec setObject:newProperty forKey:@"propertyID"];
                        
                        [sectionsArray addObject:[[SectionObject alloc] initWithObject:newSec andChosenFlag:NO andDeletFlag:NO andAddFlag:NO]];
                    }
                    
                }
                [self prepareSections];

            }
        }
    }];
}

-(void)prepareSections
{

    [self.sectionsTableView reloadData];
    CGRect frame = self.sectionsTableView.frame;
    frame.size.height = self.sectionsTableView.contentSize.height;
    self.sectionsTableView.frame = frame;
    CGFloat scrollViewHeight = 60.0f;
    scrollViewHeight+=self.imageScrollView.frame.size.height;
    scrollViewHeight+=self.propertyTitle.frame.size.height;
    scrollViewHeight+=self.city.frame.size.height;
    scrollViewHeight+=self.country.frame.size.height;
    scrollViewHeight+=self.sectionsTableView.frame.size.height;
    
    [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];

    [HUD hide:YES];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Uploading Images Delegate
- (IBAction)openCountryPickerBtnPrss:(id)sender {
    [self.country resignFirstResponder];
    [self.city resignFirstResponder];
    [self.propertyTitle resignFirstResponder];
    [self.descriptionsTxtView resignFirstResponder];
    [self showPicker:nil];
    //[self showPicker];
}

- (IBAction)uploadImagePressed:(id)sender {
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
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        [imageFile save];
        PFObject *userPhoto = [PFObject objectWithClassName:@"PropertyPhoto"];
        [userPhoto setObject:imageFile forKey:@"imageFile"];
        [userPhoto setObject: [PFUser currentUser] forKey:@"user"];
        [userPhoto setObject:newProperty forKey:@"propertyID"];
        
        [userPhoto saveInBackground];
        
        [pageImages addObject:[[PropertyImageObj alloc] initWithObject:userPhoto andDeleteFlag:NO andAddedFlag:YES withLocation:pageImages.count]];
        pageCount=[pageImages count];
        [self setScrollView];
        
    }
}

- (void)setUpImages:(NSArray *)images
{
    
}


- (IBAction)addButtonPressed:(id)sender {
    
  
}

- (IBAction)saveButtonPressed:(id)sender {
    [self.country resignFirstResponder];
    [self.city resignFirstResponder];
    [self.propertyTitle resignFirstResponder];
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    
    if ([self.propertyTitle.text length] == 0 || self.propertyTitle.text == nil || [self.propertyTitle.text isEqual:@""] == TRUE) {
        
        AlertView *alert1=[[AlertView alloc] initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء إدخال عنوان الشقة" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert1.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert1.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert1 show];
 
    }
    else if ([self.city.text length] == 0 || self.city.text == nil || [self.city.text isEqual:@""] == TRUE) {
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
        // Set loading indicator
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        HUD.delegate = self;
        HUD.labelText = @"يتم الآن الحفظ";
        [HUD show:YES];
        
        // Set added sections
        NSMutableArray *toAddSections=[[NSMutableArray alloc] init];
        for (int i=0; i<sectionsArray.count; i++) {
            
            if ([(SectionObject*)[sectionsArray objectAtIndex:i] SectionChosen]) {
                [toAddSections addObject:[(SectionObject*)[sectionsArray objectAtIndex:i] sectionPFObject]];
            }
        }
        [PFObject saveAll:toAddSections];
        // Set Preoperty
        [newProperty setObject:self.propertyTitle.text forKey:@"Title"];
        [newProperty setObject:chosenCountry forKey:@"country"];
        [newProperty setObject:self.city.text forKey:@"city"];
        [newProperty saveInBackgroundWithBlock:^(BOOL done , NSError *error){
            if (done) {
                
                [HUD hide:YES];
                AlertView *alert2=[[AlertView alloc] initWithTitle:@"تم" message:@"لقد تم إضافة عقارك بنجاح" cancelButtonTitle:nil WithFont:@"Tahoma"];
                alert2.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                alert2.customButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                [alert2 addButtonWithTitle:@"موافق"
                                      type:AlertViewButtonTypeCustom
                                   handler:^(AlertView *alertView, AlertButtonItem *button) {
                                       
                                       [alertView dismiss];
                                       if (pageImages.count!=0) {
                                             [self.delegate addedProperty:newProperty withImage:[(PropertyImageObj*)[pageImages objectAtIndex:0] imagePFObject]];
                                       }
                                       else{
                                             [self.delegate addedProperty:newProperty withImage:nil];
                                       }
                                       [self dismissView];
                                       
                                   }];
                
                [alert2 show];
                    
            }
        }];
        
    }
  
}

- (IBAction)nxtImgBtnPrss:(id)sender {
    
    [self.prevImgButton setHidden:NO];
    int page=self.pageControl.currentPage;
    if (page<pageImages.count) {
        page++;
        CGRect frame = self.imageScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.imageScrollView scrollRectToVisible:frame animated:YES];
        
        if (page==pageImages.count-1){
            [self.nextImgButton setHidden:YES];
        }
        
    }
    
}

- (IBAction)prevImgBtnPrss:(id)sender {
    [self.nextImgButton setHidden:NO];
    int page=self.pageControl.currentPage;
    if (page>0) {
        page--;
        CGRect frame = self.imageScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.imageScrollView scrollRectToVisible:frame animated:YES];
        
    }
    if (page==0){
        [self.prevImgButton setHidden:YES];
    }
    
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    // 3- Delete deleted properties photo
    NSMutableArray *deletedPropertyImg=[[NSMutableArray alloc] init];
    for (int i=0; i<pageImages.count; i++) {
            [deletedPropertyImg addObject:[(PropertyImageObj*)[pageImages objectAtIndex:i] imagePFObject]];
    }
    [PFObject deleteAll:deletedPropertyImg];
    [newProperty deleteInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)addSectionBtnPrss:(id)sender {
    
    [self performSegueWithIdentifier:@"showAddSection" sender:self];

//    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:@"إضافة قسم جديد" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:@"أضف", nil];
//    av.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [av textFieldAtIndex:0].delegate = self;
//    [av show];
}



- (IBAction)deletePhotoBtnPrss:(id)sender {
    
    AlertView *alert2=[[AlertView alloc] initWithTitle:@"تأكيد" message:@"لهل تريد بالتأكيد حذف هذه الصورة؟" cancelButtonTitle:@"لا" WithFont:@"Tahoma"];
    alert2.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
    alert2.customButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
    alert2.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
    [alert2 addButtonWithTitle:@"نعم"
                         type:AlertViewButtonTypeCustom
                      handler:^(AlertView *alertView, AlertButtonItem *button) {
                          // Dismiss alertview
                          [alertView dismiss];
                          [self purgePage:self.pageControl.currentPage];
                          [pageImages removeObjectAtIndex:self.pageControl.currentPage];
                          pageCount=pageImages.count;
                          [self setScrollView];
                          
                      }];
    
    [alert2 show];

    
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
            PFObject * imgFile=[(PropertyImageObj*)[pageImages objectAtIndex:actionSheet.tag] imagePFObject];
            [imgFile deleteInBackground];
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


#pragma mark - UITableView Delegate handler


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


#pragma mark - UIAlertView Delegate handler

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // if confirm delete msg
    if (alertView.tag==2) {
        if (buttonIndex!=0) {
            [self purgePage:self.pageControl.currentPage];
            [pageImages removeObjectAtIndex:self.pageControl.currentPage];
            pageCount=pageImages.count;
            [self setScrollView];

        }
        
    }
    // if add section msg
    else if (alertView.tag==4){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        
        if (buttonIndex!=0) {
//            [sectionsArray addObject:[[alertView textFieldAtIndex:0] text]];
//            [chosenBooleanArray addObject:@YES];
//            [self.sectionsTableView reloadData];
//            CGRect frame = self.sectionsTableView.frame;
//            frame.size.height = self.sectionsTableView.contentSize.height;
//            self.sectionsTableView.frame = frame;
//            
//            CGFloat scrollViewHeight = 0.0f;
//            for (UIView* view in self.contentScrollView.subviews)
//            {
//                scrollViewHeight += view.frame.size.height;
//            }
//            
//            [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];

        }
        
        

    }    

}

- (void) willPresentAlertView:(UIAlertView *)alertView{
    for (UIView *_currentView in alertView.subviews) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            [((UIButton *)_currentView).titleLabel setFont:[UIFont fontWithName:@"HacenSudan" size:14]];
            [((UIButton *)_currentView).titleLabel setTextColor:[UIColor blackColor]];
            
        }
        else if ([_currentView isKindOfClass:[UILabel class]]){
            [((UILabel *)_currentView) setFont:[UIFont fontWithName:@"HacenSudan" size:12]];
            [((UILabel *)_currentView) setTextColor:[UIColor blackColor]];

        }
    }

}

#pragma mark - UIPicker view handler
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    return countriesArray.count;
   
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    // set label
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 50.0)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont boldSystemFontOfSize:30.0]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setText:[countriesArray objectAtIndex:row]];
    
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    chosenCountry=(NSString*)[countriesArray objectAtIndex:row];
    self.country.text=chosenCountry;
    
}


#pragma mark - Load countries form JSON file

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


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    
    CGRect textViewRect = [self.view.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0) {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0) {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown) {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

#pragma mark - UITextFieldDelegate protocol
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
// --------------------------------------------------------------------

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
}
// --------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// --------------------------------------------------------------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self SBPickerSelector:countriesPicker cancelPicker:YES];
    
    [textField setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];

}

#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)doneDidTouchDown
{
    if ([self.propertyTitle isEditing]) {
        [self.propertyTitle resignFirstResponder];
    }
    
    else if ([self.city isEditing]) {
        [self.city resignFirstResponder];
    }
    else{
        [self.descriptionsTxtView resignFirstResponder];
    }
    
}

#pragma mark - paging & scrollView

- (void)setScrollView{
    if (pageImages.count!=0) {
        self.addImgesButton.hidden=YES;
       // self.uploadImageBtn.hidden=NO;
       // self.deletePhotoButton.hidden=NO;
        if (pageCount==1) {
            [self.nextImgButton setHidden:YES];
            [self.prevImgButton setHidden:YES];
        }
        else{
            [self.nextImgButton setHidden:NO];
            [self.prevImgButton setHidden:NO];
 
        }

    }
    
    else if (pageImages.count==0) {
        for (UIView *subview in self.imageScrollView.subviews) {
            [subview removeFromSuperview];
        }
        self.addImgesButton.hidden=NO;
        self.uploadImageBtn.hidden=YES;
        self.deletePhotoButton.hidden=YES;
        [self.nextImgButton setHidden:YES];
        [self.prevImgButton setHidden:YES];
        
        
    }
    self.pageControl.currentPage = pageCount;
    self.pageControl.numberOfPages = pageCount;
    CGSize pagesScrollViewSize = self.imageScrollView.frame.size;
    self.imageScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [pageViews addObject:[NSNull null]];
    }
    [self loadVisiblePages];
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.imageScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.imageScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
    
    
    int pageIndex=self.pageControl.currentPage;

    if( (pageImages.count==1)||(pageImages.count==0)) {
        [self.prevImgButton setHidden:YES];
        [self.nextImgButton setHidden:YES];


    }
    else if (pageIndex==0) {
        [self.prevImgButton setHidden:YES];
        [self.nextImgButton setHidden:NO];

        
    }
    else if (pageIndex==pageImages.count-1){
        [self.nextImgButton setHidden:YES];
        [self.prevImgButton setHidden:NO];

    }
    else{
        [self.prevImgButton setHidden:NO];
        [self.nextImgButton setHidden:NO];
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
            CGRect frame = self.imageScrollView.bounds;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0.0f;
            frame = CGRectInset(frame, 20.0f, 30.0f);
            
            PFFile *theImage = [[(PropertyImageObj*)[pageImages objectAtIndex:page] imagePFObject] objectForKey:@"imageFile"];
            UIImage *image =[UIImage imageWithData:[theImage getData]];

            UIImageView *newPageView = [[UIImageView alloc] initWithImage:image];
            newPageView.userInteractionEnabled = YES;
            newPageView.tag=page;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            tap.numberOfTapsRequired = 1;
            tap.cancelsTouchesInView=YES;
            
            [newPageView addGestureRecognizer:tap];
            

            newPageView.contentMode = UIViewContentModeScaleAspectFit;
            newPageView.frame = frame;
            [self.imageScrollView addSubview:newPageView];
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
        [newSec setObject:newProperty forKey:@"propertyID"];
        
        [sectionsArray addObject:[[SectionObject alloc] initWithObject:newSec andChosenFlag:YES andDeletFlag:NO andAddFlag:YES]];
        [self.sectionsTableView reloadData];
        CGRect frame = self.sectionsTableView.frame;
        frame.size.height = self.sectionsTableView.contentSize.height;
        self.sectionsTableView.frame = frame;
        CGFloat scrollViewHeight = 60.0f;
        scrollViewHeight+=self.imageScrollView.frame.size.height;
        scrollViewHeight+=self.propertyTitle.frame.size.height;
        scrollViewHeight+=self.city.frame.size.height;
        scrollViewHeight+=self.country.frame.size.height;
        scrollViewHeight+=self.sectionsTableView.frame.size.height;
        NSLog(@"height of sections table %f",self.sectionsTableView.frame.size.height);

//        CGFloat scrollViewHeight = 0.0f;
//        for (UIView* view in self.contentScrollView.subviews)
//        {
//            scrollViewHeight += view.frame.size.height;
//        }
        
        [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
   
    }
    
}

- (void) editedSection:(NSString *)sectionName withID:(int)index{
    [sectionsArray replaceObjectAtIndex:index withObject:sectionName];
    [self.sectionsTableView reloadData];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    if ([[segue identifier] isEqualToString:@"showAddSection"])  //parameter to map for update
    {
        AddNewSectionVC* vc = segue.destinationViewController;
        vc.delegate=self;

    }
}

#pragma mark - AGPhotoBrowser datasource

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


#pragma mark - AGPhotoBrowser delegate

- (void)photoBrowser:(AGPhotoBrowserView *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	// -- Dismiss
	NSLog(@"Dismiss the photo browser here");
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


#pragma mark - Getters

- (AGPhotoBrowserView *)browserView
{
	if (!_browserView) {
		_browserView = [[AGPhotoBrowserView alloc] initWithFrame:CGRectZero];
		_browserView.delegate = self;
		_browserView.dataSource = self;
	}
	
	return _browserView;
}

- (void) showPicker:(id)sender{
    
    CGPoint point = [self.view convertPoint:[sender frame].origin fromView:[sender superview]];
    CGRect frame = [sender frame];
    frame.origin = point;
    //[picker showPickerOver:self]; //classic picker display
    
    [countriesPicker showPickerIpadFromRect:CGRectZero inView:self.view];
    
}


#pragma mark - SBPickerSelectorDelegate
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    chosenCountry=(NSString*)[countriesArray objectAtIndex:idx];
    self.country.text=chosenCountry ;
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

- (void) dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
