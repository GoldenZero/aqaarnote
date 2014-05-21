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
    BOOL priceForOneGuest;
    
    SBPickerSelector *sortPicker;
    SBPickerSelector *CostPicker;
    
    NSArray* sortPickerArr;
    NSArray* costPickerArr;


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
    
    priceForOneGuest = YES;
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:20]];
    [self.nextBtn.titleLabel setFont:[UIFont lightGeSSOfSize:17]];

    //prepare the pickers
    [self preparePickers];
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
    if (!self.guestNumber)
        self.guestNumber = [NSNumber numberWithInt:3];
        
    if (self.listingType == ListingTypeMekka) {
        self.pageTitle.text = @"فنادق مكة المكرمة";
        
        hotelArrays = [NSMutableArray new];
        
        NSDictionary *MenuDict = @{@"Title" : @"هيلتون",
                                   @"Image" : @"hilton.jpg",
                                   @"Stars" : @"5",
                                   @"Cost" : @"480",
                                   @"Cost_all" : [NSString stringWithFormat:@"%i",480 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"دار التوحيد",
                     @"Image" : @"dar al tawhed.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"200",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",200 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict  = @{@"Title" : @"ميريديان",
                      @"Image" : @"meredian.jpg",
                      @"Stars" : @"5",
                      @"Cost" : @"600",
                      @"Cost_all" : [NSString stringWithFormat:@"%i",600 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"إيلاف كندا",
                     @"Image" : @"elaf kinda.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"260",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",260 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"أجياد مكة مكارم",
                     @"Image" : @"Ajyad.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"320",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",320 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
    }else if (self.listingType == ListingTypeMadina) {
        self.pageTitle.text = @"فنادق المدينة المنورة";

        hotelArrays = [NSMutableArray new];
        NSDictionary *MenuDict = @{@"Title" : @"هيلتون",
                                   @"Image" : @"hilton.jpg",
                                   @"Stars" : @"5",
                                   @"Cost" : @"600",
                                   @"Cost_all" : [NSString stringWithFormat:@"%i",600 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"أوبروي",
                     @"Image" : @"dar al tawhed.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"200",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",200 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict  = @{@"Title" : @"دار التقوى",
                      @"Image" : @"meredian.jpg",
                      @"Stars" : @"3",
                      @"Cost" : @"440",
                      @"Cost_all" : [NSString stringWithFormat:@"%i",440 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"الحرم",
                     @"Image" : @"elaf kinda.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"300",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",300 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"ديار انترناشيونال",
                     @"Image" : @"Ajyad.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"410",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",410 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"ديار",
                     @"Image" : @"hilton.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"360",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",360 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"موفينبيك انوار المدينة",
                     @"Image" : @"meredian.jpg",
                     @"Stars" : @"5",
                     @"Cost" : @"520",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",520 * [self.guestNumber integerValue]]};
        [hotelArrays addObject:MenuDict];
    }
    
    //reflect to the table
    [self.tableView reloadData];
    
}

-(void)preparePickers
{
    sortPickerArr = [NSArray arrayWithObjects:@"Least Price",@"Most Price",@"Stars",@"A-Z",nil];
    
    costPickerArr = [NSArray arrayWithObjects:@"Cost Per 1 Guest",@"Total Cost for Guests",nil];
    
    sortPicker = [SBPickerSelector picker];
    sortPicker.tag = 0;
    sortPicker.pickerData = [[NSMutableArray alloc] initWithArray:sortPickerArr]; //picker content
    sortPicker.pickerType = SBPickerSelectorTypeText;
    sortPicker.delegate = self;
    sortPicker.doneButtonTitle = @"تم";
    sortPicker.cancelButtonTitle = @"إلغاء";
    
    
    CostPicker = [SBPickerSelector picker];
    CostPicker.tag = 1;
    CostPicker.pickerData = [[NSMutableArray alloc] initWithArray:costPickerArr]; //picker content
    CostPicker.pickerType = SBPickerSelectorTypeText;
    CostPicker.delegate = self;
    CostPicker.doneButtonTitle = @"تم";
    CostPicker.cancelButtonTitle = @"إلغاء";
    
    
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

- (IBAction)sortByInvoked:(id)sender {
    //show the picker for sorting types [leastprice[0] ,mostprice[1] , stars[2] , name[3]]
    [sortPicker showPickerOver:self];
}

- (IBAction)changePriceInvoked:(id)sender {
    //show the prices type [for one , for all]
    [CostPicker showPickerOver:self];
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
    if (priceForOneGuest)
        cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",dictionary[@"Cost"]];
    else
        cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",dictionary[@"Cost_all"]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self nextInvoked:self];
}


#pragma mark - Array sorting
-(NSArray*)sortArrayBy:(NSInteger)sortType andArray:(NSArray*)myArr
{
    NSArray *sorted;
    switch (sortType) {
        case 0:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Cost" ascending:YES];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            return sorted;

        }
            break;
            
        case 1:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Cost" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            return sorted;

        }
            break;
        
        case 2:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Stars" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            return sorted;
            
        }
            break;
            
        case 3:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            
            return sorted;
            
        }
            break;
        default:
            break;
    }
    return sorted;
}

#pragma mark - UIPicker

//if your piker is a traditional selection
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx
{
    if (selector.tag == 0) {
        NSArray* sortedArr = hotelArrays;
        hotelArrays = [NSMutableArray new];
        hotelArrays = [[NSMutableArray alloc]initWithArray:[self sortArrayBy:idx andArray:sortedArr]]; // price
        [self.tableView setNeedsDisplay];
        [self.tableView reloadData];
    }else if (selector.tag == 1)
    {
        if (idx == 1) {
            priceForOneGuest = NO;
            [self.tableView setNeedsDisplay];
            [self.tableView reloadData];
        }else{
            priceForOneGuest = YES;
            [self.tableView setNeedsDisplay];
            [self.tableView reloadData];
        }
    }
}

//when picker value is changing
-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx
{
    
}

//if the user cancel the picker
-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel
{
    
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
