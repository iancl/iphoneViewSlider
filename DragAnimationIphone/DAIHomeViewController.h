//
//  DAIHomeViewController.h
//  DragAnimationIphone
//
//  Created by Ian Calderon on 6/26/13.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class DAIGenericViewController;

@interface DAIHomeViewController : UIViewController{
    
    //will hold all views
    NSMutableArray *allViews;
    
    //will hold all colors
    NSArray *colors;
    
    //button will populate allViews array
    UIButton *button;
    
    //will hold a referece to the coordinates of the area when the view was tapped
    CGPoint tappedLocation;
    
    //will hold previous set Y coordinate
    float previousYPos;
    
    // YES if its animating and dismissing
    BOOL isAnimating;
}

@end
