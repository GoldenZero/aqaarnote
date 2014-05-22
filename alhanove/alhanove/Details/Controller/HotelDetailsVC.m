//
//  HotelDetailsVC.m
//  alhanove
//
//  Created by Noor on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HotelDetailsVC.h"

@interface HotelDetailsVC (){
    NSMutableArray *pageViews;
    NSInteger currentPage;
}

@end

@implementation HotelDetailsVC
@synthesize pageImages;
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
    [self setUpLeftAlignedRateView:self.starsNumber];
    [self prepareViewContent];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareViewContent{
    
    if(!self.pageImages){
        pageImages=[[NSMutableArray alloc] initWithObjects:
                     [UIImage imageNamed:@"hilton1.jpg"],
                     [UIImage imageNamed:@"hilton2.jpg"],
                     [UIImage imageNamed:@"hilton3.jpg"],
                     [UIImage imageNamed:@"hilton4.jpg"],nil];

    }
    [self setScrollView];
    [self loadBannerImgs];
}
#pragma mark - Buttons Actions

- (IBAction)backBtnPrss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnPrss:(id)sender {
    
}

- (IBAction)contiueBtnPrss:(id)sender {
}

#pragma mark - Scroll View Delegate Handler

- (void) loadBannerImgs{
    currentPage=0;
    
    [self setScrollView];
    
    [[NSTimer scheduledTimerWithTimeInterval:2
                                      target:self
                                    selector:@selector(scrollPages)
                                    userInfo:Nil
                                     repeats:YES] fire];
    
}


#pragma mark - paging & scrollView

-(void)setScrollView{
    for (UIView *subview in self.imagesScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.pageControl.currentPage = pageImages.count;
    self.pageControl.numberOfPages = pageImages.count;
    CGSize pagesScrollViewSize = self.imagesScrollView.frame.size;
    self.imagesScrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * pageImages.count, pagesScrollViewSize.height);
    pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < pageImages.count; ++i) {
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
            //   frame.origin.y = 0.0f;
            //      frame = CGRectInset(frame, 10.0f, 0.0f);
            
            UIImageView *newPageView = [[UIImageView alloc] initWithImage:[pageImages objectAtIndex:page]];
            newPageView.userInteractionEnabled = YES;
            newPageView.tag=page;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            tap.numberOfTapsRequired = 1;
            tap.cancelsTouchesInView=YES;
            
            [newPageView addGestureRecognizer:tap];

         //   newPageView.contentMode = UIViewContentModeScaleAspectFit;
            newPageView.frame = frame;
            [self.imagesScrollView addSubview:newPageView];
            [pageViews replaceObjectAtIndex:page withObject:newPageView];
        }
        
    }
}

-(void)scrollToPage:(NSInteger)aPage{
    float myPageWidth = [self.imagesScrollView frame].size.width;
    [UIView animateKeyframesWithDuration:0 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:1 animations:^{
            [self.imagesScrollView setContentOffset:CGPointMake(aPage * myPageWidth, 0)];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:1 animations:^{
            [self.imagesScrollView setContentOffset:CGPointMake(aPage*myPageWidth, 0)];
        }];
    } completion:^(BOOL finished) {
        //Completion Block
    }];
    
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

-(void)scrollPages{

    [self scrollToPage:currentPage];
    currentPage++;

    if (currentPage==pageImages.count) {
        currentPage=0;
    }

}

-(void)imageTapped:(UITapGestureRecognizer *)gesture
{
    
    [self.browserView showFromIndex:0];
    
}

#pragma mark - AGPhotoBrowser Delegate Handler

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowserView *)photoBrowser
{
    	return pageImages.count;
}

- (UIImage *)photoBrowser:(AGPhotoBrowserView *)photoBrowser imageAtIndex:(NSInteger)index
{
    
	return (UIImage*)[pageImages objectAtIndex:index];
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

- (void)setUpLeftAlignedRateView:(int) stars {

    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 0, 160, 21)];
    rateView.rate = stars;
    rateView.alignment = RateViewAlignmentRight;
    [self.starsView addSubview:rateView];
}


@end
