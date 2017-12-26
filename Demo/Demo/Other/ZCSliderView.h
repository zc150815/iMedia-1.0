//
//  ZCSliderView.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCSliderView;


@protocol ZCSliderViewDelegate <NSObject>

@optional
-(void)ZCSliderView:(ZCSliderView*)sliderView didSelectItemAtIndex:(NSInteger)index;

@end



@interface ZCSliderView : UIView

@property (nonatomic, strong) UIColor *ZC_BackgroudColor;//块背景颜色
@property (nonatomic, strong) UIFont *ZC_Font;//块字体
@property (nonatomic, strong) UIColor *ZC_TextColor_Nomal;//块字体颜色
@property (nonatomic, strong) UIColor *ZC_TextColor_Selected;//块字体选中颜色
@property (nonatomic,assign) CGFloat ZC_Margin;//块间隔

@property (nonatomic,assign) BOOL showSlider;//是否显示滚动条
@property (nonatomic, strong) UIColor *ZC_SliderColor;//滚动条颜色
@property (nonatomic,assign) CGFloat ZC_SliderHeight;//滚动条宽度


@property (nonatomic, strong) UIColor *ZC_BorderColor;//外框颜色
@property (nonatomic,assign) CGFloat ZC_BorderWidth;//外框宽度

@property (nonatomic, strong) NSArray *sliderArr;
@property (nonatomic, weak) id<ZCSliderViewDelegate> delegate;

@property (nonatomic,assign) NSInteger index;

@end
