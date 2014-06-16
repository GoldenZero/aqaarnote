//
//  CarListingViewController.m
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarListingViewController.h"

@interface CarListingViewController ()
{
    NSMutableArray* carArrays;
    
    SBPickerSelector *sortPicker;
    SBPickerSelector *CostPicker;
    
    NSArray* sortPickerArr;
    NSArray* costPickerArr;
    
    NSNumber* totalCost;
    NSInteger mekkaCost;
    NSInteger madinaCost;
    
    NSInteger chosenCarIndex;
    NSInteger priceAscending;
    NSInteger nameAscending;
    
}
@end

@implementation CarListingViewController

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
    priceAscending = 0;
    nameAscending = 2;
    
    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:17]];
    [self.nextBtn.titleLabel setFont:[UIFont lightGeSSOfSize:17]];
    [self.priceBtn.titleLabel setFont:[UIFont lightGeSSOfSize:13]];
    [self.sortBtn.titleLabel setFont:[UIFont lightGeSSOfSize:13]];
    [self.orderByLbl setFont:[UIFont lightGeSSOfSize:13]];
    
    
    //prepare the pickers
    //[self preparePickers];
    //get the data for the menu
    [self getListMenuData];

}

#pragma mark - Methods
-(void)getListMenuData
{
    self.pageTitle.text = @"السيارات";
    
    carArrays = [NSMutableArray new];
    
    NSDictionary *MenuDict = @{@"Type" : self.formObj.carType,
                               @"Image" : @"cheverolet.jpg",
                               @"Title" : @"cheverolet spark",
                               @"Cost" : @"38",
                               @"Cost_all" : [NSString stringWithFormat:@"%li",38 * self.formObj.rentalDays]};
    
    [carArrays addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Type" : self.formObj.carType,
                 @"Image" : @"Sunny.jpg",
                 @"Title" : @"Nissan Sunny",
                 @"Cost" : @"42",
                 @"Cost_all" : [NSString stringWithFormat:@"%li",42 * self.formObj.rentalDays]};
    [carArrays addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Type" :self.formObj.carType,
                 @"Image" : @"Aveo.jpg",
                 @"Title" : @"Cheverolet Aveo",
                 @"Cost" : @"46",
                 @"Cost_all" : [NSString stringWithFormat:@"%li",46 * self.formObj.rentalDays]};
    [carArrays addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Type" : self.formObj.carType,
                 @"Image" : @"dodge.jpg",
                 @"Title" : @"Dodge Avenger",
                 @"Cost" : @"80",
                 @"Cost_all" : [NSString stringWithFormat:@"%li",80 * self.formObj.rentalDays]};
    [carArrays addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Type" : self.formObj.carType,
                 @"Image" : @"altima.jpg",
                 @"Title" : @"Nissan Altima",
                 @"Cost" : @"89",
                 @"Cost_all" : [NSString stringWithFormat:@"%li",89 * self.formObj.rentalDays]};
    [carArrays addObject:MenuDict];
    
    
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
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextInvoked:(id)sender {
   
        self.formObj.BookingCost = [NSString stringWithFormat:@"%@",totalCost];
        //go to the reservation details
        [self performSegueWithIdentifier:@"showTimeLine" sender:self];
    
}

- (IBAction)sortByInvoked:(id)sender {
    //show the picker for sorting types [leastprice[0] ,mostprice[1] , stars[2] , name[3]]
    //[sortPicker showPickerOver:self];
    
    NSArray* sortedArr = carArrays;
    carArrays = [NSMutableArray new];
    carArrays = [[NSMutableArray alloc]initWithArray:[self sortArrayBy:priceAscending andArray:sortedArr]]; // price
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (IBAction)changePriceInvoked:(id)sender {
    //show the prices type [for one , for all]
    //[CostPicker showPickerOver:self];
    NSArray* sortedArr = carArrays;
    carArrays = [NSMutableArray new];
    carArrays = [[NSMutableArray alloc]initWithArray:[self sortArrayBy:nameAscending andArray:sortedArr]]; // price
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (IBAction)openHotelDetails:(id)sender {
    UIButton* imgButton = (UIButton*)sender;
    chosenCarIndex=imgButton.tag;
    [self performSegueWithIdentifier:@"showCarDetails" sender:self];
    
}
#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [carArrays count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    NSDictionary* dictionary = [carArrays objectAtIndex:indexPath.row];
    
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CarCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    
    cell.titleLbl.text = dictionary[@"Title"];
    cell.typeLbl.text = dictionary[@"Type"];
    cell.rentalDaysLbl.text = [NSString stringWithFormat:@"%li Days",(long)self.formObj.rentalDays];
    [cell.menuImg setImage:[UIImage imageNamed:dictionary[@"Image"]]];
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
    NSDictionary* dictionary = [carArrays objectAtIndex:indexPath.row];
    NSString* currCost = dictionary[@"Cost_all"];
    self.formObj.CarData = dictionary;
    totalCost = [NSNumber numberWithInteger:[currCost integerValue]];
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
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:NO];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            nameAscending = 3;
            return sorted;
            
        }
            break;
        case 3:
        {
            [self.priceBtn setImage:[UIImage imageNamed:@"sort_arrow_down"] forState:UIControlStateNormal];
            [self.sortBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
            
            sorted = [myArr sortedArrayUsingDescriptors:@[sortDescriptor]];
            nameAscending = 2;
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
        NSArray* sortedArr = carArrays;
        carArrays = [NSMutableArray new];
        carArrays = [[NSMutableArray alloc]initWithArray:[self sortArrayBy:idx andArray:sortedArr]]; // price
        [self.tableView setNeedsDisplay];
        [self.tableView reloadData];
    }else if (selector.tag == 1)
    {
        if (idx == 1) {
            [self.tableView setNeedsDisplay];
            [self.tableView reloadData];
        }else{
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
    
    else if ([[segue identifier] isEqualToString:@"showCarDetails"]){
        CarDetailsVC* vc = segue.destinationViewController;
        NSDictionary *carDictionary=[carArrays objectAtIndex:chosenCarIndex];
        vc.hotelCost=[carDictionary objectForKey:@"Cost"];
        vc.pageImages=[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:(NSString*)[carDictionary objectForKey:@"Image"]], nil ];
        vc.hotelName=[carDictionary objectForKey:@"Title"];
        vc.carLocation = self.formObj.FromPlace;
        
    }
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

@end
