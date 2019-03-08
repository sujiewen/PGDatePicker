//
//  CustomPGDatePickManagerIntervalTimeHeaderView.m
//  Demo
//
//  Created by Sjw on 2019/3/6.
//  Copyright © 2019年 piggybear. All rights reserved.
//

#import "CustomPGDatePickManagerIntervalTimeHeaderView.h"
#import "UIColor+PGHex.h"

#define PG_SeparationLine_Width 15

@interface CustomPGDatePickManagerIntervalTimeHeaderView ()

@property (strong, nonatomic) UIView *topLineView;
@property (strong, nonatomic) UIImageView *separationLineView;
@property (nonatomic, assign) BOOL isSubViewLayouted;

@property (strong, nonatomic) NSString *strStartTime;
@property (strong, nonatomic) NSString *strEndTime;


@end

@implementation CustomPGDatePickManagerIntervalTimeHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemWidth = 90;
        self.selectTag = -1;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemWidth = 90;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isSubViewLayouted) {
        return;
    }
    
    self.isSubViewLayouted = true;
    [self setupView];
    
    [self setyle];
}


- (void)setupView {
    
    _topLineView = [[UIView alloc] init];
    [_topLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#9EABBE"]];
    [self addSubview:_topLineView];
    
    _startTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startTimeButton setTitleColor:[UIColor pg_colorWithHexString:@"#D7DAE6"] forState:UIControlStateNormal];
    [_startTimeButton setTitleColor:[UIColor pg_colorWithHexString:@"#7396FD"] forState:UIControlStateSelected];
    [_startTimeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_startTimeButton addTarget:self action:@selector(startTimeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_startTimeButton setTitle:@"开始日期" forState:UIControlStateNormal];
    [self addSubview:_startTimeButton];

    _startTimeLineView = [[UIView alloc] init];
    [_startTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
    [self addSubview:_startTimeLineView];
    
    _separationLineView = [[UIImageView alloc] init];
    [_separationLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#9EABBE"]];
    [self addSubview:_separationLineView];
    
    _endTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_endTimeButton setTitleColor:[UIColor pg_colorWithHexString:@"#D7DAE6"] forState:UIControlStateNormal];
    [_endTimeButton setTitleColor:[UIColor pg_colorWithHexString:@"#7396FD"] forState:UIControlStateSelected];
    [_endTimeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_endTimeButton addTarget:self action:@selector(endTimeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_endTimeButton setTitle:@"结束日期" forState:UIControlStateNormal];
    [self addSubview:_endTimeButton];

    _endTimeLineView = [[UIView alloc] init];
    [_endTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
    [self addSubview:_endTimeLineView];
}

- (void)setyle {
    if (_datePickerMode == PGDatePickerModeDateHour || _datePickerMode == PGDatePickerModeDateHourMinute || _datePickerMode == PGDatePickerModeDateHourMinuteSecond || _datePickerMode == PGDatePickerModeMonthDayHourMinute || _datePickerMode == PGDatePickerModeMonthDayHourMinute || _datePickerMode == PGDatePickerModeMonthDayHourMinuteSecond || _datePickerMode == PGDatePickerModeDateAndTime) {
        if (self.itemWidth < 150) {
            self.itemWidth = 150;
        }
    }
    else {
        if (self.itemWidth < 90) {
            self.itemWidth = 90;
        }
    }
    
    _topLineView.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    
    _startTimeButton.frame = CGRectMake(((self.frame.size.width - PG_SeparationLine_Width)/2.0 - self.itemWidth)/2.0, (self.frame.size.height - 20)/2.0, self.itemWidth, 20);
    
    _startTimeLineView.frame = CGRectMake(_startTimeButton.frame.origin.x, CGRectGetMaxY(_startTimeButton.frame)+5, _startTimeButton.frame.size.width, 1);
    
    _separationLineView.frame = CGRectMake((self.frame.size.width - PG_SeparationLine_Width)/2.0, (self.frame.size.height - 1)/2.0, PG_SeparationLine_Width, 1);
    
    _endTimeButton.frame = CGRectMake((self.frame.size.width - PG_SeparationLine_Width)/2.0+((self.frame.size.width- PG_SeparationLine_Width)/2.0 - self.itemWidth)/2.0, (self.frame.size.height - 20)/2.0, self.itemWidth, 20);
    
    _endTimeLineView.frame = CGRectMake(_endTimeButton.frame.origin.x, CGRectGetMaxY(_endTimeButton.frame)+5, _endTimeButton.bounds.size.width, 1);
}

- (void)startTimeBtnAction {
    self.selectTag = 0;
    self.startTimeButton.selected = YES;
    self.endTimeButton.selected = NO;
    
    [_startTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#7396FD"]];
    [_endTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
    
    if (_intervalStartTimeBlock) {
        _intervalStartTimeBlock();
    }
}

- (void)endTimeBtnAction {
    self.selectTag = 1;
    self.startTimeButton.selected = NO;
    self.endTimeButton.selected = YES;
    
    [_startTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
    [_endTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#7396FD"]];
    
    if (_intervalendTimeBlock) {
        _intervalendTimeBlock();
    }
}

- (void)setDatePickerMode:(PGDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    [self setyle];
}

- (void)handleTimeValue:(NSString *)strTime {
    if (self.selectTag == 0) {
        _strStartTime = strTime;
        [_startTimeButton setTitle:strTime forState:UIControlStateNormal];
    }
    else if(self.selectTag == 1) {
        _strEndTime = strTime;
        [_endTimeButton setTitle:strTime forState:UIControlStateNormal];
    }
    else {
        _strStartTime = nil;
        _strEndTime = nil;
        
        [_startTimeButton setTitle:@"开始日期" forState:UIControlStateNormal];
        [_endTimeButton setTitle:@"结束日期" forState:UIControlStateNormal];
    }
}

- (void)setSelectTag:(NSInteger)selectTag {
    _selectTag = selectTag;
    
    if (_selectTag == 0) {
        self.startTimeButton.selected = YES;
        self.endTimeButton.selected = NO;
        
        [_startTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#7396FD"]];
        [_endTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
    }
    else if(_selectTag == 1){
        self.startTimeButton.selected = NO;
        self.endTimeButton.selected = YES;
        
        [_startTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
        [_endTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#7396FD"]];
    }
    else {
        self.startTimeButton.selected = NO;
        self.endTimeButton.selected = NO;
        
        [_startTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
        [_endTimeLineView setBackgroundColor:[UIColor pg_colorWithHexString:@"#D7DAE6"]];
        
        _strStartTime = nil;
        _strEndTime = nil;
        
        [_startTimeButton setTitle:@"开始日期" forState:UIControlStateNormal];
        [_endTimeButton setTitle:@"结束日期" forState:UIControlStateNormal];
    }
}

@end
