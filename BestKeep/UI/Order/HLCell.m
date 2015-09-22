//
//  HLCell.m
//  BESTKEEP
//
//  Created by 魏鹏 on 15/8/26.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import "HLCell.h"

@implementation HLCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.label1 = [UILabel new];
        self.label2 = [UILabel new];
        self.label3 = [UILabel new];
        self.label4 = [UILabel new];
        self.label5 = [UILabel new];
        
        [self initLabel:self.label1 FontSize:12 Color:COLOR_07];
        [self initLabel:self.label2 FontSize:12 Color:COLOR_07];
        [self initLabel:self.label3 FontSize:12 Color:COLOR_07];
        [self initLabel:self.label4 FontSize:12 Color:COLOR_06];
        [self initLabel:self.label5 FontSize:12 Color:COLOR_07];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        [self.contentView addSubview:self.lineView];
        
        
        [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).mas_offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label1.mas_right).mas_offset(5);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.label5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).mas_offset(-15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.label5.mas_left).mas_offset(-2);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.label4.mas_left).mas_offset(-5);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}
-(void)initLabel:(UILabel*)textLabel  FontSize:(CGFloat)size Color:(UIColor*)color {
    textLabel.font = [UIFont boldSystemFontOfSize:size];
    textLabel.numberOfLines = 0;
    textLabel.textColor = color;
    [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.contentView addSubview:textLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
