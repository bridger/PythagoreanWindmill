//
//  ViewController.m
//  PythagoreanWindmill
//
//  Created by Bridger Maxwell on 7/20/13.
//  Copyright (c) 2013 bridgermaxwell. All rights reserved.
//

#import "WindmillViewController.h"
#import "WindmillView.h"

#import <QuartzCore/QuartzCore.h>


@interface PointHandleView : UIView {
    CGPoint _offset;
    NSString *_pointPropertyName;
    id _target;
}
@end


static void * const PointHandlePointObsContext = @"PointHandlePointObsContext";

#define HANDLE_RADIUS 25

@implementation PointHandleView

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, HANDLE_RADIUS * 2, HANDLE_RADIUS * 2)];
    if (self) {
//        [[self layer] setCornerRadius:HANDLE_RADIUS];
//        [[self layer] setBackgroundColor:[[UIColor colorWithWhite:0.5 alpha:0.5] CGColor]];
//        [[self layer] setBorderColor:[[UIColor blackColor] CGColor]];
//        [[self layer] setBorderWidth:2.0];
    }
    return self;
}

- (void)setTarget:(id)target pointPropertyName:(NSString *)pointPropertyName {
    [_target removeObserver:self forKeyPath:_pointPropertyName context:PointHandlePointObsContext];
    
    _target = target;
    _pointPropertyName = pointPropertyName;
    
    [_target addObserver:self forKeyPath:pointPropertyName options:NSKeyValueObservingOptionInitial context:PointHandlePointObsContext];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:[self superview]];
    _offset = CGPointMake(self.center.x - touchPoint.x, self.center.y - touchPoint.y );
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:[self superview]];
    [_target setValue:[NSValue valueWithCGPoint:CGPointMake(touchPoint.x + _offset.x, touchPoint.y + _offset.y)] forKey:_pointPropertyName];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == PointHandlePointObsContext) {
        [self setCenter:[[_target valueForKey:_pointPropertyName] CGPointValue]];
    }
}

- (void)dealloc {
    [_target removeObserver:self forKeyPath:_pointPropertyName context:PointHandlePointObsContext];
}

@end



@interface WindmillViewController ()

@end

@implementation WindmillViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WindmillView *view = (WindmillView *)[self view];
    
    [view setPointA:CGPointMake(210, 518)];
    [view setPointB:CGPointMake(299, 361)];
    [view setPointC:CGPointMake(574, 517)];
    
    for (NSString *pointName in @[@"pointA", @"pointB", @"pointC"]) {
        PointHandleView *handle = [[PointHandleView alloc] init];
        [view addSubview:handle];
        [handle setTarget:view pointPropertyName:pointName];
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
