//
//  CustomPGDatePickManagerIntervalTimeHeaderView.h
//  Demo
//
//  Created by Sjw on 2019/3/6.
//  Copyright © 2019年 piggybear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDatePicker.h"

typedef void(^PGIntervalStartTimeBlock)(void);
typedef void(^PGIntervalendTimeBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CustomPGDatePickManagerIntervalTimeHeaderView : UIView

@property (assign, nonatomic) PGDatePickerMode datePickerMode;

//0:开始时间,1:结束时间
@property (nonatomic, assign) NSInteger selectTag;

//开始时间
@property (strong, nonatomic) UIButton *startTimeButton;
@property (strong, nonatomic) UIView *startTimeLineView;
//结束时间
@property (strong, nonatomic) UIButton *endTimeButton;
@property (strong, nonatomic) UIView *endTimeLineView;

@property (copy, nonatomic) PGIntervalStartTimeBlock intervalStartTimeBlock;
@property (copy, nonatomic) PGIntervalendTimeBlock intervalendTimeBlock;

@property (readonly, strong, nonatomic) NSString *strStartTime;
@property (readonly, strong, nonatomic) NSString *strEndTime;

//
- (void)handleTimeValue:(NSString *)strTime;

@end

NS_ASSUME_NONNULL_END
