//
//  AddNewInspectionVC.m
//  AqarNote
//
//  Created by GALMarei on 2/3/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "AddNewInspectionVC.h"
#import "AddNewAqarVC.h"

@interface AddNewInspectionVC ()
{
    NSMutableArray* sectionsArray;
    NSMutableArray* chosenSectionArray;
    PFObject * currentImageID;
    PFObject* mySection;
    NSMutableArray *pageImages;
    NSInteger pageCount;
    NSMutableArray *pageViews;
    EnhancedKeyboard *enhancedKeyboard;
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

    // Set custom keyboard
    enhancedKeyboard = [[EnhancedKeyboard alloc] init];
    enhancedKeyboard.delegate = self;
    
    // Set custom font
    self.propertyTitle.font=[UIFont fontWithName:@"Tahoma" size:14];
    self.locationLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
    self.sectionsLabel.font=[UIFont fontWithName:@"HacenSudan" size:16];
    self.screenLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    self.editButton.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];
    self.backButton.titleLabel.font=[UIFont fontWithName:@"HacenSudan" size:14];

    // Set loading indicator
    HUD1 = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD1];
    HUD1.delegate = self;
    HUD1.labelFont=[UIFont fontWithName:@"Tahoma" size:16];
    HUD1.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD1.labelText = @"يتم الآن التحميل";

    HUD2 = [[MBProgressHUD alloc] initWithView:self.imgScrollView];
    HUD2.delegate = self;
    HUD2.labelFont=[UIFont fontWithName:@"Tahoma" size:16];
    [self.imgScrollView addSubview:HUD2];

    if (self.isInspection) {
        [self.editButton setHidden:YES];
    }
    else{
        [self.editButton setHidden:NO];

    }
  //  [self.notesTxtView setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];
}

- (void)viewWillAppear:(BOOL)animated{
    pageImages=[[NSMutableArray alloc] init];

    if ([self checkConnection]) {
        [HUD1 show:YES];
        
        PFQuery *queryProperty = [PFQuery queryWithClassName:@"Properties"];
        // Retrieve the object by id
        [queryProperty getObjectInBackgroundWithId:[self.propertyID objectId] block:^(PFObject *pfObject, NSError *error) {
            self.propertyID=pfObject;
            self.propertyTitle.text = (NSString*)[self.propertyID objectForKey:@"Title"];
            self.screenLabel.text = (NSString*)[self.propertyID objectForKey:@"Title"];
            self.locationLabel.text = [NSString stringWithFormat:@"%@ - %@",[self.propertyID objectForKey:@"country"],[self.propertyID objectForKey:@"city"]];
            
            //        NSString *note=[self.propertyID objectForKey:@"Description"];
            //        if ([note isEqual:@" "]) {
            //            self.notesTxtView.text=@"لا يوجد ملاحظات";
            //        }
            //        else{
            //
            //            self.notesTxtView.text=note;
            //        }
            //        
            [self getSectionsForProperty:self.propertyID];
            
        }];
    }
    else{
        AlertView *alert=[[AlertView alloc] initWithTitle:@"لا يوجد اتصال بالانترنت" message:@"الرجاء التحقق من الاتصال و المحاولة لاحقا" cancelButtonTitle:@"موافق" WithFont:@"Tahoma"];
        alert.titleFont=[UIFont fontWithName:@"Tahoma" size:16];
        alert.cancelButtonFont=[UIFont fontWithName:@"Tahoma" size:16];
        [alert show];
    }
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
            [HUD2 show:YES];

            dispatch_async(dispatch_get_main_queue(), ^{

                [self loadSectionPhoto];
            });

        }
    }];
}

-(void)prepareSections
{
    for (UIView *subview in self.sectionScrollView.subviews) {
        [subview removeFromSuperview];
    }

    [self.sectionScrollView addSubview:self.propertyTitle];
    [self.sectionScrollView addSubview:self.locationLabel];
    [self.sectionScrollView addSubview:self.imgScrollView];
    [self.sectionScrollView addSubview:self.pageControl];
    [self.sectionScrollView addSubview:self.sectionsLabel];

    [self.sectionScrollView addSubview:self.noteBgImg];
   // [self.sectionScrollView addSubview:self.notesTxtView];

    [self.sectionScrollView addSubview:self.nextImgButton];
    [self.sectionScrollView addSubview:self.prevImgButton];

    view_y = 300;
    
    //sectionsArray = [NSMutableArray new];
    //chosenSectionArray = [NSMutableArray new];
    
    
    for (int i = 0; i < [sectionsArray count]; i++) {
        PFObject* sect = [sectionsArray objectAtIndex:i];
       
        
        UIImage* arrowImg = [UIImage imageNamed:@"list_side_arrow"];
        UIImageView* arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 9, 16)];
        [arrowImgView setImage:arrowImg];
 
        
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
        titleLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:14];

        titleLabel.textAlignment = NSTextAlignmentRight;
        titleLabel.text = [sect objectForKey:@"name"];
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, view_y, 320, 50)];
        UIImage* img;
        if ([titleLabel.text isEqualToString:@"المطبخ"]||[titleLabel.text isEqualToString:@"Kitchen"]) {
            img=[UIImage imageNamed:@"cooknig_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"غرفة المعيشة"]||[titleLabel.text isEqualToString:@"living room"]) {
            img=[UIImage imageNamed:@"Lobby_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"غرفة النوم"]||[titleLabel.text isEqualToString:@"bed room"]) {
            img=[UIImage imageNamed:@"badroom_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"الحمام"]||[titleLabel.text isEqualToString:@"bath room"]) {
            img=[UIImage imageNamed:@"bathroom_icon"];
        }
        
        else if ([titleLabel.text isEqualToString:@"غرفة الطعام"]||[titleLabel.text isEqualToString:@"dining room"]) {
            img=[UIImage imageNamed:@"dining_room_icon"];
        }
        else if ([titleLabel.text isEqualToString:@"الحديقة"]||[titleLabel.text isEqualToString:@"garden"]) {
            img=[UIImage imageNamed:@"garden_room_icon"];
        }
        else{
            img=[UIImage imageNamed:@""];
        }
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(285, 15, 15, 15)];
        [imgView setImage:img];
        
        UILabel* statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 70, 50)];
        statusLabel.textAlignment = NSTextAlignmentLeft;
        statusLabel.font=[UIFont fontWithName:@"HelveticaNeue-Bold" size:13];

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
        v.layer.borderColor = [UIColor lightGrayColor].CGColor;
        v.layer.borderWidth = 1.0f;
        [self.sectionScrollView addSubview:v];
        if (view_y > 285) {
            self.sectionScrollView.contentSize = CGSizeMake(320, view_y + 50);
        }
        view_y += 50;
        
        
    }
    [HUD1 hide:YES];
    
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
    if ([[segue identifier] isEqualToString:@"editProperty"]){
        
        AddNewAqarVC *AVC=segue.destinationViewController;
        AVC.propertyID=self.propertyID;
        AVC.isEditable=YES;        
    }

}


- (IBAction)editButtonPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"editProperty" sender:self];

}

- (IBAction)nxtImgBtnPrss:(id)sender {
 
    [self.prevImgButton setHidden:NO];
    int page=self.pageControl.currentPage;
    if (page<pageImages.count) {
        page++;
        CGRect frame = self.imgScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.imgScrollView scrollRectToVisible:frame animated:YES];
        
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
        CGRect frame = self.imgScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [self.imgScrollView scrollRectToVisible:frame animated:YES];
        
    }
    if (page==0){
        [self.prevImgButton setHidden:YES];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    NSLog(@"post new property");
    // Create Post
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)backButtonPressed:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadSectionPhoto{
    
    PFQuery *currentProperty = [PFQuery queryWithClassName:@"PropertyPhoto"];
    [currentProperty whereKey:@"propertyID" equalTo:self.propertyID];
    
    [currentProperty findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            PFFile *theImage;
            pageImages=[[NSMutableArray alloc] init];
            for (PFObject* ob in objects) {
                theImage = [ob objectForKey:@"imageFile"];
                UIImage *image=[UIImage imageWithData:[theImage getData]];
                [pageImages addObject:image];
            }
        }
        if (pageImages.count==0) {
            UIImage *image=[UIImage imageNamed:@"default_image_home"];
            [pageImages addObject:image];

        }
        pageCount=pageImages.count;
     
      
        if (pageCount==1||pageCount==0) {
            [self.nextImgButton setHidden:YES];
            [self.prevImgButton setHidden:YES];
        }
        else {
            self.nextImgButton.hidden=NO;
            self.prevImgButton.hidden=YES;
       
        }
        [self setScrollView];

        [HUD2 hide:YES];

    }];
}

#pragma mark - paging & scrollView

-(void)setScrollView{


    self.pageControl.currentPage = pageCount;
    self.pageControl.numberOfPages = pageCount;
    CGSize pagesScrollViewSize = self.imgScrollView.frame.size;
    self.imgScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageCount; ++i) {
        [pageViews addObject:[NSNull null]];
    }
    [self loadVisiblePages];
    
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.imgScrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.imgScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;

    
    int pageIndex=self.pageControl.currentPage;
 
    if ( (pageImages.count==1)||(pageImages.count==0)){
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
            CGRect frame = self.imgScrollView.bounds;
           // CGRect frame = CGRectMake(0, 0, 200 , 200);

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
            [self.imgScrollView addSubview:newPageView];
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


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    //[self.notesTxtView setInputAccessoryView:[enhancedKeyboard getToolbarWithDoneEnabled:YES]];

}


#pragma mark - KSEnhancedKeyboardDelegate Protocol

- (void)doneDidTouchDown
{
    [self.notesTxtView resignFirstResponder];
    
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
 
    return NO;
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
//	NSLog(@"Action button tapped at index %d!", index);
//	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@""
//														delegate:nil
//											   cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button")
//										  destructiveButtonTitle:NSLocalizedString(@"Delete", @"Delete button")
//											   otherButtonTitles:NSLocalizedString(@"Share", @"Share button"), nil];
//	[action showInView:self.view];
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
