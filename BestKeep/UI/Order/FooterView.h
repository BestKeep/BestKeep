//
//  FooterView.h
//  BESTKEEP
//
//  Created by 魏鹏 on 15/8/24.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTLabel.h"

@protocol ClickOrderButton <NSObject>

-(void)ClickButtonEvent;

@end

@interface FooterView : UIView

@property(nonatomic,weak)   id <ClickOrderButton> delegate;

@property(nonatomic,strong) BTLabel *label1;
@property(nonatomic,strong) BTLabel *label2;
@property(nonatomic,strong) BTLabel *label3;
@property(nonatomic,strong) BTLabel *label4;

@property(nonatomic,strong) BTLabel *guide_label;
@property(nonatomic,strong) BTLabel *guide_textlabel;
@property(nonatomic,strong) BTLabel *guide_cashlabel;

@end
