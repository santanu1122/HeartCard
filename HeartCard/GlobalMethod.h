//
//  GlobalMethod.h
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject
{
    NSString *Name, *Id, *UserName, *CardId, *Message1, *Message2, *ScheduledDate, *SenderName, *ReceiverName, *ReceiverPhoneNo, *Message, *Description;
    NSUInteger Tagger, Counter, Identifier;
    
    NSURL *CardImageURL, *AttachedImage;
}

@property (nonatomic, retain) NSString *Id;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSURL *ImageUrl;
@property (nonatomic, retain) UIImage *CardImage;
@property (nonatomic, retain) NSString *UserName;
@property (nonatomic, retain) NSString *CardId;
@property (nonatomic, retain) NSString *Message;
@property (nonatomic, retain) NSString *Message1;
@property (nonatomic, retain) NSString *Message2;
@property (nonatomic, retain) NSString *ScheduledDate;
@property (nonatomic, retain) NSString *SenderName;
@property (nonatomic, retain) NSString *ReceiverName;
@property (nonatomic, retain) NSString *ReceiverPhoneNo;
@property (nonatomic, retain) NSString *Description;
@property (nonatomic, retain) NSString *Credit;
@property (nonatomic, retain) NSString *CreditDate;
@property (nonatomic, retain) NSString *PackageType;
@property (nonatomic, retain) NSString *FontStyle;
@property (nonatomic, retain) NSString *FontSize;
@property (nonatomic, retain) NSString *ScheduleID;
@property (nonatomic, retain) UIColor *FontColor;
@property (nonatomic, retain) NSString *ParamCancelStatus;


@property (nonatomic, retain) NSURL *CardImageURL;
@property (nonatomic, retain) NSURL *AttachedImage;

@property (nonatomic) NSUInteger Tagger;
@property (nonatomic) NSUInteger Counter;
@property (nonatomic) NSUInteger Identifier;



-(id) initWithId:(NSString *)ParamId withName:(NSString *)ParamName;
-(id) initWithId:(NSString *)ParamId withName:(NSString *)ParamName withDescription:(NSString *)Description;

-(id) initWithId:(NSString *)ParamId withImageUrl:(NSString *) ParamUrl;

-(id) initWithId:(NSString *)ParamId withImageUrl:(NSString *) ParamUrl withCardName:(NSString *)Name withCounter:(NSUInteger)Counter;

-(NSString *) Encoder:(NSString *)str;

-(NSData *)ConvertImageToNSData:(UIImage *)image;

-(NSURL *)ConvertStringToNSUrl:(NSString *)String;

-(NSString *)ConvertNSDataToNSString:(NSData *)data;



-(id)initWithId:(NSString *)Id withName:(NSString *) Name withImageUrl:(NSString *)ImageUrl  withUserName:(NSString *)UserName;

-(id)initWithId:(NSString *)Id withName:(NSString *) Name withImageUrl:(NSURL *)ImageUrl withIdentifier:(NSUInteger) Idendifier withUserName:(NSString *)UserName;

-(id)initWithId:(NSString *)Id withCredit:(NSString *)Credit withCreditDate :(NSString *)CreditDate withPackageType :(NSString *)PackageType;


-(id)initWithId:(NSString *)CardId withMessage1:(NSString *)Message1 withMessage2:(NSString *)Message2 withDate:(NSString *)ScheduledDate withCardImage:(NSString *)CardImage withAttachedImage:(NSString *)AttachedImage withSenderName:(NSString *)SenderName withReceiverName:(NSString *)ReceiverName withReceiverPhoneNo:(NSString *)ReceiverPhoneNo withScheduleID:(NSString *)ScheduleID  withCancelStatus:(NSString *)ParamCancelStatus;

@end


@interface UpdateUserAppaccessCount : NSObject {
    UIView *ViewOne;
    UIView *MyView;
}

-(void)GetUserVisitcounter:(NSString *)DeviceToken;

@end
