//
//  ViewController.m
//  AnyWayTest
//
//  Created by Sveta Kilovata on 16/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "ViewController.h"
#import "MainCell.h"
#import "CitiesViewController.h"
#import "CalendarViewController.h"

@interface ViewController ()<CitiesViewControllerDelegate, CalendarViewControllerDelegate, MainCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (strong, nonatomic) NSArray *arrayInitItems;
@property (strong, nonatomic) NSMutableArray *arrayItems;

@end


@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"anywayanyday";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.arrayInitItems = @[@"Пункт отправления", @"Пункт назначения", @"Дата перелёта", @"1 пассажир", @"Эконом"];
    self.arrayItems = [NSMutableArray arrayWithArray:self.arrayInitItems];
    [self.table registerNib:[UINib nibWithNibName:@"MainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MainCell"];
    self.table.tableFooterView = [UIView new];
    
    self.buttonSearch.layer.borderWidth = 1.f;
    self.buttonSearch.layer.cornerRadius = 4.f;
    self.buttonSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


- (void)goBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSString*)wordFormWithCount:(NSInteger)count {
    
    NSString *form1 = @"пассажир";
    NSString *form2 = @"пассажира";
    NSString *form5 = @"пассажиров";
    
    count = count % 100;
    NSInteger count1 = count % 10;
    if (count > 10 && count < 20) return form5;
    else if (count1 > 1 && count1 < 5) return form2;
    else if (count1 == 1) return form1;
    return form5;
}


- (BOOL)isEnableSearch {
    
    BOOL value = NO;
    for(int i = 0;i<[self.arrayItems count];i++) {
        
        for(int j= 0;j<[self.arrayInitItems count];j++) {
            
            if([[self.arrayItems objectAtIndex:i] isEqualToString:[self.arrayInitItems objectAtIndex:j]]) {
                
                self.buttonSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
                return NO;
            }  else {
                value = YES;
            }
        }
    }
    if (value) {
        self.buttonSearch.layer.borderColor = [UIColor colorWithRed:0 green:122.f/255.f blue:1.f alpha:1.f].CGColor;
    } else {
        self.buttonSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return value;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayInitItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    cell.delegate = self;
    cell.labelTitle.text = self.arrayItems[indexPath.row];
    if (indexPath.row == 3) {
        cell.labelTitle.hidden = YES;
        cell.labelPassengers.hidden = NO;
        cell.stepper.hidden = NO;
        cell.labelPassengers.text = self.arrayItems[indexPath.row];
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CitiesViewController *citiesVC = [[CitiesViewController alloc] initWithArrive:NO];
        citiesVC.delegate = self;
        [self.navigationController pushViewController:citiesVC animated:YES];
    } else if (indexPath.row == 1) {
        CitiesViewController *citiesVC = [[CitiesViewController alloc] initWithArrive:YES];
        citiesVC.delegate = self;
        [self.navigationController pushViewController:citiesVC animated:YES];
    } else if (indexPath.row == 2) {
        CalendarViewController *calendarVC = [CalendarViewController new];
        calendarVC.delegate = self;
        [self.navigationController pushViewController:calendarVC animated:YES];
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        if ([[self.arrayItems objectAtIndex:4] isEqualToString:@"Эконом"]) {
            [self.arrayItems replaceObjectAtIndex:4 withObject:@"Бизнес"];
        } else {
            [self.arrayItems replaceObjectAtIndex:4 withObject:@"Эконом"];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - CitiesViewControllerDelegate
- (void)returnCity:(NSString*)strCity andCountry:(NSString*)strCountry andArrive:(BOOL)isArrive {
    
    if (isArrive) {
        [self.arrayItems replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@, %@", strCity, strCountry]];
    } else {
        [self.arrayItems replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@, %@", strCity, strCountry]];
    }
    
    [self.table reloadData];
    self.buttonSearch.enabled = [self isEnableSearch];
}


#pragma mark - CalendarViewControllerDelegate
- (void)getDateFomCalendar:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    [self.arrayItems replaceObjectAtIndex:2 withObject:[dateFormatter stringFromDate:date]];
    [self.table reloadData];
}


#pragma mark - MainCellDelegate
- (void)updatePeopleCount:(NSInteger)peopleCount {
    
    NSString *strPeopleForm = [self wordFormWithCount:peopleCount];
    NSString *strFull = [NSString stringWithFormat:@"%li %@", (long)peopleCount, strPeopleForm];
    [self.arrayItems replaceObjectAtIndex:3 withObject:strFull];
    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
