//
//  DAIGenericViewController.h
//  DragAnimationIphone
//
//  Created by Ian Calderon on 6/26/13.
//  Copyright (c) 2013 Ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DAIGenericViewController : UIViewController{
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *dismissIndicator;
    
    BOOL isIndicatorOn;
    BOOL isAnimating;
}

@property (nonatomic, copy) NSString *articleTitle;

-(void)showDismissIndicator;
-(void)hideDismissIndicator;


@end
