//
//  HotelListingViewController.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HotelListingViewController.h"

@interface HotelListingViewController ()
{
    NSMutableArray* hotelArrays;
}
@end

@implementation HotelListingViewController

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
    
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    [self.nextBtn.titleLabel setFont:[UIFont lightGeSSOfSize:17]];

    //get the data for the menu
    [self getListMenuData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
-(void)getListMenuData
{
    if (self.listingType == ListingTypeMekka) {
        self.pageTitle.text = @"فنادق مكة المكرمة";
        
        hotelArrays = [NSMutableArray new];
        NSDictionary *MenuDict = @{@"Title" : @"هيلتون",
                                   @"Image" : @"hilton.jpg",
                                   @"Stars" : @"5",
                                   @"Cost" : @"480 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"دار التوحيد",
                     @"Image" : @"dar al tawhed.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"200 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict  = @{@"Title" : @"ميريديان",
                      @"Image" : @"meredian.jpg",
                      @"Stars" : @"5",
                      @"Cost" : @"600 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"إيلاف كندا",
                     @"Image" : @"elaf kinda.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"260 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"أجياد مكة مكارم",
                     @"Image" : @"Ajyad.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"320 SA"};
        [hotelArrays addObject:MenuDict];
    }else if (self.listingType == ListingTypeMadina) {
        self.pageTitle.text = @"فنادق المدينة المنورة";

        hotelArrays = [NSMutableArray new];
        NSDictionary *MenuDict = @{@"Title" : @"هيلتون",
                                   @"Image" : @"hilton.jpg",
                                   @"Stars" : @"5",
                                   @"Cost" : @"600 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"أوبروي",
                     @"Image" : @"dar al tawhed.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"200 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict  = @{@"Title" : @"دار التقوى",
                      @"Image" : @"meredian.jpg",
                      @"Stars" : @"3",
                      @"Cost" : @"440 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"الحرم",
                     @"Image" : @"elaf kinda.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"300 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"ديار انترناشيونال",
                     @"Image" : @"Ajyad.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"410 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"ديار",
                     @"Image" : @"hilton.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"360 SA"};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"موفينبيك انوار المدينة",
                     @"Image" : @"meredian.jpg",
                     @"Stars" : @"5",
                     @"Cost" : @"520 SA"};
        [hotelArrays addObject:MenuDict];
    }
    
    //reflect to the table
    [self.tableView reloadData];
    
}

#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender {
    if (self.backBtn.tag == 0)
        [self dismissViewControllerAnimated:YES completion:nil];
    else if (self.backBtn.tag == 1)
    {
        self.listingType = ListingTypeMekka;
        self.nextBtn.tag = 0;
        self.backBtn.tag = 0;
        [self.nextBtn setTitle:@"التالي" forState:UIControlStateNormal];
        
        [self.tableView setNeedsDisplay];
        [self getListMenuData];

    }
}

- (IBAction)nextInvoked:(id)sender {
    if (self.nextBtn.tag == 0)
    {
        self.listingType = ListingTypeMadina;
        self.nextBtn.tag = 1;
        self.backBtn.tag = 1;
        [self.nextBtn setTitle:@"تم" forState:UIControlStateNormal];
        
        [self.tableView setNeedsDisplay];
        [self getListMenuData];
        
    }else if (self.nextBtn.tag == 1)
    {
        //go to the reservation details
        
    }
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [hotelArrays count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    NSDictionary* dictionary = [hotelArrays objectAtIndex:indexPath.row];
    
    HotelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HotelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HotelCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    cell.titleLbl.text = dictionary[@"Title"];
    [cell.menuImg setImage:[UIImage imageNamed:dictionary[@"Image"]]];
    [cell.rateStarImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%@",dictionary[@"Stars"]]]];
    cell.costLbl.text = dictionary[@"Cost"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

@end
