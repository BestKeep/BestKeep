//
//  UserCentrerBaceCell.m
//  BESTKEEP
//
//  Created by dcj on 15/8/19.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

//#import "UserCentrerBaseCell.h"
//#import "UIView+Position.h"
//#import "PrefixHeader.pch"
//#import "UIColor+CJCategory.h"
//
//@interface UserCentrerBaseCell ()
//@property (nonatomic,strong) UIView * backGroundView;
//
//@end
//@implementation UserCentrerBaseCell
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.width = [UIScreen mainScreen].bounds.size.width;
//        self.contentView.width = [UIScreen mainScreen].bounds.size.width;
//        UIView * backView = [[UIView alloc] initWithFrame:self.bounds];
//        backView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:backView];
//        self.backGroundView = backView;
//    }
//    return self;
//}
//
//-(void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
//    [self layoutUcAccessoryView:accessoryType];
//}
//
//#pragma mark
///**
// *  显示accesoryView
// */
//- (void)layoutUcAccessoryView:(UITableViewCellAccessoryType)type{
//    self.backGroundView.width = [UIScreen mainScreen].bounds.size.width;
//    self.textLabel.textColor = [UIColor colorWithString:@"#5f646e"];
//    /**
//     * 设置cell accessoryView
//     */
//    if (type == UITableViewCellAccessoryDisclosureIndicator) {
//        
//        CGRect bcAccessoryViewFrame =CGRectMake(0.0f, 0.0f,100.0f, 35.0f);
//        self.bcAccessoryView =[[UIView alloc] initWithFrame:bcAccessoryViewFrame];
//        self.bcAccessoryView.backgroundColor =[UIColor clearColor];
//        self.accessoryView =self.bcAccessoryView;
//        
//        
//        self.bcArrowImageView =[[UILabel alloc] init];
//        self.bcAccessoryView.backgroundColor = [UIColor clearColor];
//        self.bcArrowImageView.frame =CGRectMake(self.bcAccessoryView.width -13, 10.0f, 13, 13);
//        self.bcArrowImageView.backgroundColor =[UIColor clearColor];
//        self.bcArrowImageView.font=[UIFont fontWithName:@"iconfont" size:13];
//        self.bcArrowImageView.text = @"\U0000e610";
//        self.bcArrowImageView.textColor = [UIColor colorWithString:@"#aaaaaa"];
//
//        [self.bcAccessoryView addSubview:self.bcArrowImageView];
//        
//        if (self.needHideArrowImage) {
//            self.bcArrowImageView.width = 0;
//        }
//        CGRect ucRightFrame =CGRectMake(0.0f, 6.0f,self.bcAccessoryView.width-(self.bcArrowImageView.width), 21.0f);
//        self.bcRightTextLabel =[[UILabel alloc] initWithFrame:ucRightFrame];
//        self.bcRightTextLabel.font =[UIFont systemFontOfSize:13.0f];
//        self.bcRightTextLabel.textColor =[UIColor colorWithString:@"#999999"];
//        self.bcRightTextLabel.textAlignment =NSTextAlignmentRight;
//        self.bcRightTextLabel.backgroundColor =[UIColor clearColor];
//        self.bcRightTextLabel.adjustsFontSizeToFitWidth =YES;
//        [self.bcAccessoryView addSubview:self.bcRightTextLabel];
//    }else{
//        [self.bcAccessoryView removeFromSuperview];
//    }
//}
//
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//    // Configure the view for the selected state
//}
//
//@end
