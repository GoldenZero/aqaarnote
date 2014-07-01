//
//  BrowseInspectionVC.m
//  AqarNote
//
//  Created by GALMarei on 2/4/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "BrowseInspectionVC.h"
#import "PropertyImageObj.h"

@interface BrowseInspectionVC ()
{
    NSNumber* sectionStatus;
    PFObject * currentImageID;
    NSMutableArray *pageImages;
    NSMutableArray *ImagesObjects;
    NSInteger pageCount;
    UIActionSheet *photoAction;
    NSMutableArray *pageViews;
    
}
@end


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.1;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.9;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 140;

CGFloat animatedDistance;



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
  
    // Set view
    [self prepareViewComponent];
    
    // Load photo
    if ([self checkConnection]) {
        [self loadSectionPhoto];
    }
   
    // There is no internet connection
    else{
        AlertView *alert=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];

    }
}

-(void)viewWillAppear:(BOOL)animated{
    
   // [self setScrollView];

}

- (void) prepareViewComponent{
    
    // Set custom font
    self.uploadImageBtn.hidden=YES;
    self.sectionTitle.text = [self.sectionID objectForKey:@"name"];
    self.sectionTitle.font = [UIFont fontWithName:@"HacenSudan" size:14];
    self.cancelButton.titleLabel.font= [UIFont fontWithName:@"HacenSudan" size:14];
    self.noteTextView.font = [UIFont fontWithName:@"Tahoma" size:10];

    pageImages=[[NSMutableArray alloc] init];

    // Initialize loading indicator
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelFont=[UIFont fontWithName:@"Tahoma" size:16];
    HUD.labelText = @"يتم الآن التحميل";
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [HUD show:YES];
    
    // Set note view
    NSString *note=(NSString*)[self.sectionID objectForKey:@"note"];
    if (!note) {
        self.noteTextView.text=@"ملاحظات...";
    }
    else{
        self.noteTextView.text=[NSString stringWithFormat:@"ملاحظات : %@ " ,note];

    }
    
    // Set section status
    NSString *temp=[self.sectionID objectForKey:@"status"];
    
    if (temp!=nil) {
        if (temp.integerValue==5) {
            UIButton* btn = [[UIButton alloc]init];
            btn.tag=[temp integerValue];
            [self buttonBrokenPrss:btn];
        }
        else{
            UIButton* btn = [[UIButton alloc]init];
            btn.tag=[temp integerValue];
            [self chooseStatusPressed:btn];
        }
    }
    else{
        UIButton* btn = [[UIButton alloc]init];
        btn.tag=0;
        [self chooseStatusPressed:btn];
        
    }
    
    self.contentScrollView.contentSize =CGSizeMake(320, 518);

}
#pragma mark - Buttons Actions


- (IBAction)deleteImgBtnPrss:(id)sender {
    AlertView *alert=[[AlertView alloc] initWithTitle:@"تأكيد" message:@"لهل تريد بالتأكيد حذف هذه الصورة؟" cancelButtonTitle:@"لا" WithFont:@"Tahoma"];
    alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
    alert.customButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
    alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
    [alert addButtonWithTitle:@"نعم"
                         type:AlertViewButtonTypeCustom
                      handler:^(AlertView *alertView, AlertButtonItem *button) {
                          // Dismiss alertview
                          [alertView dismiss];
                          [self purgePage:self.pageControl.currentPage];
                          [pageImages removeObjectAtIndex:self.pageControl.currentPage];
                          pageCount=pageImages.count;
                          [self setScrollView];
                          
                      }];
    
    [alert show];

}

- (IBAction)uploadImagePressed:(id)sender {
    
    // Add uploaded image to the scrollView
    if (pageImages.count==3) {
        AlertView *alert=[[AlertView alloc] initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" cancelButtonTitle:@"إلغاء" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];
        
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

- (IBAction)nxtImgBtnPrss:(id)sender {
    
    [self.prevImgButton setHidden:NO];
    int page=self.pageControl.currentPage;
    if (page<pageImages.count) {
        page++;
        CGRect frame = self.pagingScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.pagingScrollView scrollRectToVisible:frame animated:YES];
        
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
        CGRect frame = self.pagingScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.pagingScrollView scrollRectToVisible:frame animated:YES];
        
    }
    if (page==0){
        [self.prevImgButton setHidden:YES];
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

          // Add uploaded image to the scrollView
        if (pageImages.count==3) {
            AlertView *alert=[[AlertView alloc] initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" cancelButtonTitle:@"إلغاء" WithFont:@"Tahoma"];
            alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
            alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
            [alert show];
            
        }
        else{
            
            // Set HUD
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view.window addSubview:HUD];
            HUD.delegate = self;
            HUD.labelFont=[UIFont fontWithName:@"Tahoma" size:15];
            HUD.labelText = @"يتم الآن تحميل الصورة...";
            [HUD show:YES];
            
            PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
            [imageFile save];
            
            PFObject *userPhoto = [PFObject objectWithClassName:@"SectionPhoto"];
            [userPhoto setObject:imageFile forKey:@"imageFile"];
            
            [userPhoto setObject:[PFUser currentUser] forKey:@"user"];
            [userPhoto setObject:self.propertyID forKey:@"propertyID"];
            [userPhoto setObject:self.sectionID forKey:@"sectionID"];

            [userPhoto save];
            
            [pageImages addObject:[[PropertyImageObj alloc] initWithObject:userPhoto andDeleteFlag:NO andAddedFlag:YES withLocation:pageImages.count]];
            [ImagesObjects addObject:[[PropertyImageObj alloc] initWithObject:userPhoto andDeleteFlag:NO andAddedFlag:YES withLocation:pageImages.count-1]];
            pageCount=[pageImages count];
            [self setScrollView];
        }

}


- (IBAction)saveButtonPressed:(id)sender {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.labelText = @"يتم الآن الحفظ";
    [HUD show:YES];
    
    // Delete deleted section photo
    NSMutableArray *deletedPropertyImg=[[NSMutableArray alloc] init];
    for (int i=0; i<ImagesObjects.count; i++) {
        if (([(PropertyImageObj*)[ImagesObjects objectAtIndex:i] Deleted])&&!([(PropertyImageObj*)[ImagesObjects objectAtIndex:i] Added])) {
            [deletedPropertyImg addObject:[(PropertyImageObj*)[ImagesObjects objectAtIndex:i] imagePFObject]];
        }
    }
    [PFObject deleteAll:deletedPropertyImg];

    if (![self.sectionID objectForKey:@"status"]) {
        self.numberOfInspected++;
    }
    [self.sectionID setObject:sectionStatus forKey:@"status"];
    [self.sectionID setObject:self.noteTextView.text forKey:@"note"];
    [self.sectionID saveInBackgroundWithBlock:^(BOOL done, NSError *error){
        if (done) {
            [self.propertyID setObject:[NSDate date] forKey:@"lastInspectionDate"];
            [self.propertyID setObject:[NSNumber numberWithFloat:(self.numberOfInspected*100)/self.numberOfSections] forKey:@"InspectionRate"];
            [self.propertyID saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
                if (succeded) {
                    [HUD hide:YES];
                    [self.delegate InspectedSection:self.sectionID];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else{
                    [HUD hide:YES];
                    AlertView *alert=[[AlertView alloc] initWithTitle:@"خطأ!" message:@"حدث خطأ أثناء الحفظ.. الرجاء التحقق من الاتصال والمحاولة لاحقاً." cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
                    alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                    alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                    [alert show];
                }
            }];
        }
        else{
            [HUD hide:YES];
            AlertView *alert=[[AlertView alloc] initWithTitle:@"خطأ!" message:@"حدث خطأ أثناء الحفظ.. الرجاء التحقق من الاتصال والمحاولة لاحقاً." cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
            alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
            alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
            [alert show];
        }
    }];
    
}

- (IBAction)backButtonPressed:(id)sender {
    NSMutableArray *deletedPropertyImg=[[NSMutableArray alloc] init];
    for (int i=0; i<ImagesObjects.count; i++) {
        if (([(PropertyImageObj*)[ImagesObjects objectAtIndex:i] Added])&&!([(PropertyImageObj*)[ImagesObjects objectAtIndex:i] Deleted])) {
            [deletedPropertyImg addObject:[(PropertyImageObj*)[ImagesObjects objectAtIndex:i] imagePFObject]];
        }
    }
    [PFObject deleteAll:deletedPropertyImg];

    [self.delegate InspectedSection:nil];

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
    
    if (actionSheet==photoAction) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"حذف"]) {
            [self.browserView hideWithCompletion:^(BOOL finished){
                NSLog(@"Dismissed!");
            }];
            [self purgePage:actionSheet.tag];
            int indexTemp=[(PropertyImageObj*)[pageImages objectAtIndex:actionSheet.tag] location];
            if ([(PropertyImageObj*)[ImagesObjects objectAtIndex:indexTemp] Added]) {
                // TODO delete from DB
                
                PFObject * imgFile=[(PropertyImageObj*)[ImagesObjects objectAtIndex:indexTemp] imagePFObject];
                [imgFile deleteInBackground];
            }
            [(PropertyImageObj*)[ImagesObjects objectAtIndex:indexTemp] setDeleted:YES];

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
                AlertView *alert=[[AlertView alloc] initWithTitle:@"عذراً" message:@"لقد بلغت الحد الأعلى المسموح من الصور" cancelButtonTitle:@"إلغاء" WithFont:@"Tahoma"];
                alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
                alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
                [alert show];
                
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

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *_currentView in actionSheet.subviews) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            [((UIButton *)_currentView).titleLabel setFont:[UIFont fontWithName:@"HacenSudan" size:14]];
            [((UIButton *)_currentView).titleLabel setTextColor:[UIColor blackColor]];
            
        }
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
    if (pageImages.count!=0) {
        self.uploadImageBtn.hidden=YES;
        if (pageImages.count==1) {
            self.prevImgButton.hidden=YES;
            self.nextImgButton.hidden=YES;
        }
        else{
            self.prevImgButton.hidden=NO;
            self.nextImgButton.hidden=NO;

        }
    }
    
    else if (pageImages.count==0) {
        self.uploadImageBtn.hidden=NO;
        self.prevImgButton.hidden=YES;
        self.nextImgButton.hidden=YES;
        
    }
   
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
        [self.prevImgButton setHidden:YES];
        [self.nextImgButton setHidden:NO];
        
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
            CGRect frame = self.pagingScrollView.bounds;
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
            [self.pagingScrollView addSubview:newPageView];
            [pageViews replaceObjectAtIndex:page withObject:newPageView];
        }
        
    }
}
-(void)imageTapped:(UITapGestureRecognizer *)gesture
{
    
    [self.browserView showFromIndex: gesture.view.tag];
    
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
    
    // Load property images
    pageImages=[[NSMutableArray alloc] init];
    ImagesObjects=[[NSMutableArray alloc] init];
    
    PFQuery *currentSection = [PFQuery queryWithClassName:@"SectionPhoto"];
    [currentSection whereKey:@"sectionID" equalTo:self.sectionID];
    [currentSection whereKey:@"propertyID" equalTo:self.propertyID];
    
    [currentSection findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
                for (int i=0; i<objects.count; i++) {
                [ImagesObjects addObject:[[PropertyImageObj alloc] initWithObject:(PFObject*)[objects objectAtIndex:i] andDeleteFlag:NO andAddedFlag:NO withLocation:i]];
                [pageImages addObject:[[PropertyImageObj alloc] initWithObject:(PFObject*)[objects objectAtIndex:i] andDeleteFlag:NO andAddedFlag:NO withLocation:i]];
            }
        }
        
        pageCount=pageImages.count;
        [HUD hide:YES];
        
        [self.contentScrollView addSubview:self.nextImgButton];
        [self.contentScrollView addSubview:self.prevImgButton];

        if (pageCount==1||pageCount==0) {
            [self.nextImgButton setHidden:YES];
            [self.prevImgButton setHidden:YES];
        }
        else {
            self.nextImgButton.hidden=NO;
            self.prevImgButton.hidden=YES;
        }
        
        [self setScrollView];
    }];
    
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

#pragma mark - UIAlertView Delegate handler

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==2) {
        if (buttonIndex!=0) {
            [self purgePage:self.pageControl.currentPage];
            [pageImages removeObjectAtIndex:self.pageControl.currentPage];
            pageCount=pageImages.count;
            [self setScrollView];
        }
    }
    
}


#pragma mark - AGPhotoBrowser datasource

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
	return pageImages.count;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    PFFile *theImage = [[(PropertyImageObj*)[pageImages objectAtIndex:index] imagePFObject] objectForKey:@"imageFile"];
    UIImage *image=[UIImage imageWithData:[theImage getData]];
    
	return image;
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
    // -- For testing purposes only
//    if (index % 2) {
//        return YES;
//    }
//    
//    return NO;
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
