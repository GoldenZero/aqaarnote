//
//  HotelListingViewController.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HotelListingViewController.h"
#import "HotelDetailsVC.h"

@interface HotelListingViewController ()
{
    NSMutableArray* hotelArrays;
    BOOL priceForOneGuest;
    
    SBPickerSelector *sortPicker;
    SBPickerSelector *CostPicker;
    
    NSArray* sortPickerArr;
    NSArray* costPickerArr;

    NSNumber* totalCost;
    NSInteger mekkaCost;
    NSInteger madinaCost;
    
    int chosenHotelIndex;
    NSInteger priceAscending;
    NSInteger starsAscending;

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
    priceAscending = 0;
    starsAscending = 2;

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
    if (self.listingType == ListingTypeMekka) {
        self.pageTitle.text = @"فنادق مكة المكرمة";
        
        hotelArrays = [NSMutableArray new];
        
        NSDictionary *MenuDict = @{@"Title" : @"هيلتون",
                                   @"Image" : @"hilton.jpg",
                                   @"Stars" : @"5",
                                   @"Cost" : @"480",
                                   @"Cost_all" : [NSString stringWithFormat:@"%i",480 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"دار التوحيد",
                     @"Image" : @"dar al tawhed.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"200",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",200 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict  = @{@"Title" : @"ميريديان",
                      @"Image" : @"meredian.jpg",
                      @"Stars" : @"5",
                      @"Cost" : @"600",
                      @"Cost_all" : [NSString stringWithFormat:@"%i",600 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"إيلاف كندا",
                     @"Image" : @"elaf kinda.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"260",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",260 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"أجياد مكة مكارم",
                     @"Image" : @"Ajyad.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"320",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",320 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
    }else if (self.listingType == ListingTypeMadina) {
        self.pageTitle.text = @"فنادق المدينة المنورة";

        hotelArrays = [NSMutableArray new];
        NSDictionary *MenuDict = @{@"Title" : @"هيلتون",
                                   @"Image" : @"hilton.jpg",
                                   @"Stars" : @"5",
                                   @"Cost" : @"600",
                                   @"Cost_all" : [NSString stringWithFormat:@"%i",600 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"أوبروي",
                     @"Image" : @"dar al tawhed.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"200",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",200 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict  = @{@"Title" : @"دار التقوى",
                      @"Image" : @"meredian.jpg",
                      @"Stars" : @"3",
                      @"Cost" : @"440",
                      @"Cost_all" : [NSString stringWithFormat:@"%i",440 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"الحرم",
                     @"Image" : @"elaf kinda.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"300",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",300 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"ديار انترناشيونال",
                     @"Image" : @"Ajyad.jpg",
                     @"Stars" : @"4",
                     @"Cost" : @"410",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",410 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"ديار",
                     @"Image" : @"hilton.jpg",
                     @"Stars" : @"3",
                     @"Cost" : @"360",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",360 * self.formObj.guestsNumber]};
        [hotelArrays addObject:MenuDict];
        
        MenuDict = nil;
        MenuDict = @{@"Title" : @"موفينبيك انوار المدينة",
                     @"Image" : @"meredian.jpg",
                     @"Stars" : @"5",
                     @"Cost" : @"520",
                     @"Cost_all" : [NSString stringWithFormat:@"%i",520 * self.formObj.guestsNumber]};
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
        madinaCost = 0;
        mekkaCost = 0;
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
        self.formObj.BookingCost = [NSString stringWithFormat:@"%@",totalCost];
        //go to the reservation details
        [self performSegueWithIdentifier:@"showTimeLine" sender:self];
    }
}

- (IBAction)sortByInvoked:(id)sender {
    //show the picker for sorting types [leastprice[0] ,mostprice[1] , stars[2] , name[3]]
    //[sortPicker showPickerOver:self];
    
    NSArray* sortedArr = hotelArrays;
    hotelArrays = [NSMutableArray new];
    hotelArrays = [[NSMutableArray alloc]initWithArray:[self sortArrayBy:priceAscending andArray:sortedArr]]; // price
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (IBAction)changePriceInvoked:(id)sender {
    //show the prices type [for one , for all]
    //[CostPicker showPickerOver:self];
    NSArray* sortedArr = hotelArrays;
    hotelArrays = [NSMutableArray new];
    hotelArrays = [[NSMutableArray alloc]initWithArray:[self sortArrayBy:starsAscending andArray:sortedArr]]; // price
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (IBAction)openHotelDetails:(id)sender {
    UIButton* imgButton = (UIButton*)sender;
    chosenHotelIndex=imgButton.tag;
    [self performSegueWithIdentifier:@"showHotelDetails" sender:self];
    
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

    cell.imgButton.tag=indexPath.row;
    [cell.imgButton addTarget:self
                       action:@selector(openHotelDetails:)
                     forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary* dictionary = [hotelArrays objectAtIndex:indexPath.row];
    NSString* currCost = dictionary[@"Cost_all"];
    if (self.listingType == ListingTypeMekka){
        mekkaCost = [currCost integerValue];
        self.formObj.MekkaHotelData = dictionary;
    }
    else if (self.listingType == ListingTypeMadina){
        madinaCost = [currCost integerValue];
        self.formObj.MadinaHotelData = dictionary;
    }
    
    totalCost = [NSNumber numberWithInteger:mekkaCost + madinaCost];
    
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
            priceAscending = 1;
            return sorted;
            
        }
            break;
            
        case 1:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Cost" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            priceAscending = 0;
            return sorted;
            
        }
            break;
            
        case 2:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Stars" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            starsAscending = 3;
            return sorted;
            
        }
            break;
        case 3:
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Stars" ascending:YES];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            starsAscending = 2;
            return sorted;
            
        }
            break;
            
        case 4:
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



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showTimeLine"])   //parameter to login page
    {
        TimeLineViewController* vc = segue.destinationViewController;
        vc.formObj = self.formObj;
    }
    
    else if ([[segue identifier] isEqualToString:@"showHotelDetails"]){
        HotelDetailsVC* vc = segue.destinationViewController;
        NSDictionary *hotelDictionary=[hotelArrays objectAtIndex:chosenHotelIndex];
        vc.hotelCost=[hotelDictionary objectForKey:@"Cost"];
        vc.starsNumber=[[hotelDictionary objectForKey:@"Stars"] integerValue];
        vc.pageImages=[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:(NSString*)[hotelDictionary objectForKey:@"Image"]], nil ];
        vc.hotelName=[hotelDictionary objectForKey:@"Title"];
        
    }
}


@end
