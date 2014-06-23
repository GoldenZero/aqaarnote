//
//  CarListingViewController.m
//  alhanove
//
//  Created by GALMarei on 6/15/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "CarListingViewController.h"
#import "CarSummaryViewController.h"
#import "CarEntity.h"

@interface CarListingViewController ()
{
    NSArray* carArrays;
    
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
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    // Fetching Records and saving it in "fetchedRecordsArray" object
    carArrays = [appDelegate getAllCarsRecords];
    [self.tableView reloadData];

    [self.pageTitle setFont:[UIFont mediumGeSSOfSize:17]];
    [self.nextBtn.titleLabel setFont:[UIFont lightGeSSOfSize:17]];
    [self.priceBtn.titleLabel setFont:[UIFont lightGeSSOfSize:13]];
    [self.sortBtn.titleLabel setFont:[UIFont lightGeSSOfSize:13]];
    [self.orderByLbl setFont:[UIFont lightGeSSOfSize:13]];
    
    
    //prepare the pickers
    //[self preparePickers];
    //get the data for the menu

}

#pragma mark - Methods
-(void)getListMenuData
{
    self.pageTitle.text = @"السيارات";
    
    carArrays = [NSMutableArray new];
    
    CarEntity * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                                      inManagedObjectContext:self.managedObjectContext];

    newEntry.title=@"cheverolet spark";
    newEntry.type=self.formObj.carType;
    newEntry.image= @"cheverolet.jpg";
    newEntry.cost=[NSNumber numberWithInt:38];
    newEntry.cost_all=[NSNumber numberWithLong:38 * self.formObj.rentalDays];
    
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                  inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Nissan Sunny";
    newEntry.type=self.formObj.carType;
    newEntry.image= @"Sunny.jpg";
    newEntry.cost=[NSNumber numberWithInt:42];
    newEntry.cost_all=[NSNumber numberWithLong:42 * self.formObj.rentalDays];

    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Cheverolet Aveo";
    newEntry.type=self.formObj.carType;
    newEntry.image= @"Aveo.jpg";
    newEntry.cost=[NSNumber numberWithInt:46];
    newEntry.cost_all=[NSNumber numberWithLong:46 * self.formObj.rentalDays];

 
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Dodge Avenger";
    newEntry.type=self.formObj.carType;
    newEntry.image= @"dodge.jpg";
    newEntry.cost=[NSNumber numberWithInt:80];
    newEntry.cost_all=[NSNumber numberWithLong:80 * self.formObj.rentalDays];
  
    
    newEntry=nil;
    
    newEntry= [NSEntityDescription insertNewObjectForEntityForName:@"CarEntity"
                                            inManagedObjectContext:self.managedObjectContext];
    
    newEntry.title=@"Nissan Altima";
    newEntry.type=self.formObj.carType;
    newEntry.image= @"altima.jpg";
    newEntry.cost=[NSNumber numberWithInt:89];
    newEntry.cost_all=[NSNumber numberWithLong:89 * self.formObj.rentalDays];
    

    //reflect to the table
    
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
   
        self.formObj.carCost = [NSString stringWithFormat:@"%@",totalCost];
        //go to the reservation details
    [self performSegueWithIdentifier:@"showCarSummary" sender:self];
    
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
    CarEntity* car = [carArrays objectAtIndex:indexPath.row];
    
    CarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CarCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    
    cell.titleLbl.text = car.title;
    cell.typeLbl.text = car.type;
    cell.rentalDaysLbl.text = [NSString stringWithFormat:@"%li Days",(long)self.formObj.rentalDays];
    [cell.menuImg setImage:[UIImage imageNamed:car.image]];
        cell.costLbl.text = [NSString stringWithFormat:@"%@ SR",car.cost];
    cell.imgButton.tag=indexPath.row;
    [cell.imgButton addTarget:self
                       action:@selector(openHotelDetails:)
             forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CarEntity* car = [carArrays objectAtIndex:indexPath.row];
    self.formObj.CarData = car;
    totalCost = [NSNumber numberWithInteger:[car.cost integerValue] *self.formObj.rentalDays];
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
    if ([[segue identifier] isEqualToString:@"showCarSummary"])   //parameter to login page
    {
        //TimeLineViewController* vc = segue.destinationViewController;
        //vc.formObj = self.formObj;
        CarSummaryViewController* vc = segue.destinationViewController;
        vc.formObj = self.formObj;
    }
    
    else if ([[segue identifier] isEqualToString:@"showCarDetails"]){
        CarDetailsVC* vc = segue.destinationViewController;
        NSDictionary *carDictionary=[carArrays objectAtIndex:chosenCarIndex];
        vc.hotelCost=[carDictionary objectForKey:@"Cost"];
        vc.hotelName=[carDictionary objectForKey:@"Title"];
        if ([[carDictionary objectForKey:@"Title"] isEqualToString:@"cheverolet spark"]) {
            
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:
                           [UIImage imageNamed:@"chevrolet_spark_1.jpg"],
                           [UIImage imageNamed:@"chevrolet_spark_2.jpg"],
                           [UIImage imageNamed:@"chevrolet_spark_3.jpg"],
                           nil ];
            
        }
        else if ([[carDictionary objectForKey:@"Title"] isEqualToString:@"Nissan Sunny"]) {
            
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:
                           [UIImage imageNamed:@"nissan_sunny_1.jpg"],
                           [UIImage imageNamed:@"nissan_sunny_2.jpg"],
                           [UIImage imageNamed:@"nissan_sunny_3.jpg"],
                           nil ];

        }
        
        else if ([[carDictionary objectForKey:@"Title"] isEqualToString:@"Cheverolet Aveo"]) {
    
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:
                           [UIImage imageNamed:@"chevrolet_aveo_1.jpg"],
                           [UIImage imageNamed:@"chevrolet_aveo_2.jpg"],
                           [UIImage imageNamed:@"chevrolet_aveo_3.png"],
                           nil ];
            
        }
        
        else if ([[carDictionary objectForKey:@"Title"] isEqualToString:@"Dodge Avenger"]) {
            
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:
                           [UIImage imageNamed:@"dodge_avenger_1.jpg"],
                           [UIImage imageNamed:@"dodge_avenger_2.jpg"],
                           [UIImage imageNamed:@"dodge_avenger_3.jpg"],
                           nil ];
            
        }
        
        else if ([[carDictionary objectForKey:@"Title"] isEqualToString:@"Nissan Altima"]) {
            
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:
                           [UIImage imageNamed:@"nissan_altima_1.jpg"],
                           [UIImage imageNamed:@"nissan_altima_2.jpg"],
                           [UIImage imageNamed:@"nissan_altima_3.jpg"],
                           nil ];
            
        }
        
        else{
            vc.pageImages=[[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:(NSString*)[carDictionary objectForKey:@"Image"]], nil ];
        }
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
