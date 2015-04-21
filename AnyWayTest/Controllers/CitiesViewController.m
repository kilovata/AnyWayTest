//
//  CitiesViewController.m
//  AnyWayTest
//
//  Created by Sveta Kilovata on 17/04/15.
//  Copyright (c) 2015 kilovata. All rights reserved.
//

#import "CitiesViewController.h"
#import "CityModel.h"

@interface CitiesViewController ()<CityModelDelegate> {
    BOOL isArrive;
}

@property (strong, nonatomic) NSArray *array;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (strong, nonatomic) CityModel *cityModel;

@end


@implementation CitiesViewController


- (id)initWithArrive:(BOOL)isArriveValue {
    
    if (self = [super init]) {
        
        isArrive = isArriveValue;
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.cityModel = [CityModel new];
    self.cityModel.delegate = self;
    
    if (isArrive) {
        self.search.placeholder = @"Введите пункт назначения";
    } else {
        self.search.placeholder = @"Введите пункт отправления";
    }
}


- (void)delaySearchCities {
    
    if (self.search.text.length > 1) {
        [self.cityModel getCitiesWithText:self.search.text];
    } else {
        self.array = [NSArray new];
    }
    [self.table reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.array[indexPath.row] objectForKey:@"City"];
    cell.detailTextLabel.text = [self.array[indexPath.row] objectForKey:@"Country"];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnCity:andCountry:andArrive:andCityCode:)]) {
        [self.delegate returnCity:cell.textLabel.text andCountry:cell.detailTextLabel.text andArrive:isArrive andCityCode:[self.array[indexPath.row] objectForKey:@"CityCode"]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if (!searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:YES animated:YES];
    }
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    if (searchBar.showsCancelButton) {
        [searchBar setShowsCancelButton:NO animated:YES];
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delaySearchCities) object:nil];
    [self performSelector:@selector(delaySearchCities) withObject:nil afterDelay:0.3f];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar.isFirstResponder) {
        [searchBar resignFirstResponder];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delaySearchCities) object:nil];
    if (searchBar.isFirstResponder) {
        [searchBar resignFirstResponder];
    }
    searchBar.text = @"";
}


#pragma mark - CityModelDelegate
- (void)citiesGetReceived:(NSArray*)array {
    
    self.array = array;
    [self.table reloadData];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
