//
//  CustomPGDatePickManagerHeaderView.h
//  Demo
//
//  Created by Sjw on 2019/3/6.
//  Copyright © 2019年 piggybear. All rights reserved.
//

#import "PGDatePickManagerHeaderView.h"
#import "PGEnumeration.h"

typedef void(^PGHandlerBlock)(UIButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface CustomPGDatePickManagerHeaderView : UIView

@property (nonatomic, assign) PGDatePickManagerStyle style;

@property (nonatomic, copy)  PGHandlerBlock cancelButtonHandlerBlock;
@property (nonatomic, copy)  PGHandlerBlock confirmButtonHandlerBlock;

@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, copy) NSString *language;

@property (nonatomic, copy) NSString *cancelButtonText;
@property (nonatomic, copy) UIFont *cancelButtonFont;
@property (nonatomic, copy) UIColor *cancelButtonTextColor;

@property (nonatomic, copy) NSString *confirmButtonText;
@property (nonatomic, copy) UIFont *confirmButtonFont;
@property (nonatomic, copy) UIColor *confirmButtonTextColor;

- (void)handleConfirmButton;

@end

NS_ASSUME_NONNULL_END
