//
//  CustomPGDatePickerManager.m
//  Demo
//
//  Created by Sjw on 2019/3/6.
//  Copyright © 2019年 piggybear. All rights reserved.
//

#import "CustomPGDatePickerManager.h"
#import "CustomPGDatePickManagerHeaderView.h"
#import "CustomPGDatePickManagerIntervalTimeHeaderView.h"

@interface CustomPGDatePickerManager ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) PGDatePickManagerHeaderView *headerView;
@property (nonatomic, weak) CustomPGDatePickManagerIntervalTimeHeaderView *intervalTimeHeaderView;
@property (nonatomic, weak) UIView *dismissView;
//0:开始时间,1:结束时间
@property (nonatomic, assign) NSInteger selectTag;

@end

@implementation CustomPGDatePickerManager

- (void)dealloc {
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.selectTag = -1;
        
        [self setupDismissViewTapHandler];
        [self headerViewButtonHandler];
        
        [self.datePicker addObserver:self
                     forKeyPath:@"datePickerMode"
                        options: NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                        context:nil];
    }
    return self;
}

// 所观察的对象的keyPath 发生改变的时候, 会触发
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"datePickerMode"]) {
        self.intervalTimeHeaderView.datePickerMode = self.datePicker.datePickerMode;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.headerView.language = self.datePicker.language;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.headerView.style = self.style;
    self.dismissView.frame = self.view.bounds;
    self.contentView.backgroundColor = self.datePicker.backgroundColor;
     [self setupStyleSheet];
    [self.view bringSubviewToFront:self.contentView];
}

- (void)setupDismissViewTapHandler {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissViewTapMonitor)];
    [self.dismissView addGestureRecognizer:tap];
}

- (void)headerViewButtonHandler {
    __weak id weak_self = self;
    self.headerView.cancelButtonHandlerBlock = ^(UIButton *button) {
        __strong CustomPGDatePickerManager *strong_self = weak_self;
        [strong_self cancelButtonHandler];
        if (strong_self.cancelButtonMonitor) {
            strong_self.cancelButtonMonitor();
        }
    };
    self.headerView.confirmButtonHandlerBlock =^ (UIButton *button) {
        __strong CustomPGDatePickerManager *strong_self = weak_self;
        [strong_self cancelButtonHandler];
        
        if (strong_self.finishIntervalTimeBlock) {
            strong_self.finishIntervalTimeBlock(strong_self.intervalTimeHeaderView.strStartTime,strong_self.intervalTimeHeaderView.strEndTime);
        }
    };
}

- (void)cancelButtonHandler {
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.y = self.view.bounds.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentView.frame = contentViewFrame;
    }completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:false completion:nil];
    }];
}

- (void)dismissViewTapMonitor {
    [self cancelButtonHandler];
    if (self.cancelButtonMonitor) {
        self.cancelButtonMonitor();
    }
}

- (void)setupStyleSheet {
    CGFloat bottom = 0;
    if (@available(iOS 11.0, *)) {
        bottom = self.view.safeAreaInsets.bottom;
    }
    
    CGFloat rowHeight = self.datePicker.rowHeight;
    CGFloat headerViewHeight = self.headerHeight;
    CGFloat intervalHeaderViewHeight = self.headerHeight + 10;
    CGFloat contentViewHeight = rowHeight * 5 + headerViewHeight + intervalHeaderViewHeight;
    CGFloat datePickerHeight = contentViewHeight - headerViewHeight - intervalHeaderViewHeight - bottom;
    CGRect contentViewFrame = CGRectMake(0,
                                         self.view.bounds.size.height - contentViewHeight,
                                         self.view.bounds.size.width,
                                         contentViewHeight);
    CGRect headerViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, headerViewHeight);
    CGRect intervalHeaderViewFrame = CGRectMake(0, CGRectGetMaxY(headerViewFrame), self.view.bounds.size.width, intervalHeaderViewHeight);
    
    CGRect datePickerFrame = CGRectMake(0,
                                        CGRectGetMaxY(intervalHeaderViewFrame),
                                        self.view.bounds.size.width,
                                        datePickerHeight);
    
    self.contentView.frame = CGRectMake(0,
                                        self.view.bounds.size.height,
                                        self.view.bounds.size.width,
                                        contentViewHeight);
    self.headerView.frame = headerViewFrame;
    self.intervalTimeHeaderView.frame = intervalHeaderViewFrame;
    self.datePicker.frame = datePickerFrame;
    self.headerView.backgroundColor = self.headerViewBackgroundColor;
    self.intervalTimeHeaderView.backgroundColor = self.headerViewBackgroundColor;
    [UIView animateWithDuration:0.2 animations:^{
        if (self.isShadeBackgroud) {
            self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        }
        self.contentView.frame = contentViewFrame;
        self.headerView.frame = headerViewFrame;
        self.intervalTimeHeaderView.frame = intervalHeaderViewFrame;
        self.datePicker.frame = datePickerFrame;
    }];
}

#pragma Setter

- (void)setIsShadeBackgroud:(BOOL)isShadeBackgroud {
    _isShadeBackgroud = isShadeBackgroud;
    if (isShadeBackgroud) {
        self.dismissView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }else {
        self.dismissView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setCancelButtonFont:(UIFont *)cancelButtonFont {
    _cancelButtonFont = cancelButtonFont;
    self.headerView.cancelButtonFont = cancelButtonFont;
}

- (void)setCancelButtonText:(NSString *)cancelButtonText {
    _cancelButtonText = cancelButtonText;
    self.headerView.cancelButtonText = cancelButtonText;
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
    _cancelButtonTextColor = cancelButtonTextColor;
    self.headerView.cancelButtonTextColor = cancelButtonTextColor;
}

- (void)setConfirmButtonFont:(UIFont *)confirmButtonFont {
    _confirmButtonFont = confirmButtonFont;
    self.headerView.confirmButtonFont = confirmButtonFont;
}

- (void)setConfirmButtonText:(NSString *)confirmButtonText {
    _confirmButtonText = confirmButtonText;
    self.headerView.confirmButtonText = confirmButtonText;
}

- (void)setConfirmButtonTextColor:(UIColor *)confirmButtonTextColor {
    _confirmButtonTextColor = confirmButtonTextColor;
    self.headerView.confirmButtonTextColor = confirmButtonTextColor;
}

#pragma Getter

- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _contentView =view;
    }
    return _contentView;
}

- (PGDatePicker *)datePicker {
    if (!_datePicker) {
        PGDatePicker *datePicker = [[PGDatePicker alloc]init];
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.delegate = self;
        datePicker.autoSelected = YES;
        [self.contentView addSubview:datePicker];
        _datePicker = datePicker;
    }
    return _datePicker;
}

- (PGDatePickManagerHeaderView *)headerView {
    if (!_headerView) {
        PGDatePickManagerHeaderView *view = [[PGDatePickManagerHeaderView alloc]init];
        [self.contentView addSubview:view];
        _headerView = view;
    }
    return _headerView;
}

- (CustomPGDatePickManagerIntervalTimeHeaderView *)intervalTimeHeaderView {
    if (!_intervalTimeHeaderView) {
        CustomPGDatePickManagerIntervalTimeHeaderView *view = [[CustomPGDatePickManagerIntervalTimeHeaderView alloc]init];
        [self.contentView addSubview:view];
        
        __weak id weak_self = self;
        view.intervalStartTimeBlock = ^{
            __strong CustomPGDatePickerManager *strong_self = weak_self;
            strong_self.selectTag = 0;
            
            if (strong_self.intervalTimeHeaderView.strStartTime == nil) {
                [strong_self.datePicker selectedDateLogic];
            }
        };
        
        view.intervalendTimeBlock = ^{
            __strong CustomPGDatePickerManager *strong_self = weak_self;
             strong_self.selectTag = 1;
            
            if (strong_self.intervalTimeHeaderView.strEndTime == nil) {
                [strong_self.datePicker selectedDateLogic];
            }
        };
        
        _intervalTimeHeaderView = view;
    }
    return _intervalTimeHeaderView;
}

- (UIColor *)headerViewBackgroundColor {
    if (!_headerViewBackgroundColor) {
        _headerViewBackgroundColor = [UIColor pg_colorWithHexString:@"#F1EDF6"];
    }
    return _headerViewBackgroundColor;
}

- (CGFloat)headerHeight {
    if (!_headerHeight) {
        _headerHeight = 50;
    }
    return _headerHeight;
}

- (UIView *)dismissView {
    if (!_dismissView) {
        UIView *view = [[UIView alloc]init];
        [self.view addSubview:view];
        _dismissView = view;
    }
    return _dismissView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = self.headerView.titleLabel;
    }
    return _titleLabel;
}

#pragma mark - PGDatePickerDelegate

- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    if (_selectTag == -1) {
        return;
    }
    
    NSString *strTime = @"";
    NSString *strShowTime = @"";
    NSInteger precise = 1;
    BOOL flag = NO;
    
    if (datePicker.datePickerMode == PGDatePickerModeYear) {
        strTime = [NSString stringWithFormat:@"%04ld",(long)dateComponents.year];
        strShowTime = strTime;
        precise = 1;
    }
    else if(datePicker.datePickerMode == PGDatePickerModeYearAndMonth) {
        strTime = [NSString stringWithFormat:@"%04ld%02ld",(long)dateComponents.year,(long)dateComponents.month];
        strShowTime = [NSString stringWithFormat:@"%04ld-%02ld",(long)dateComponents.year,(long)dateComponents.month];
        precise = 2;
    }
    else if(datePicker.datePickerMode == PGDatePickerModeDate) {
        strTime = [NSString stringWithFormat:@"%04ld%02ld%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
        strShowTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day];
        precise = 3;
    }
    else if(datePicker.datePickerMode == PGDatePickerModeDateHour) {
        strTime = [NSString stringWithFormat:@"%04ld%02ld%02ld%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour];
        strShowTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour];
        precise = 4;
    }
    else if(datePicker.datePickerMode == PGDatePickerModeDateHourMinute) {
        strTime = [NSString stringWithFormat:@"%04ld%02ld%02ld%02ld%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute];
        strShowTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute];
        precise = 5;
    }
    else if(datePicker.datePickerMode == PGDatePickerModeDateHourMinuteSecond) {
        strTime = [NSString stringWithFormat:@"%04ld%02ld%02ld%02ld%02ld%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute,(long)dateComponents.second];
        strShowTime = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)dateComponents.year,(long)dateComponents.month,(long)dateComponents.day,(long)dateComponents.hour,(long)dateComponents.minute,(long)dateComponents.second];
        precise = 6;
    }
    else if(datePicker.datePickerMode == PGDatePickerModeTime) {
        flag = YES;
        if(datePicker.isOnlyHourFlag) {
            strTime = [NSString stringWithFormat:@"%02ld",(long)dateComponents.hour];
            strShowTime = strTime;
            precise = 1;
        }
        else {
            strTime = [NSString stringWithFormat:@"%02ld%02ld",(long)dateComponents.hour,(long)dateComponents.minute];
            strShowTime = [NSString stringWithFormat:@"%02ld:%02ld",(long)dateComponents.hour,(long)dateComponents.minute];
            precise = 2;
        }
    }
    else if(datePicker.datePickerMode == PGDatePickerModeTimeAndSecond) {
        flag = YES;
        strTime = [NSString stringWithFormat:@"%02ld%02ld%02ld",(long)dateComponents.hour,(long)dateComponents.minute,(long)dateComponents.second];
        strShowTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)dateComponents.hour,(long)dateComponents.minute,(long)dateComponents.second];
        precise = 3;
    }
    
    [_intervalTimeHeaderView handleTimeValue:strShowTime];

}

@end
