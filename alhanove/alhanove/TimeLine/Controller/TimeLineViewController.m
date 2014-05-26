//
//  TimeLineViewController.m
//  alhanove
//
//  Created by GALMarei on 5/21/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "TimeLineViewController.h"

@interface TimeLineViewController ()
{
    NSMutableArray* timelineDataArr;
    NSMutableArray* sectionDates;
}
@end

@implementation TimeLineViewController

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

    //get the data for the timeline
    [self getTimeLineData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
-(void)getTimeLineData
{
    timelineDataArr = [NSMutableArray new];
    
    NSMutableDictionary* dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/28";
    NSDictionary *MenuDict = @{@"Title" : @"بداية الرحلة",
                               @"Text" : @"الإنطلاق من نقطة التجمع",
                               @"Type" : @"step_1"};
    NSMutableArray* menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/29";
    MenuDict = @{@"Title" : @"حجز بالفندق",
                               @"Text" : self.formObj.MekkaHotelData[@"Title"],
                               @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/30";
    MenuDict = @{@"Title" : @"وجبة غذاء",
                               @"Text" : self.formObj.MekkaHotelData[@"Title"],
                               @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/05/31";
    MenuDict = @{@"Title" : @"بدئ العمرة",
                 @"Text" : @"الذهاب إلى الحرم",
                 @"Type" : @"step_1"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/06/03";
    MenuDict = @{@"Title" : @"حجز بالفندق",
                 @"Text" : self.formObj.MadinaHotelData[@"Title"],
                 @"Type" : @"step_2"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
    MenuDict = nil;
    dict = [NSMutableDictionary new];
    dict[@"sectionDate"] = @"2014/06/06";
    MenuDict = @{@"Title" : @"نهاية الرحلة",
                 @"Text" : @"تجهيز الاغراض والاستعداد للعودة",
                 @"Type" : @"step_3"};
    menuDictArr = [NSMutableArray new];
    [menuDictArr addObject:MenuDict];
    dict[@"data"] = menuDictArr;
    [timelineDataArr addObject:dict];
    
}


#pragma mark - IBAction
- (IBAction)backInvoked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextInvoked:(id)sender {
    [self performSegueWithIdentifier:@"showUserForm" sender:self];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [timelineDataArr count];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary* dict = [timelineDataArr objectAtIndex:section];
    NSArray* arr = dict[@"data"];
    return [arr count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary* dictionaryArray = [timelineDataArr objectAtIndex:section];
    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [lbl setText:dictionaryArray[@"sectionDate"]];
    
    return lbl;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    NSDictionary* dict = [timelineDataArr objectAtIndex:indexPath.section];
    NSArray* arr = dict[@"data"];
    NSDictionary* rowDictionary = [arr objectAtIndex:indexPath.row];
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        NSArray* topLevelObjects;
        topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
        
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    cell.titleLbl.text = rowDictionary[@"Title"];
    [cell.menuImg setImage:[UIImage imageNamed:rowDictionary[@"Type"]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUserForm"])   //parameter to login page
    {
        TimeLineViewController* vc = segue.destinationViewController;
        vc.formObj = self.formObj;
    }
}


@end
