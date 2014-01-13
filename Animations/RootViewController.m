//
//  RootViewController.m
//  Animations
//
//  Created by Oleg Trakhman on 1/11/14.
//  Copyright (c) 2014 animations. All rights reserved.
//

#import "RootViewController.h"

// bugfix #2: restrain buttons from rotating offscreen
const CGFloat minAngle = -M_PI_4/4;
const CGFloat maxAngle = M_PI_4/4;
const CGFloat midAngle = (maxAngle + minAngle) / 2;

const CGFloat hideAngle = -M_PI_4 * 3;

CGPoint changeAnchorPointAndRotate(CGPoint offset, CGFloat angle)
{
    CGPoint rotatedPt = CGPointApplyAffineTransform(offset, CGAffineTransformMakeRotation(angle));
    rotatedPt.x += 0.5;
    rotatedPt.y += 0.5;
    return rotatedPt;
}

CGFloat angleFromCGPoint(CGPoint pt1, CGPoint pt2)
{
    CGPoint vector = CGPointMake(pt2.x - pt1.x, pt2.y - pt1.y);
    return atan2f(vector.y, vector.x);
}

@interface RootViewController ()

@end

@implementation RootViewController


-(IBAction)animationButtonTap:(UIButton *)sender
{
    
    filterEnabled = !filterEnabled;
    
    // Disable user interaction until the end of animation
    sender.userInteractionEnabled = NO;
    
    // bugfix #1: disable user interactions with filtered views
    _overlayView.userInteractionEnabled = filterEnabled;

    UIImage *buttonImg = [UIImage imageNamed:filterEnabled ? @"hideButton.png" : @"showButton.png"];
    [_animationButton setImage:buttonImg forState:UIControlStateNormal];
    
    // Here come the animations
    const CGFloat animationDuration = 0.5;
    if (filterEnabled) {
        [UIView animateWithDuration:animationDuration animations:^(){
            _overlayView.alpha = 0.7;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration animations: ^(){
                self.rotationAngle = 0;
            } completion:^(BOOL finished) {
                [self.view addGestureRecognizer:panRecognizer];
                self.animationButton.userInteractionEnabled = YES;
            }];
        }];
    } else {
        [self.view removeGestureRecognizer:panRecognizer];
        [UIView animateWithDuration:animationDuration animations:^(){
            self.rotationAngle = hideAngle;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration animations:^(){
                _overlayView.alpha = 0.0;
                self.animationButton.userInteractionEnabled = YES;
            }];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setting up
    rotatingButtons = @[_zeroButton, _plusButton, _minusButton, _closeButton];
    CGSize scrSize = [[UIScreen mainScreen] bounds].size;
    rotationCenter = CGPointMake(scrSize.width - 26, scrSize.height - 30);

    // Adjust UI positions
    _animationButton.center = rotationCenter;
    _rotationSign.center = CGPointMake(rotationCenter.x - 45, rotationCenter.y - 70);
    radius = 190;
    
    // Overlay View drawing setup
    _overlayView.rotationCenter = [_overlayView convertPoint:rotationCenter fromView:self.view];
    _overlayView.radius = radius;
    
    // Buttons setup
    CGFloat buttonSize = _plusButton.frame.size.width;
    CGPoint rotationVector = CGPointMake(0, radius/buttonSize);
    
    CGFloat angle = 0;
    for (UIButton *btn in rotatingButtons) {
        
        // Make button positions and anchor points
        btn.center = rotationCenter;
        btn.layer.anchorPoint = changeAnchorPointAndRotate(rotationVector, angle);
        angle -= M_PI_2/3;
        
    }

    // Hide buttons, to reveal them latter
    self.rotationAngle = hideAngle;

    // Add gestures
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];

}


- (void)handlePan: (UIPanGestureRecognizer *) sender
{
    static CGFloat initialAngle;

    if (!filterEnabled) {
        return;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        initialAngle = _rotationAngle;
        return;
    }

    CGPoint loc =  [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    CGPoint origin = CGPointMake(loc.x - translation.x, loc.y - translation.y);
    
    CGFloat angle1 = angleFromCGPoint(origin, rotationCenter);
    CGFloat angle2 = angleFromCGPoint(loc, rotationCenter);
    CGFloat angleDiff = angle2 - angle1;
    
    // bugfix #2: restrain buttons from rotating offscreen
    CGFloat rotationAngleRaw = angleDiff + initialAngle;
    
    if (rotationAngleRaw > maxAngle) {
        rotationAngleRaw = maxAngle;
    }
    
    if (rotationAngleRaw < minAngle) {
        rotationAngleRaw = minAngle;
    }
    
    self.rotationAngle = rotationAngleRaw;
}

- (CGFloat)rotationAngle
{
    return _rotationAngle;
}

- (void)setRotationAngle: (CGFloat)rotationAngle
{
    
    if (_rotationAngle > midAngle) {
        [_rotationSign setImage:[UIImage imageNamed:@"rotationSignCCW.png"]];
    } else {
        [_rotationSign setImage:[UIImage imageNamed:@"rotationSignCW.png"]];
    }
    
    _rotationAngle = rotationAngle;
    
    for (UIButton *btn in rotatingButtons) {
        btn.transform = CGAffineTransformMakeRotation(_rotationAngle);
    }
}

@end
