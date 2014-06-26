//
//  HotelListingViewController.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HotelListingViewController.h"
#import "HotelDetailsVC.h"
#import "HotelMadinaEntity.h"
#import "HotelEntity.h"

@interface HotelListingViewController ()
{
    NSArray* hotelArrays;
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
    
    AppDelegate* appDelegate;

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
    
    appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    

    priceForOneGuest = YES;
    priceAscending = 0;
    starsAscending = 2;

    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:17]];
    [self.nextBtn.titleLabel setFont:[UIFont lightGeSSOfSize:17]];
    [self.priceBtn.titleLabel setFont:[UIFont lightGeSSOfSize:13]];
    [self.sortBtn.titleLabel setFont:[UIFont lightGeSSOfSize:13]];
    [self.orderByLbl setFont:[UIFont lightGeSSOfSize:13]];


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
        
        hotelArrays =  [appDelegate getAllHotels ];

    }
    else if (self.listingType == ListingTypeMadina) {
    
        self.pageTitle.text = @"فنادق المدينة المنورة";

        hotelArrays =  [appDelegate getAllMadinaHotels ];

    }
    
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
        self.formObj.BookingCost = [NSString stringWithFormat:@"%@", totalCost];
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
    HotelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HotelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"HotelCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    
    if (self.listingType == ListingTypeMekka) {
        HotelEntity* dictionary = [hotelArrays objectAtIndex:indexPath.row];
        
        cell.guestNumbLbl.text = [NSString stringWithFormat:@"%i",self.formObj.guestsNumber];
        cell.titleLbl.text = dictionary.title;
        [cell.menuImg setImage:[UIImage imageNamed:dictionary.image]];
        [cell.rateStarImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%@",dictionary.stars]]];
        if (priceForOneGuest)
            cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",dictionary.cost];
        else
            cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",dictionary.cost_all];

    }
    else if (self.listingType == ListingTypeMadina) {
        HotelMadinaEntity* dictionary = [hotelArrays objectAtIndex:indexPath.row];
        
        cell.guestNumbLbl.text = [NSString stringWithFormat:@"%i",self.formObj.guestsNumber];
        cell.titleLbl.text = dictionary.title;
        [cell.menuImg setImage:[UIImage imageNamed:dictionary.image]];
        [cell.rateStarImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"rating_%@",dictionary.stars]]];
        if (priceForOneGuest)
            cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",dictionary.cost];
        else
            cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",dictionary.cost_all];

    }
    
   
    cell.imgButton.tag=indexPath.row;
    [cell.imgButton addTarget:self
                       action:@selector(openHotelDetails:)
                     forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.listingType == ListingTypeMekka){
        HotelEntity* dictionary = [hotelArrays objectAtIndex:indexPath.row];
        NSString* currCost =[NSString stringWithFormat:@"%@", dictionary.cost_all];

        mekkaCost = [currCost integerValue];
        self.formObj.MekkaHotelData = dictionary;
    }
    else if (self.listingType == ListingTypeMadina){
        HotelMadinaEntity* dictionary = [hotelArrays objectAtIndex:indexPath.row];
        NSString* currCost = [NSString stringWithFormat:@"%@", dictionary.cost_all];

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
            [self.sortBtn setImage:[UIImage imageNamed:@"sort_arrow_up"] forState:UIControlStateNormal];
            [self.priceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Cost" ascending:YES];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            priceAscending = 1;
            return sorted;
            
        }
            break;
            
        case 1:
        {
            [self.sortBtn setImage:[UIImage imageNamed:@"sort_arrow_down"] forState:UIControlStateNormal];
            [self.priceBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Cost" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            priceAscending = 0;
            return sorted;
            
        }
            break;
            
        case 2:
        {
            [self.priceBtn setImage:[UIImage imageNamed:@"sort_arrow_up"] forState:UIControlStateNormal];
            [self.sortBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Stars" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            starsAscending = 3;
            return sorted;
            
        }
            break;
        case 3:
        {
            [self.priceBtn setImage:[UIImage imageNamed:@"sort_arrow_down"] forState:UIControlStateNormal];
            [self.sortBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

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
        if (self.listingType == ListingTypeMekka){
            HotelEntity *hotelDictionary=[hotelArrays objectAtIndex:chosenHotelIndex];
            vc.hotelCost=[NSString stringWithFormat:@"%@", hotelDictionary.cost];
            vc.starsNumber=[hotelDictionary.stars intValue];
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:(NSString*)hotelDictionary.image], nil ];
            vc.hotelName=hotelDictionary.title;
            vc.locationTxtView.text=hotelDictionary.location;
            vc.describTxtView.text=hotelDictionary.notes;

        }
        else if (self.listingType == ListingTypeMadina){
            HotelMadinaEntity *hotelDictionary=[hotelArrays objectAtIndex:chosenHotelIndex];
            vc.hotelCost=[NSString stringWithFormat:@"%@", hotelDictionary.cost];
            vc.starsNumber=[hotelDictionary.stars intValue];
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:(NSString*)hotelDictionary.image], nil ];
            vc.hotelName=hotelDictionary.title;
            vc.locationTxtView.text=hotelDictionary.location;
            vc.describTxtView.text=hotelDictionary.notes;

        }
        
    }
}


@end
