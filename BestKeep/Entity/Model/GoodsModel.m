//
//  GoodsModel.m
//  BESTKEEP
//
//  Created by dcj on 15/8/29.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel




@end

@implementation CollectionGoodsModel

-(NSString *)getPriceBalance{

    NSInteger markPrice = [self.market_price integerValue];
    NSInteger memberPrice = [self.member_price integerValue];
    return [NSString stringWithFormat:@"以降%ld元",(long)(markPrice - memberPrice)];
}
@end


@implementation BuyCarGoodsModel

-(void)setUnKonwnValueKeyWithDict:(NSDictionary *)unKonwnDict{
    self.ID = [unKonwnDict objectForKey:@"id"];
}

@end