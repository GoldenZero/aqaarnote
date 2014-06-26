//
//  CarDetailsVC.m
//  alhanove
//
//  Created by GALMarei on 6/16/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarDetailsVC.h"
#import "CarFeatureCell.h"
@interface CarDetailsVC ()
{
    NSMutableArray *pageViews;
    NSInteger currentPage;
    NSMutableArray *capacityArray;
    NSMutableArray *equipmentArray;
    
}

@end

@implementation CarDetailsVC
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
    
    
    if ([[UIScreen mainScreen] bounds].size.height != 568){
        self.contentScrollView.contentSize = CGSizeMake(320, 600);
    }
    
    [self prepareViewContent];
    
}


-(void) prepareViewContent{
    
    // Set Custom font
    self.hotelTitle.text=self.hotelName;
    [self.hotelTitle setFont:[UIFont mediumGeSSOfSize:20]];
    [self.titlesScreen setFont:[UIFont mediumGeSSOfSize:20]];
    self.priceLabel.text=[NSString stringWithFormat:@"%@ $",self.hotelCost];
    [self.priceLabel setFont:[UIFont mediumGeSSOfSize:18]];
    [self.reviewLabel setFont:[UIFont mediumGeSSOfSize:13]];
    
    capacityArray=[[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"عدد الراكبين" forKey:@"Label"];
    [dic setObject:[NSString stringWithFormat:@"%@", self.carDetails.passengers] forKey:@"Value"];
    [dic setObject:@"passenger" forKey:@"Image"];
    [capacityArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"عدد الحقائب" forKey:@"Label"];
    [dic setObject:@"٣" forKey:@"Value"];
    [dic setObject:@"baggage" forKey:@"Image"];
    [capacityArray addObject:dic];
    
    equipmentArray=[[NSMutableArray alloc] init];
    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"عدد الأبواب" forKey:@"Label"];
    [dic setObject:[NSString stringWithFormat:@"%@", self.carDetails.doors] forKey:@"Value"];
    [dic setObject:@"car" forKey:@"Image"];
    [equipmentArray addObject:dic];

    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"تكييف" forKey:@"Label"];
    [dic setObject:[NSString stringWithFormat:@"%@",[self.carDetails.airCond boolValue] ? @"Yes" : @"No"] forKey:@"Value"];
    [dic setObject:@"AC" forKey:@"Image"];
    [equipmentArray addObject:dic];

    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"GPS" forKey:@"Label"];
    [dic setObject:@"متوفر" forKey:@"Value"];
    [dic setObject:@"gps" forKey:@"Image"];
    [equipmentArray addObject:dic];
 
    dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"Automatic" forKey:@"Label"];
    [dic setObject:[NSString stringWithFormat:@"%@",[self.carDetails.automatic boolValue] ? @"Yes" : @"No"] forKey:@"Value"];
    [dic setObject:@"gear_shift" forKey:@"Image"];
    [equipmentArray addObject:dic];
    
    if(!self.pageImages){
        pageImages=[[NSMutableArray alloc] initWithObjects:
                    [UIImage imageNamed:@"Sunny.jpg"],
                    [UIImage imageNamed:@"altima.jpg"],
                    [UIImage imageNamed:@"Aveo.jpg"],
                    [UIImage imageNamed:@"cheverolet.jpg"],nil];
        
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

    [UIView animateKeyframesWithDuration:0.5 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.75 animations:^{
            [self.imagesScrollView setContentOffset:CGPointMake(floorf(aPage/2) * myPageWidth, 0)];
        }];
        [UIView addKeyframeWithRelativeStartTime:1 relativeDuration:0.75 animations:^{
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
    if (currentPage==pageImages.count) {
        currentPage=0;
    }
    
    [self scrollToPage:currentPage];
    currentPage++;
    
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
    
    return NO;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Delegate
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    if (section==0) {
         label.text= @"السعة";
    }
    else{
         label.text= @"معدات";
    }
    [label setFont:[UIFont lightGeSSOfSize:12]];

    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentRight;
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarFeatureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[CarFeatureCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"CellIdentifier@"];
    }
    NSDictionary *dic;
    if (indexPath.section==0) {
       dic=[capacityArray objectAtIndex:indexPath.row];

    }
    else{
        dic=[equipmentArray objectAtIndex:indexPath.row];
    }
    cell.title.text=[NSString stringWithFormat:@"%@ : %@" ,[dic objectForKey:@"Label"],[dic objectForKey:@"Value"]];
    [cell.title setFont:[UIFont lightGeSSOfSize:12]];

    cell.icon.image=[UIImage imageNamed:[dic objectForKey:@"Image"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return capacityArray.count;
    }
    else{
        return equipmentArray.count;
    }
    
}
- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"معدات";
    }
    else{
        return @"السعة";
    }
}
@end
