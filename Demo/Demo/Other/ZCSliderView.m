//
//  ZCSliderView.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "ZCSliderView.h"

@interface ZCSliderView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *sliderView;


@end
@implementation ZCSliderView{
    NSInteger _selectedIndex;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _selectedIndex = 0;
        
        _ZC_BackgroudColor = [UIColor whiteColor];
        _ZC_Font = [UIFont systemFontOfSize:15];
        _ZC_TextColor_Nomal = [UIColor blackColor];
        _ZC_TextColor_Selected = [UIColor redColor];
        _ZC_Margin = 15.0;
        
        _showSlider = YES;
        _ZC_SliderColor = [UIColor redColor];
        _ZC_SliderHeight = PD_Fit(3);
        
        _ZC_BorderColor = [UIColor getColor:@"cccccc"];
        _ZC_BorderWidth = PD_Fit(1);
        
        
        self.layer.borderColor = _ZC_BorderColor.CGColor;
        self.layer.borderWidth = _ZC_BorderWidth;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0 ;
        flowLayout.minimumInteritemSpacing = 0;

        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.bounces = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ZCSortingBoxCellID"];
        self.collectionView = collectionView;
        [self addSubview:collectionView];
        
        
        UIView *sliderView = [[UIView alloc]init];
        sliderView.backgroundColor = _ZC_SliderColor;
        self.sliderView = sliderView;
        [collectionView addSubview:sliderView];
        [collectionView bringSubviewToFront:sliderView];
        
        
    }
    return self;
}


#pragma mark
#pragma mark UICollectionView代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCSortingBoxCellID" forIndexPath:indexPath];
//    PD_NSLog(@"+++++%f++++",cell.frame.origin.x);
    UILabel *sortingLab = [[UILabel alloc]initWithFrame:CGRectIntegral(CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height))];
    sortingLab.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.item]];
    sortingLab.font = _ZC_Font;
    sortingLab.textAlignment = NSTextAlignmentCenter;
    sortingLab.textColor = _selectedIndex==indexPath.row?_ZC_TextColor_Selected:_ZC_TextColor_Nomal;
    sortingLab.numberOfLines = 0;
    sortingLab.backgroundColor = _ZC_BackgroudColor;
    
    cell.backgroundView = sortingLab;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //当前被选中位置
    _selectedIndex = indexPath.item;
    //当前cell
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //cell在当前collection的位置
    CGRect cellRect = [collectionView convertRect:cell.frame toView:collectionView];
    
    //当前字体长度
    NSString *string = self.dataArr[indexPath.item];
    CGSize strSize = [string sizeWithAttributes:@{NSFontAttributeName:_ZC_Font}];
    
    //动画效果
    [UIView animateWithDuration:0.5 animations:^{
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.sliderView.frame = CGRectMake(cellRect.origin.x+_ZC_Margin/2, collectionView.height-_ZC_SliderHeight, strSize.width, _ZC_SliderHeight);
    }];
    
    [collectionView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZCSliderView:didSelectItemAtIndex:)]) {
        [self.delegate ZCSliderView:self didSelectItemAtIndex:indexPath.item];
    }
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    
    NSString *string = self.dataArr[indexPath.item];
    CGSize strSize = [string sizeWithAttributes:@{NSFontAttributeName:_ZC_Font}];
    
    return CGSizeMake((NSInteger)strSize.width+_ZC_Margin, collectionView.height);
}

#pragma mark
#pragma mark setter&getter方法
-(void)setSliderArr:(NSArray *)sliderArr{
    self.dataArr = sliderArr;
    
    NSString *string = sliderArr[_selectedIndex];
    CGSize strSize = [string sizeWithAttributes:@{NSFontAttributeName:_ZC_Font}];
    
    [self.collectionView reloadData];
    self.sliderView.frame = CGRectMake(_ZC_Margin/2, self.height-_ZC_SliderHeight, strSize.width, _ZC_SliderHeight);
    
}
-(void)setZC_BackgroudColor:(UIColor *)ZC_BackgroudColor{
    _ZC_BackgroudColor = ZC_BackgroudColor;
    
    [self.collectionView reloadData];
}
-(void)setZC_Font:(UIFont *)ZC_Font{
    _ZC_Font = ZC_Font;
    
    [self.collectionView reloadData];
}
-(void)setZC_Margin:(CGFloat)ZC_Margin{
    _ZC_Margin = ZC_Margin;
    
    [self.collectionView reloadData];
}
-(void)setShowSlider:(BOOL)showSlider{
    _showSlider = showSlider;
    self.sliderView.hidden = !showSlider;
}
-(void)setZC_BorderColor:(UIColor *)ZC_BorderColor{
    _ZC_BorderColor = ZC_BorderColor;
    
    self.layer.borderColor = ZC_BorderColor.CGColor;
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}
@end
