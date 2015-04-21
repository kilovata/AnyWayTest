//
//  CalendarViewController.m
//  AnyWayTest
//
//  Created by kilovata-iMac on 17/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "CalendarViewController.h"
#import "RSDFDatePickerView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface CalendarViewController ()<RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource>

@end


@implementation CalendarViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    RSDFDatePickerView *datePickerView = [[RSDFDatePickerView alloc] initWithFrame:self.view.bounds];
    datePickerView.delegate = self;
    datePickerView.dataSource = self;
    if (self.dateSelected) {
        [datePickerView selectDate:self.dateSelected];
    }
    [self.view addSubview:datePickerView];
}


- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldSelectDate:(NSDate *)date {
    
    NSDate *today = [NSDate date];
    if ([date compare:today] == NSOrderedAscending) {
        [view scrollToToday:YES];
        [SVProgressHUD showErrorWithStatus:@"Все самолеты на эту дату уже вылетели"];
        return NO;
    } else {
        
        NSDate *afterYear = [today dateByAddingTimeInterval:86400*365];
        if ([date compare:afterYear] == NSOrderedDescending) {
            [view scrollToToday:YES];
            [SVProgressHUD showErrorWithStatus:@"Выберите дату меньше, чем на год от текущей"];
            return NO;
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getDateFomCalendar:)]) {
                [self.delegate getDateFomCalendar:date];
            }
            return YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
