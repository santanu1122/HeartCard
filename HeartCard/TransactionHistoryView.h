//
//  TransactionHistoryView.h
//  HeartCard
//
//  Created by Iphone_2 on 25/09/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface TransactionHistoryView : GlobalViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *ScreenViewTranHistroy;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *SpinnerTranHistroy;
@property (strong, nonatomic) IBOutlet UITableView *TVTranHistroy;
@property (strong, nonatomic) IBOutlet UILabel *LblCardCredit;

@end
