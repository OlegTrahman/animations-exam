//
//  RootViewController.h
//  Animations
//
//  Created by Oleg Trakhman on 1/11/14.
//  Copyright (c) 2014 animations. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
@interface RootViewController : UIViewController
{
    
    NSArray *rotatingButtons;
    CGPoint rotationCenter;
    CGFloat _rotationAngle;
    CGFloat radius;
    BOOL filterEnabled;
    
    UIPanGestureRecognizer *panRecognizer;
}
@property (nonatomic, readwrite) CGFloat rotationAngle;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *animationButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *zeroButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet OverlayView *overlayView;
@property (weak, nonatomic) IBOutlet UIImageView *rotationSign;
- (IBAction)animationButtonTap:(UIButton *)sender;

@end
