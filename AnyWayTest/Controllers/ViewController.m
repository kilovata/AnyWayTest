//
//  ViewController.m
//  AnyWayTest
//
//  Created by Sveta Kilovata on 16/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "ViewController.h"
#import "MainCell.h"

@interface ViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (strong, nonatomic) NSArray *arrayInitItems;

@end


@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.arrayInitItems = @[@"Пункт отправления", @"Пункт назначения", @"Дата перелёта", @"Число взрослых пассажиров", @"Класс перелёта"];
    [self.table registerNib:[UINib nibWithNibName:@"MainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MainCell"];
    self.table.tableFooterView = [UIView new];
    
    self.buttonSearch.layer.borderWidth = 1.f;
    self.buttonSearch.layer.cornerRadius = 4.f;
    self.buttonSearch.layer.borderColor = [UIColor colorWithRed:0 green:122.f/255.f blue:1.f alpha:1.f].CGColor;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayInitItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    cell.labelTitle.text = self.arrayInitItems[indexPath.row];
    return cell;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
