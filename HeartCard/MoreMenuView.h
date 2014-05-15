//
//  MoreMenuView.h
//  HeartCard
//
//  Created by Iphone_2 on 10/09/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GlobalViewController;
@interface MoreMenuView : GlobalViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *ScreenViewCategory;
@property (nonatomic, retain) IBOutlet UITableView *optionsTable;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *Spinner;

@property (strong, nonatomic) IBOutlet UIView *BackView;


@end
