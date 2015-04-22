//
//  DetailViewController.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 22/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "DetailViewController.h"
#import "Airline.h"
#import "Fare.h"
#import "DataSource.h"
#import "DetailModel.h"
#import "DetailCell.h"

@interface DetailViewController ()

@property (strong, nonatomic) Airline *airline;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) DataSource *dataSource;
@property (strong, nonatomic) DetailModel *detailModel;
@property (strong, nonatomic) NSString *strTitle;

@end

@implementation DetailViewController


- (id)initWithAirline:(Airline*)airline andTitle:(NSString*)strTitle {
    
    if (self = [super init]) {
        self.airline = airline;
        self.strTitle = strTitle;
        self.dataSource = [DataSource new];
        self.detailModel = [DetailModel new];
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.title = [NSString stringWithFormat:@"Тарифы %@", self.strTitle];
    
    [self.table registerNib:[UINib nibWithNibName:@"DetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DetailCell"];
    self.table.tableFooterView = [UIView new];
    [self.dataSource setupFetchResultsControllerWithRequest:[self.detailModel getRequestWithAirline:self.airline]];
}


- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.dataSource.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Fare *fare = (Fare*)[self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    cell.labelPrice.text = [NSString stringWithFormat:@"%@ руб.", fare.totalAmount];
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.f;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
