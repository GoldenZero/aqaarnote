//
//  HotelDetailsVC.m
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HotelDetailsVC.h"

@interface HotelDetailsVC ()

@end

@implementation HotelDetailsVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons Actions

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnPrss:(id)sender {
    
}

#pragma mark - Scroll View Delegate Handler

- (void)setScrollView{
    
//    self.pageControl.currentPage = pageCount;
//    self.pageControl.numberOfPages = pageCount;
//    CGSize pagesScrollViewSize = self.imagesScrollView.frame.size;
//    self.imagesScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
//    pageViews = [[NSMutableArray alloc] init];
//    for (NSInteger i = 0; i < pageCount; ++i) {
//        [pageViews addObject:[NSNull null]];
//    }
    [self loadVisiblePages];
}


- (void)loadVisiblePages {
//    // First, determine which page is currently visible
//    CGFloat pageWidth = self.imagesScrollView.frame.size.width;
//    NSInteger page = (NSInteger)floor((self.imagesScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
//    
//    // Update the page control
//    self.pageControl.currentPage = page;
//    
//    
//    
//    // Work out which pages you want to load
//    NSInteger firstPage = page - 1;
//    NSInteger lastPage = page + 1;
//    
//    // Purge anything before the first page
//    for (NSInteger i=0; i<firstPage; i++) {
//        [self purgePage:i];
//    }
//    for (NSInteger i=firstPage; i<=lastPage; i++) {
//        [self loadPage:i];
//    }
//    for (NSInteger i=lastPage+1; i<pageImages.count; i++) {
//        [self purgePage:i];
//    }
}

- (void)loadPage:(NSInteger)page {
//    if (page < 0 || page >= pageImages.count) {
//        // If it's outside the range of what we have to display, then do nothing
//        return;
//    }
//    
//    else{
//        // Load an individual page, first checking if you've already loaded it
//        UIView *pageView = [pageViews objectAtIndex:page];
//        if ((NSNull*)pageView == [NSNull null]) {
//            CGRect frame = self.imagesScrollView.bounds;
//            frame.origin.x = frame.size.width * page;
//            frame.origin.y = 0.0f;
//            frame = CGRectInset(frame, 20.0f, 30.0f);
//            
//            PFFile *theImage = [[(PropertyImageObj*)[pageImages objectAtIndex:page] imagePFObject] objectForKey:@"imageFile"];
//            UIImage *image =[UIImage imageWithData:[theImage getData]];
//            
//            UIImageView *newPageView = [[UIImageView alloc] initWithImage:image];
//            newPageView.userInteractionEnabled = YES;
//            newPageView.tag=page;
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
//            tap.numberOfTapsRequired = 1;
//            tap.cancelsTouchesInView=YES;
//            
//            [newPageView addGestureRecognizer:tap];
//            
//            
//            newPageView.contentMode = UIViewContentModeScaleAspectFit;
//            newPageView.frame = frame;
//            [self.imagesScrollView addSubview:newPageView];
//            [pageViews replaceObjectAtIndex:page withObject:newPageView];
//        }
//        
//    }
}

-(void)imageTapped:(UITapGestureRecognizer *)gesture
{
    
    [self.browserView showFromIndex:0];
    
}

- (void)purgePage:(NSInteger)page {
//    if (page < 0 || page >= pageImages.count) {
//        // If it's outside the range of what you have to display, then do nothing
//        return;
//    }
//    
//    // Remove a page from the scroll view and reset the container array
//    UIView *pageView = [pageViews objectAtIndex:page];
//    if ((NSNull*)pageView != [NSNull null]) {
//        [pageView removeFromSuperview];
//        [pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

#pragma mark - AGPhotoBrowser Delegate Handler

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    	return 0;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    
//    PFFile *theImage = [[(PropertyImageObj*)[pageImages objectAtIndex:index] imagePFObject] objectForKey:@"imageFile"];
//    UIImage *image=[UIImage imageWithData:[theImage getData]];
    
	return nil;
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


#pragma mark - DYRateViewDelegate

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    
}


// TODO
//
//- (void)setUpEditableRateView {
//    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
//    rateView.padding = 20;
//    rateView.alignment = RateViewAlignmentCenter;
//    rateView.editable = YES;
//    rateView.delegate = self;
//    [self.view addSubview:rateView];
//    [rateView release];
//    
//    // Set up a label view to display rate
//    self.rateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 20)] autorelease];
//    self.rateLabel.textAlignment = UITextAlignmentCenter;
//    self.rateLabel.text = @"Tap above to rate";
//    [self.view addSubview:self.rateLabel];
//}
//
//- (void)setUpLeftAlignedRateView {
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 120, 20)];
//    label.text = @"Left aligned:";
//    [self.view addSubview:label];
//    [label release];
//    
//    DYRateView *rateView = [[[DYRateView alloc] initWithFrame:CGRectMake(140, 140, 160, 14)] autorelease];
//    rateView.rate = 4.7;
//    rateView.alignment = RateViewAlignmentLeft;
//    [self.view addSubview:rateView];
//}
//


// [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

//- (void) onTimer {
//    
//    // Updates the variable h, adding 100 (put your own value here!)
//    h += 100;
//    
//    //This makes the scrollView scroll to the desired position
//    yourScrollView.contentOffset = CGPointMake(0, h);
//    
//}

@end
