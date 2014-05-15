//
//  ViaFacebookView.h
//  HeartCard
//
//  Created by Iphone_2 on 15/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GlobalViewController;

@interface ViaFacebookView : GlobalViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UITextFieldDelegate>
{
    @public NSMutableArray *FBFriendsArray;
    NSString *UniqueCardId, *ParamChooseMsg, *ParamCustomMsg, *ParamSenderName;
    NSData *ParamUploadedImage;
}

@property(nonatomic, retain) NSString *UniqueCardId;
@property(nonatomic, retain) NSString *ParamChooseMsg;
@property(nonatomic, retain) NSString *ParamSenderName;
@property(nonatomic, retain) NSString *ParamCustomMsg;
@property(nonatomic, retain) NSData *ParamUploadedImage;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewFB;
@property(nonatomic, retain)NSMutableArray *FBFriendsArray;
@property (strong, nonatomic) IBOutlet UITableView *TblFB;

@property (strong, nonatomic) IBOutlet UITextField *TFSearch;
@property (strong, nonatomic) IBOutlet UIView *VSearchBackView;
@property (strong, nonatomic) IBOutlet UIView *SendViaFacebookView;
@property (strong, nonatomic) IBOutlet UIView *SendViaFacebookScreenView;
@end
