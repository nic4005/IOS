//
//  UIView+Position.m
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

#pragma mark -
#pragma mark getter
- (CGFloat)width {
    return self.bounds.size.width;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (CGPoint)bottomRightPoint {
    return CGPointMake(self.frame.origin.x + self.bounds.size.width,
                       self.frame.origin.y + self.bounds.size.height);
}

- (CGFloat)leftMostX {
    return self.frame.origin.x;
}

- (CGFloat)topY {
    return self.frame.origin.y;
}


- (CGFloat)bottomY {
    return self.frame.origin.y + self.bounds.size.height;
}

- (CGFloat)rightMostX {
    return self.frame.origin.x + self.bounds.size.width;
}


#pragma mark -
#pragma mark setter
- (void)setFrameX:(CGFloat)x {
    self.frame = (CGRect){x, self.frame.origin.y, self.frame.size};
}

- (void)setFrameY:(CGFloat)y {
    self.frame = (CGRect){self.frame.origin.x, y, self.frame.size};
}

- (void)setFrameWidth:(CGFloat)width {
    self.frame = (CGRect){self.frame.origin, width, self.frame.size.height};
}

- (void)setFrameHeight:(CGFloat)height {
    self.frame = (CGRect){self.frame.origin, self.frame.size.width, height};
}


- (void)setFrameOrigin:(CGPoint)origin {
    self.frame = (CGRect){origin, self.frame.size};
}

- (void)setFrameSize:(CGSize)size {
    self.frame = (CGRect){self.frame.origin, size};
}


#pragma mark -
#pragma mark view
- (UIView *)topLayerSubviewWithTag:(NSInteger)tag {
    UIView *subview = nil;
    for (UIView *view in self.subviews) {
        if (view.tag == tag) {
            subview = view;
            break;
        }
    }
    
    return subview;
}

@end
