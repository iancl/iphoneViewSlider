//
//  DAIGenericViewController.m
//  DragAnimationIphone
//
//  Created by Ian Calderon on 6/26/13.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "DAIGenericViewController.h"

@interface DAIGenericViewController ()

@end

@implementation DAIGenericViewController
@synthesize articleTitle = articleTitle_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isIndicatorOn = NO;
        isAnimating = NO;
    }
    return self;
}

-(void)setViewInitialState{
    
    CALayer *layer = [self.view layer];
    
    //set view layer border
    [layer setBorderColor:[UIColor blackColor].CGColor];
    [layer setBorderWidth:2.0];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set text title
    [titleLabel setText:[self articleTitle]];
    
    //shape dismiss indicator label
    CALayer *layer = [dismissIndicator layer];
    [layer setCornerRadius:7.0];
    [layer setOpacity:0];
    
    [self setViewInitialState];
}

// layer animation method
-(void)animateOpacityOfLayer: (CALayer *)aLayer toValue: (float)toValue animKey: (NSString *)aKey{
    
    // creating opacity anim
    
    // getting current opacity value
    float currentValue = [aLayer opacity];
    
    // setting up animation
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [anim setDuration:0.2];
    [anim setFromValue:[NSNumber numberWithFloat:currentValue]];
    [anim setToValue:[NSNumber numberWithFloat:toValue]];
    [anim setDelegate:self];
    [aLayer setOpacity:toValue];
    [aLayer addAnimation:anim forKey:aKey];
    
    
    //it is animating now
    isAnimating = YES;
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    // is not animating
    isAnimating = NO;
}

-(void)showDismissIndicator{
    
    // stop if animating or indicator is already on
    if (isIndicatorOn || isAnimating) return;
    
    //indicator is on now
    isIndicatorOn = YES;
    
    //start animation
    CALayer *layer = [dismissIndicator layer];
    [self animateOpacityOfLayer:layer toValue:1 animKey:@"in"];
}

-(void)hideDismissIndicator{
    
    
    // stop if animating or indicator is already off
    if (!isIndicatorOn || isAnimating) return;
    
    //indicator is off now
    isIndicatorOn = NO;
    
    //start animation
    CALayer *layer = [dismissIndicator layer];
    [self animateOpacityOfLayer:layer toValue:0 animKey:@"out"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"destroyed v");
}

@end
