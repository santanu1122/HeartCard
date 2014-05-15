//
//  CategoryView.h
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface CategoryView : GlobalViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSMutableArray *CategoryArray;
}

@property (strong, nonatomic) IBOutlet UIView *ScreenViewCategory;
@property (nonatomic, retain) IBOutlet UITableView *categoryTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *Spinner;

@property (strong, nonatomic) IBOutlet UIView *BackView;

@property(nonatomic, retain) NSMutableArray *CategoryArray;

@end
