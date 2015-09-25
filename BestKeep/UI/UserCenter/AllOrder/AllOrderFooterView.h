//
//  AllOrderFooterView.h
//  BESTKEEP
//
//  Created by dcj on 15/9/18.
//  Copyright (c) 2015年 YISHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@class OrderInfo;
@class AllOrderFooterView;

typedef NS_ENUM(NSUInteger, AllOrderFooterActionType) {
    /**
     *  取消订单
     */
    AllOrderFooterActionTypeCancle = 0,
    /**
     *  订单付款
     */
    AllOrderFooterActionTypePay,
    /**
     *  确认收货
     */
    AllOrderFooterActionTypeConfirm,
};

/**
 *  footer响应事件协议
 */
@protocol AllOrderFooterProtocol <NSObject>
@optional
/**
 *  事件响应代理
 *
 *  @param footerView 点击所在footerVIew
 *  @param type       点击类型
 *  @param order      点击所在订单
 */
-(void)allOrderView:(AllOrderFooterView *)footerView actionType:(AllOrderFooterActionType)type order:(OrderInfo *)order;

@end


@interface AllOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) OrderInfo * order;
@property (nonatomic,weak)id<AllOrderFooterProtocol>footerDelegate;

/**
 *  根据order获得footerView的高度
 *
 *  @param orderInfo 传入订单
 *
 *  @return 返回高度
 */
-(CGFloat)getFooterHeightWithOrder:(OrderInfo *)orderInfo;

@end

#pragma mark -- footerView的 SubView
/**
 *  订单信息
 */
@interface AllOrderFooterOrderInfoView : UIView

@property (nonatomic,strong) OrderInfo * order;
-(CGFloat)getFooterOrderInfoHeightWithOrder:(OrderInfo *)orderInfo;


@end

/**
 *  footer的响应按钮事件协议
 */
@protocol AllOrderFooterActionProtocol <NSObject>

@optional
-(void)allOrderFooterViewAction:(AllOrderFooterActionType)type orderInfo:(OrderInfo *)order;
@end

/**
 *  响应事件view
 */
@interface AllOrderFooterActionView : UIView

@property (nonatomic,weak)id<AllOrderFooterActionProtocol>delegate;
@property (nonatomic,strong) OrderInfo * order;

-(CGFloat)getFooterActionViewHeightWithOrder:(OrderInfo *)orderInfo;


@end