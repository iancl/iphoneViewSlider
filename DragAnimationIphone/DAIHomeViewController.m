//
//  DAIHomeViewController.m
//  DragAnimationIphone
//
//  Created by Ian Calderon on 6/26/13.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import "DAIHomeViewController.h"
#import "DAIGenericViewController.h"

@interface DAIHomeViewController ()

@end

@implementation DAIHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        allViews = [NSMutableArray array];
        isAnimating = NO;
        previousYPos = 0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    
    [self.view setAutoresizesSubviews:YES];
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    // creating a custom button. action will be to call populateWithViews method
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0, 0, 100, 30)];
    [button setTitle:@"populate" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(populateWithViews) forControlEvents:UIControlEventTouchUpInside];
    
    // adding to view
    [self.view addSubview:button];
}

// will animate the entrance of a view
-(void)animateEntranceOfView: (UIView *)aView withDelay: (float)delay{
    
    [UIView animateWithDuration:0.2 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [aView setAlpha:1];
        
    } completion:^(BOOL finished){
        
    }];
}

//generating views and adding them to view
-(void)populateWithViews{
    
    
    for (int i=0; i < 5; i++) {
        
        //creating view
        DAIGenericViewController *vc = [[DAIGenericViewController alloc] init];
        //[vc setArticleTitle:[NSString stringWithFormat:@"Article number %i",i]];
        
        [vc setArticleTitle:[NSString stringWithFormat:@"Article number %i", i+1]];
        
        //view tag will be the index of its view controller on the array
        [vc.view setTag:i];
        
        //adding to view
        [allViews addObject:vc];
        [self.view addSubview:vc.view];
        
        //move out of frame so it wont be visible
        [vc.view setAlpha:0];
        
        
    }
    
    //animating each view entrance
    for (int i=0; i < [allViews count]; i++) {
        DAIGenericViewController *vc = [allViews objectAtIndex:i];
        
        [self animateEntranceOfView:vc.view withDelay:0.0];
    }
    
}


// reset global position values
-(void)resetGlobalPositionValues{
    previousYPos = 0;
    tappedLocation = CGPointZero;
}

-(void)updateIndicatorsOfViewController: (DAIGenericViewController *)vc{
    
    //store view center position
    float centerY = vc.view.frame.origin.y + vc.view.center.y;
    
    if (centerY < 0.0) {
        
        [vc showDismissIndicator];
        
    } else {
        [vc hideDismissIndicator];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // get touch
    UITouch *touch = [touches anyObject];
    
    // store the location
    tappedLocation = [touch locationInView:[touch view]];
        
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // do nothing if there are no views on the array
    if (allViews.count == 0) return;
    
    // get the touch
    UITouch *touch = [touches anyObject];
    
    // get current View
    UIView *view = [touch view];
    
    // get the coordinates
    CGPoint loc = [touch locationInView:self.view];
    
    
    // position View
    CGRect frame = [view frame];
    
    // setting position to new frame
    float newYPos = loc.y - tappedLocation.y;
        
    // do not move position if going backwards
    if (newYPos > 0) newYPos = 0;

    // storing this position
    previousYPos = frame.origin.y;
    
    // setting position to new frame
    frame.origin.y = newYPos;
    
    // setting new frame to current view
    [view setFrame:frame];
    
    // update View indicators
    [self updateIndicatorsOfViewController: [allViews objectAtIndex:view.tag]];
    
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // run if is not animating or if there are views on the array
    if(isAnimating || allViews.count == 0) return;
    
    // get the touch
    UITouch *touch = [touches anyObject];
     
    // get current View
    UIView *view = [touch view];

    
    // detect if should be removed
    [self shouldAnimateAndDismiss:view];
}

-(void)animateAndDismissView: (UIView *)aView{
    
    // block animation
    [UIView animateWithDuration:0.2 animations:^{
        
        // storing view height
        float height = aView.frame.size.height;
        
        // storing frame
        CGRect newFrame = [aView frame];
        
        // updating frame Y pos
        newFrame.origin.y = height * -1;
        
        //setting frame to view
        [aView setFrame:newFrame];
        
    } completion:^(BOOL finished){
        
        //view tag is the index of its view controller on the array
        int vcIndex = [aView tag];
        
        //remove view on completition
        [allViews removeObjectAtIndex:vcIndex];
        
        
        [aView removeFromSuperview];
        
        //is not animating anymore
        isAnimating = NO;
    }];
    
}

-(void)animateViewToOrigin: (UIView *)aView{
    
    // animating to origin
    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect newFrame = [aView frame];
        
        newFrame.origin.y = 0;
        
        [aView setFrame:newFrame];
        
    } completion:^(BOOL finished){
        
        //is not animating anymore
        isAnimating = NO;
    }];
}


-(void)shouldAnimateAndDismiss: (UIView *)aView{
    
    // set to is dismissing
    isAnimating = YES;
    
    //store view center position
    float centerY = aView.frame.origin.y + aView.center.y;
    
    //if the center of the view is above the center of the super view
    if (centerY < 0) {
        
        //dismiss
        [self animateAndDismissView: aView];
        
    } else {
        
        //restore to original position
        [self animateViewToOrigin:aView];
    }
    
    //reset position values
    [self resetGlobalPositionValues];
    
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self resetGlobalPositionValues];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
