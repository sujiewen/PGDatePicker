//
//  CustomPGDatePickerManager.h
//  Demo
//
//  Created by Sjw on 2019/3/6.
//  Copyright © 2019年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDatePicker.h"
#import "PGEnumeration.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPGDatePickerManager : UIViewController <PGDatePickerDelegate>

@property (nonatomic, weak) PGDatePicker *datePicker;
@property (nonatomic, assign) PGDatePickManagerStyle style;
@property (nonatomic, assign) BOOL isShadeBackgroud;

@property (nonatomic, copy) NSString *cancelButtonText;
@property (nonatomic, copy) UIFont *cancelButtonFont;
@property (nonatomic, copy) UIColor *cancelButtonTextColor;

/**
 set confirmButton title ,default is Sure
 */
@property (nonatomic, copy) NSString *confirmButtonText;

@property (nonatomic, copy) UIFont *confirmButtonFont;
/**
 set confirButton titleColor ,default is
 */
@property (nonatomic, copy) UIColor *confirmButtonTextColor;

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong)UIColor *headerViewBackgroundColor;
@property (nonatomic, assign) CGFloat headerHeight;

/**
 
 */
@property (nonatomic, assign) BOOL isShowUnit;
@property (nonatomic, copy)  void(^cancelButtonMonitor)();
@property (nonatomic, copy) void (^finishIntervalTimeBlock)(NSString *strStartTime, NSString *strEndTime);

@end

NS_ASSUME_NONNULL_END
