//
//  GoodsModel.h
//  BESTKEEP
//
//  Created by dcj on 15/8/29.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import "BaseObject.h"

@interface GoodsModel : BaseObject
@property (nonatomic,copy) NSString * goods_no;
@property (nonatomic,copy) NSString * goods_img;
@property (nonatomic,copy) NSString * goods_id;
@property (nonatomic,copy) NSString * goods_name;
@property (nonatomic,copy) NSString * member_price;
@property (nonatomic,copy) NSString * market_price;
@property (nonatomic,copy) NSString * tax_amount;
@property (nonatomic,copy) NSString * amount;
@property (nonatomic,copy) NSString * sale_property;
@property (nonatomic,copy) NSString * goods_pro_rel1;
@property (nonatomic,copy) NSString * goods_pro_rel2;
@property (nonatomic,copy) NSString * goods_pro_rel3;
@property (nonatomic,copy) NSString * goods_pro_rel4;
@property (nonatomic,copy) NSString * goods_pro_rel5;
@property (nonatomic,copy) NSString * goods_img_small;
@property (nonatomic,copy) NSString * goods_img_big;
@property (nonatomic,copy) NSString * total_amount;

@property (nonatomic,assign) BOOL isSelected;


@end


@interface CollectionGoodsModel : GoodsModel

@property (nonatomic,copy) NSString * collect_id;


/**
 *  获得价格差
 *
 *  @return 返回价格差值
 */

-(NSString *)getPriceBalance;

@end
