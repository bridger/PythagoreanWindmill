//
//  WindmillView.m
//  PythagoreanWindmill
//
//  Created by Bridger Maxwell on 7/20/13.
//  Copyright (c) 2013 bridgermaxwell. All rights reserved.
//

#import "WindmillView.h"

@implementation WindmillView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPointA:(CGPoint)pointA {
    _pointA  = pointA;
    [self setNeedsDisplay];
}
- (void)setPointB:(CGPoint)pointB {
    _pointB  = pointB;
    [self setNeedsDisplay];
}
- (void)setPointC:(CGPoint)pointC {
    _pointC  = pointC;
    [self setNeedsDisplay];
}


double getDistance(CGPoint point1, CGPoint point2) {
    return hypot(point2.x - point1.x, point2.y - point1.y);
}

CGPoint pointOnFarSquareCorner(CGPoint point1, CGPoint point2, double squareWidth) {
    CGPoint returnPoint = CGPointMake(point1.x, point1.y);
    double angle = atan2(point2.x - point1.x, point2.y - point1.y);
    returnPoint.x += squareWidth * cos(M_PI - angle);
    returnPoint.y += squareWidth * sin(M_PI - angle);
    
    return returnPoint;
}

- (void)fillRect:(CGContextRef)ctx fromPoint:(CGPoint)point1 toPoint:(CGPoint)point2 width:(double)width height:(double)height {
    double angle = atan2(point2.x - point1.x, point2.y - point1.y);
        
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, point1.x, point1.y);
    CGContextRotateCTM(ctx, -angle);
    
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, height, 0);
    CGContextAddLineToPoint(ctx, height, width);
    CGContextAddLineToPoint(ctx, 0, width);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"Drawing with A(%.0f, %.0f) B(%.0f, %.0f) C(%.0f, %.0f)", [self pointA].x, [self pointA].y, [self pointB].x, [self pointB].y, [self pointC].x, [self pointC].y);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    //Draw A^2
    double A = getDistance([self pointA], [self pointB]);
    CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
    [self fillRect:ctx fromPoint:[self pointA] toPoint:[self pointB] width:A height:A];
    
    //Draw B^2
    double B = getDistance([self pointB], [self pointC]);
    CGContextSetFillColorWithColor(ctx, [[UIColor blueColor] CGColor]);
    [self fillRect:ctx fromPoint:[self pointB] toPoint:[self pointC] width:B height:B];
    
    //Draw C^2
    double C = getDistance([self pointC], [self pointA]);
//    CGContextSetFillColorWithColor(ctx, [[[UIColor purpleColor] colorWithAlphaComponent:0.5] CGColor]);
//    [self fillRect:ctx fromPoint:[self pointC] toPoint:[self pointA] width:C height:C];
    
    //Draw B^2 over C^2
    CGContextSetFillColorWithColor(ctx, [[[UIColor blueColor] colorWithAlphaComponent:0.5] CGColor]);
    double bWidth = B*B / C;
    [self fillRect:ctx fromPoint:[self pointC] toPoint:[self pointA] width:bWidth height:C];
    
    //Draw A^2 over C^2
    CGContextSetFillColorWithColor(ctx, [[[UIColor redColor] colorWithAlphaComponent:0.5] CGColor]);
    double aWidth = A*A / C;
    [self fillRect:ctx fromPoint:[self pointA] toPoint:[self pointC] width:aWidth height:-C];
    
    
    CGMutablePathRef triangle = CGPathCreateMutable();
    CGPathMoveToPoint(triangle, &transform, [self pointA].x, [self pointA].y);
    CGPathAddLineToPoint(triangle, &transform, [self pointB].x, [self pointB].y);
    CGPathAddLineToPoint(triangle, &transform, [self pointC].x, [self pointC].y);
    CGPathAddLineToPoint(triangle, &transform, [self pointA].x, [self pointA].y);
    CGPathCloseSubpath(triangle);
    
    CGContextAddPath(ctx, triangle);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    CGContextSetLineWidth(ctx, 3.0);
    CGContextStrokePath(ctx);
    
    CGFloat dashLengths[] = {4.5, 4.5};
    CGContextSetLineDash(ctx, 0, dashLengths, 2);
    CGContextSetLineWidth(ctx, 3.0);
    
    CGPoint pointD = pointOnFarSquareCorner([self pointA], [self pointC], C);
    CGPoint pointF = pointOnFarSquareCorner([self pointA], [self pointB], -A);
    
    CGPoint pointE = pointOnFarSquareCorner([self pointC], [self pointA], -C);
    CGPoint pointK = pointOnFarSquareCorner([self pointC], [self pointB], B);
    
    CGContextMoveToPoint(ctx, [self pointB].x, [self pointB].y);
    CGContextAddLineToPoint(ctx, pointD.x, pointD.y);
    
    CGContextMoveToPoint(ctx, [self pointC].x, [self pointC].y);
    CGContextAddLineToPoint(ctx, pointF.x, pointF.y);
    
    CGContextSetStrokeColorWithColor(ctx, [[UIColor greenColor] CGColor]);
    CGContextStrokePath(ctx);
    
    
    CGContextMoveToPoint(ctx, [self pointB].x, [self pointB].y);
    CGContextAddLineToPoint(ctx, pointE.x, pointE.y);
    
    CGContextMoveToPoint(ctx, [self pointA].x, [self pointA].y);
    CGContextAddLineToPoint(ctx, pointK.x, pointK.y);
    
    CGContextSetStrokeColorWithColor(ctx, [[UIColor darkGrayColor] CGColor]);
    CGContextStrokePath(ctx);
    
    // Drawing code
}

@end
