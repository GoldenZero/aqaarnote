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
    NSMutableArray* chosenSectionArray;
    NSMutableArray* chosenBooleanArray;
    PFObject * currentImageID;
    NSArray *countriesArray;
    EnhancedKeyboard *enhancedKeyboard;
    countryObject * chosenCountry;
    NSMutableArray *pageImages;
    NSInteger pageCount;
    
    NSMutableArray *pageViews;
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
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;
    
    pageImages=[[NSMutableArray alloc] init];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.sectionsTableView];
    HUD.delegate = self;

    mainSectionsArray = [NSMutableArray new];
    [mainSectionsArray addObject:@"kitchen"];
    [mainSectionsArray addObject:@"living room"];
    [mainSectionsArray addObject:@"bed room"];
    [mainSectionsArray addObject:@"bath room"];
    [mainSectionsArray addObject:@"dining room"];
    [mainSectionsArray addObject:@"garden"];
    
    [self.propertyTitle setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.city setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    [self.descriptionsTxtView setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
    
    [HUD show:YES];
    HUD.labelText = @"جاري تحميل الأقسام..";

    [self loadCountries];
    [self getExistSection];
	// Do any additional setup after loading the view.
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
    sectionsArray = [NSMutableArray new];
    chosenSectionArray = [NSMutableArray new];
    
    sectionsArray = mainSectionsArray;
    chosenBooleanArray=[[NSMutableArray alloc] init];
    for (int i=0; i<sectionsArray.count; i++) {
        [chosenBooleanArray addObject:@NO];
    }

    [self.sectionsTableView reloadData];
    CGRect frame = self.sectionsTableView.frame;
    frame.size.height = self.sectionsTableView.contentSize.height;
    self.sectionsTableView.frame = frame;
    
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.contentScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];

    [HUD hide:YES];


}


-(void)prepareExistingSections
{
    chosenSectionArray = [NSMutableArray new];
    [self.sectionsTableView reloadData];
   
    CGRect frame = self.sectionsTableView.frame;
    frame.size.height = self.sectionsTableView.contentSize.height;
    self.sectionsTableView.frame = frame;
    
    CGFloat scrollViewHeight = 0.0f;
    for (UIView* view in self.contentScrollView.subviews)
    {
        scrollViewHeight += view.frame.size.height;
    }
    
    [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
    
    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in self.contentScrollView.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
//    self.contentScrollView.contentSize = contentRect.size;
    [HUD hide:YES];
}

-(NSMutableArray*)compareSectionsArray:(NSMutableArray*)arrOfString andArray:(NSMutableArray*)arrOfObject
{
    NSMutableArray* comparedArr = arrOfString;
    chosenBooleanArray=[[NSMutableArray alloc] init];
    for (int i=0; i<arrOfString.count; i++) {
        [chosenBooleanArray addObject:@NO];
    }
    BOOL isMatching;
    for (PFObject* pf in arrOfObject) {

        for (int i=0; i<arrOfString.count; i++) {
            NSString* pfString = [arrOfString objectAtIndex:i];
            if ([[pf objectForKey:@"name"] isEqualToString:pfString]) {
                isMatching = YES;
                [chosenBooleanArray replaceObjectAtIndex:i withObject:@YES];
                break;
            }else
            {
                isMatching = NO;
                continue;
            }
            
        }
        if (!isMatching) {
            [comparedArr addObject:[pf objectForKey:@"name"]];
            [chosenBooleanArray addObject:@YES];
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

    if ([[chosenBooleanArray objectAtIndex:currentIndex] boolValue]) {
        [chosenBooleanArray replaceObjectAtIndex:currentIndex withObject:@NO];
        [btn setImage:[UIImage imageNamed:@"white_dot_option.png"] forState:UIControlStateNormal];

    }
    else{
        [chosenBooleanArray replaceObjectAtIndex:currentIndex withObject:@YES];
        [btn setImage:[UIImage imageNamed:@"green_dot_option.png"] forState:UIControlStateNormal];


    }

   // [self.sectionsTableView reloadData];
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
    [self showPicker];
}

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

- (void)setUpImages:(NSArray *)images
{
    
}



- (IBAction)addButtonPressed:(id)sender {
    
  
}

- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"post new property");
    if ([self.propertyTitle.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء إدخال عنوان الشقة" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].delegate = self;
        [av show];
 
    }
    else if ([self.city.text isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء إدخال المدينة" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].delegate = self;
        [av show];
        
    }

    else if ([chosenCountry isEqual:nil]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"المعلومات غير كاملة" message:@"الرجاء اختيار الدولة" delegate:self cancelButtonTitle:@"موافق" otherButtonTitles:@"", nil];
        av.alertViewStyle = UIAlertViewStylePlainTextInput;
        [av textFieldAtIndex:0].delegate = self;
        [av show];
        
    }
    
    else{
    chosenSectionArray=[[NSMutableArray alloc]init];
    // build chosenArray
    for (int i=0; i<chosenBooleanArray.count; i++) {
        if ([[chosenBooleanArray objectAtIndex:i] boolValue]) {
            [chosenSectionArray addObject:[sectionsArray objectAtIndex:i]];
        }
    }
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"يتم الآن الحفظ";
    [HUD show:YES];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    PFObject *newPost = [PFObject objectWithClassName:@"Properties"];

    
    for (int i=0; i<pageImages.count; i++) {
        NSData *imageData = UIImagePNGRepresentation((UIImage*)[pageImages objectAtIndex:i]);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        
        // Save PFFile
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                
                // Create a PFObject around a PFFile and associate it with the current user
                PFObject *userPhoto = [PFObject objectWithClassName:@"PropertyPhoto"];
                [userPhoto setObject:imageFile forKey:@"imageFile"];
                
                
                // Set the access control list to current user for security purposes
                userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                
                PFUser *user = [PFUser currentUser];
                [userPhoto setObject:user forKey:@"user"];
                [userPhoto setObject:newPost forKey:@"propertyID"];

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
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        } progressBlock:^(int percentDone) {
            // Update your progress spinner here. percentDone will be between 0 and 100.
            HUD.progress = (float)percentDone/100;
        }];
        
    }
    
    // Create Post
   
    // Set property
    [newPost setObject:self.propertyTitle.text forKey:@"Title"];
    [newPost setObject:chosenCountry.countryName forKey:@"country"];
    [newPost setObject:self.city.text forKey:@"city"];
    [newPost setObject:self.descriptionsTxtView.text forKey:@"Description"];

    [newPost setObject:chosenSectionArray forKey:@"sections"];


    [newPost setObject:[PFUser currentUser] forKey:@"userID"];

    //set section with property
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [arr addObject:newPost];
    
    // TODO : Ask Ghassan about this array
    for (int i = 0; i < [chosenSectionArray count]; i++) {
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
             [HUD hide:YES];

             [self dismissViewControllerAnimated:YES completion:nil];
         }
         
     }];
    }
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

- (IBAction)addSectionBtnPrss:(id)sender {
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"" message:@"إضافة قسم جديد" delegate:self cancelButtonTitle:@"إلغاء" otherButtonTitles:@"أضف", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
}

- (IBAction)chooseCountryBtnPrss:(id)sender {
    [self closePicker];
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
    cell.sectionLabel.text=(NSString*)[sectionsArray objectAtIndex:indexPath.row];
    [cell.sectionButtonPrssed setBackgroundColor:[UIColor clearColor]];
    if ([[chosenBooleanArray objectAtIndex:indexPath.row] boolValue]) {
        [cell.sectionButtonPrssed setImage:[UIImage imageNamed:@"green_dot_option.png"] forState:UIControlStateNormal];

    }
    else{
        [cell.sectionButtonPrssed setImage:[UIImage imageNamed:@"white_dot_option.png"] forState:UIControlStateNormal];

    }
    [cell.sectionButtonPrssed addTarget:self action:@selector(sectionPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.sectionButtonPrssed.tag = indexPath.row;
    
    // Load section icon
    
    if ([cell.sectionLabel.text isEqualToString:@"kitchen"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"cooknig_icon"];
    }
    
    else if ([cell.sectionLabel.text isEqualToString:@"living room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"Lobby_icon"];
    }

    else if ([cell.sectionLabel.text isEqualToString:@"bed room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"badroom_icon"];
    }

    else if ([cell.sectionLabel.text isEqualToString:@"bath room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"bathroom_icon"];
    }

    else if ([cell.sectionLabel.text isEqualToString:@"dining room"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"dining_room_icon"];
    }
    else if ([cell.sectionLabel.text isEqualToString:@"garden"]) {
        cell.sectionImage.image=[UIImage imageNamed:@"garden_room_icon"];
    }
    else{
        cell.sectionImage.image=[UIImage imageNamed:@""];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




#pragma mark - UIAlertView Delegate handler

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // if cancel
    if (buttonIndex==0) {
       // [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }
    // if add
    else{
        [sectionsArray addObject:[[alertView textFieldAtIndex:0] text]];
        [chosenBooleanArray addObject:@YES];
        [self.sectionsTableView reloadData];
        CGRect frame = self.sectionsTableView.frame;
        frame.size.height = self.sectionsTableView.contentSize.height;
        self.sectionsTableView.frame = frame;
        
        CGFloat scrollViewHeight = 0.0f;
        for (UIView* view in self.contentScrollView.subviews)
        {
            scrollViewHeight += view.frame.size.height;
        }
        
        [self.contentScrollView setContentSize:(CGSizeMake(320, scrollViewHeight))];
        

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
    
    [label setText:[[countriesArray objectAtIndex:row]countryName]];
    
    return label;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    chosenCountry=(countryObject*)[countriesArray objectAtIndex:row];
    self.showPickerButton.titleLabel.text=[NSString stringWithFormat:@"   %@",[chosenCountry countryName]];
    
}

#pragma mark - Show and hide picker 

-(IBAction)closePicker
{
    [self.pickerView setHidden:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x,
                                            [[UIScreen mainScreen] bounds].size.height,
                                            self.pickerView.frame.size.width,
                                            self.pickerView.frame.size.height);
    }];
}


-(IBAction)showPicker
{
    
    [self.pickerView setHidden:NO];
    [self.pickerView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerView.frame = CGRectMake(self.pickerView.frame.origin.x,
                                            [[UIScreen mainScreen] bounds].size.height-self.self.pickerView.frame.size.height,
                                            self.pickerView.frame.size.width,
                                            self.pickerView.frame.size.height);
    }];
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
        [resultCountries addObject:country];
    }
    countriesArray=resultCountries;
    [self.countriesPickerView reloadAllComponents];
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
    [self closePicker];
    
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
    [self closePicker];
    
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

-(void)setScrollView{
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
            frame = CGRectInset(frame, 10.0f, 0.0f);
            
            UIImageView *newPageView = [[UIImageView alloc] initWithImage:[pageImages objectAtIndex:page]];
            newPageView.contentMode = UIViewContentModeScaleAspectFit;
            newPageView.frame = frame;
            [self.imageScrollView addSubview:newPageView];
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
@end
