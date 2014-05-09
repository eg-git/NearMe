//
//  ListViewController.m
//  NearMe
//
//  Created by Erica Giordo on 4/15/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import "ListViewController.h"
#import "RestaurantListCell.h"
#import "Restaurant.h"
#import "ViewController.h"

@interface ListViewController() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *emptyListLabel;
@property (nonatomic, strong) ViewController *viewController;

@end

@implementation ListViewController

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if ([parent isKindOfClass:[ViewController class]])
        self.viewController = (ViewController *)parent;
    else
        @throw [NSException exceptionWithName:self.class.description reason:@"Wrong parent to setup the map!" userInfo:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self updateList];
}

#pragma mark - UICollectionViewDelegate methods
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RestaurantListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RestaurantCell" forIndexPath:indexPath];
    Restaurant *restaurant = (Restaurant *)(self.viewController.restaurantsList[indexPath.row]);
    cell.nameLabel.text = restaurant.name;
    cell.addressLabel.text = restaurant.address;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewController.restaurantsList.count;
}

#pragma mark - API interaction methods
- (void)updateList{
    self.emptyListLabel.hidden = self.viewController.restaurantsList.count;
    [self.collectionView reloadData];
}

@end
