//
//  UIView+Position.h
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)
@property (readonly, nonatomic) CGFloat width;
@property (readonly, nonatomic) CGFloat height;
@property (readonly, nonatomic) CGPoint bottomRightPoint;
@property (readonly, nonatomic) CGFloat topY;
@property (readonly, nonatomic) CGFloat leftMostX;
@property (readonly, nonatomic) CGFloat bottomY;
@property (readonly, nonatomic) CGFloat rightMostX;

- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameHeight:(CGFloat)height;
- (void)setFrameOrigin:(CGPoint)origin;
- (void)setFrameSize:(CGSize)size;

- (UIView *)topLayerSubviewWithTag:(NSInteger)tag;
@end
