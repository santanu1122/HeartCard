//
//  GlobalViewController.h
//  HeartCard
//
//  Created by Iphone_2 on 13/07/13.
//  Copyright (c) 2013 esolz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageProcessor.h"

@class ImageProcessor;

@interface GlobalViewController : ImageProcessor
{
    @public UIButton *FavButton, *BtnSendCard;
}

@property (nonatomic, retain) UIButton *BtnSendCard;
@property (nonatomic, retain) UIButton *FavButton;
@property (nonatomic, assign) float HeaderSize;

-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle;

-(void)AddTopBarWithOutButtonToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle;

-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle WithFavIcon:(BOOL)NeedFavButton;

-(void)AddTopBarToScreenView:(UIView *)ScreenView withTitle:(NSString *)TopTitle withBackButton:(BOOL)NeedBackButton;


-(void)AddButtonBarToScreenView:(UIView *)ScreenView;

-(void)AddButtonBarToPersonalizeView:(UIView *)ScreenView;

-(void)AddButtonBarToPreviewView:(UIView *)ScreenView fromTop:(float)top;

-(void)AddbuttonBarToSend:(UIView *)ScreenView;

-(void)AddButtonBarToSwipe:(UIView *)ScreenView withStep:(int)step withIsFav:(bool)IsFav;




-(void)SetBackground :(UIView *)VictimView;

-(void)SetBackground:(UIView *)VictimView :(NSString *)ImageName;

-(void)PerformGoBackTo: (NSString *)HereWeGo : (BOOL) Animation;

-(void)PerformGoBackTo: (NSString *)HereWeGo;

-(void)PerformGoBack;

-(void)AddMesssageSeperator:(UIView *)ParentView fromTop :(float)top;

-(void)SetFontToLabel :(UILabel *)VictimLbl withSize:(float)size;
-(void)SetFontToLabels :(NSArray *)LblArray withSize:(float)size;
-(void)SetFontToTextField :(UITextField *)VictimField withSize:(float)size;

-(void)SetFonttoFields:(NSArray *)FieldSet withSize:(float)size;

-(void)SetFonttoFields:(NSArray *)FieldSet withSize:(float)size withBorderToFields:(BOOL)needBorder;

-(void)SetBorderTo:(NSArray *)FieldSet;

-(void)SetBorderToField:(UIView *)TxtField;

-(NSString *)LocalDate;

-(UIImage *)TakeASnapShotOf:(UIView *)FamousView;

-(void)RemoveAllGestureFrom:(UIView *)ScreenView;

@end
