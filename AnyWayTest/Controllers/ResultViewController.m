//
//  ResultViewController.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 21/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "ResultViewController.h"
#import "ResultCell.h"
#import "DataSource.h"
#import "ResultModel.h"
#import "Fare.h"
#import "Airline.h"
#import "DetailViewController.h"

@interface ResultViewController () {
    
    BOOL showDetails;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) DataSource *dataSource;
@property (strong, nonatomic) ResultModel *resultModel;
@property (strong, nonatomic) NSArray *arrayFares;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end


@implementation ResultViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    showDetails = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.title = @"Самые дешевые тарифы";
    self.dataSource = [DataSource new];
    self.resultModel = [ResultModel new];
    [self.dataSource setupFetchResultsControllerWithRequest:[self.resultModel getRequestAirlines]];
    [self.table registerNib:[UINib nibWithNibName:@"ResultCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ResultCell"];
    self.table.tableFooterView = [UIView new];
}


- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.selectedIndexPath) {
        [self.table deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
        self.selectedIndexPath = nil;
    }
}


- (void)viewDidDisappear:(BOOL)animated {
    
    if (!showDetails) {
        [self.resultModel truncateAll];
    }
    [super viewDidDisappear:animated];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.dataSource.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Airline *airline = (Airline*)[self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell" forIndexPath:indexPath];
    NSString *fullName = [self.resultModel getNameAirlaneByCode:airline.code];
    if (fullName) {
        cell.labelAirline.text = fullName;
    } else {
        cell.labelAirline.text = airline.code;
    }
    Fare *fare = [self.resultModel getMinFareAmountForAirline:airline];
    cell.labelPrice.text = [NSString stringWithFormat:@"от %@ руб.", fare.totalAmount];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndexPath = indexPath;
    showDetails = YES;
    Airline *airline = (Airline*)[self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *fullName = [self.resultModel getNameAirlaneByCode:airline.code];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithAirline:airline andTitle:fullName];
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
