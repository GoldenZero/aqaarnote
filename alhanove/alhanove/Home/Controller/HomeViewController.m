//
//  HomeViewController.m
//  alhanove
//
//  Created by GALMarei on 5/20/14.
//  Copyright (c) 2014 Danat. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    NSMutableArray* listMenu;
}
@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //get the data for the menu
    [self getListMenuData];
    
    //reflect to the table
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
-(void)getListMenuData
{
    listMenu = [NSMutableArray new];
    NSDictionary *MenuDict = @{@"Title" : @"حج",
                             @"Image" : @"badge1"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"عمرة",
                               @"Image" : @"badge2"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"طيران",
                               @"Image" : @"badge3"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"فنادق",
                               @"Image" : @"badge4"};
    [listMenu addObject:MenuDict];
    
    MenuDict = nil;
    MenuDict = @{@"Title" : @"سيارات",
                               @"Image" : @"badge5"};
    [listMenu addObject:MenuDict];
    
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listMenu count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    NSDictionary* dictionary = [listMenu objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = dictionary[@"Title"];
    [cell.imageView setImage:[UIImage imageNamed:dictionary[@"Image"]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
