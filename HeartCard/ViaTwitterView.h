//
//  ViaTwitterView.h
//  HeartCard
//
//  Created by Iphone_2 on 18/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@class GlobalViewController;

@interface ViaTwitterView : GlobalViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    @public NSMutableArray *TwitterFriendArray;
    NSString *UniqueCardId, *ParamChooseMsg, *ParamCustomMsg, *ParamSenderName;
    NSData *ParamUploadedImage;
}

@property(nonatomic, retain) NSString *UniqueCardId;
@property(nonatomic, retain) NSString *ParamChooseMsg;
@property(nonatomic, retain) NSString *ParamSenderName;
@property(nonatomic, retain) NSString *ParamCustomMsg;
@property(nonatomic, retain) NSData *ParamUploadedImage;

@property (strong, nonatomic) IBOutlet UIView *ScreenViewTwit;
@property(nonatomic, retain)NSMutableArray *TwitterFriendArray;
@property (strong, nonatomic) IBOutlet UITableView *TblTwitter;
@property (nonatomic,retain) ACAccountStore *accountStore;

@end
