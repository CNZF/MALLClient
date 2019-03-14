//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

#import "MLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "ConditionsForRetrievalVC.h"

@interface MLNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,strong) UIView *backgroundView;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation MLNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isNeedZoomIn = YES;
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        
    }
    return self;
}

- (void)dealloc
{
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // draw a shadow for navigation view to differ the layers obviously.
    // using this way to draw shadow will lead to the low performace
    // the best alternative way is making a shadow image.
    //
    //self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    //self.view.layer.shadowOffset = CGSizeMake(5, 5);
    //self.view.layer.shadowRadius = 5;
    //self.view.layer.shadowOpacity = 1;
    
//    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
//    [self.view addSubview:shadowImageView];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    [panGestureRecognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

-(void)addPanGestureRecognizer{
    panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    [panGestureRecognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

-(void)removePanGestureRecognizer{
    [self.view removeGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];
    if (self.viewControllers.count == 1) {
        (self.viewControllers[0]).hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    if ([viewController isKindOfClass:[ConditionsForRetrievalVC class]]) {
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        blackMask.alpha = 0.5;
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        self.backgroundView.hidden = NO;

        if (lastScreenShotView)
            [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
    }

}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    if (self.viewControllers.count == 2) {
        (self.viewControllers[0]).hidesBottomBarWhenPushed = NO;
    }
    return [super popViewControllerAnimated:animated];
}
-(NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers indexOfObject:viewController]  == 0) {
        (self.viewControllers[0]).hidesBottomBarWhenPushed = NO;
    }
    return [super popToViewController:viewController animated:animated];
}
-(NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated
{
    
    (self.viewControllers[0]).hidesBottomBarWhenPushed = NO;
    return [super popToRootViewControllerAnimated:animated];
}
#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{

    UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, self.view.opaque, 0.0);
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);
    
    if (self.isNeedZoomIn) {
        lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
        blackMask.alpha = alpha;
    } else {
        blackMask.alpha = 0.5;
    }
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;

    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    CGPoint velocity = [recoginzer velocityInView:KEY_WINDOW];
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
//        if(velocity.x>0)  {
//
//        }
//        else {
//        }
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        self.backgroundView.hidden = NO;
        if (lastScreenShotView)
            [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];

        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){

        WS(ws);
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.5 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {

                [self popViewControllerAnimated:NO];
                CGRect frame = ws.view.frame;
                frame.origin.x = 0;
                ws.view.frame = frame;

                _isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                if (ws.isNeedZoomIn){
                    ws.backgroundView.hidden = YES;
                }
            }];
        }
        return;

        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){

        WS(ws);
        [UIView animateWithDuration:0.5 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            if (ws.isNeedZoomIn){
                ws.backgroundView.hidden = YES;
            }
        }];

        return;
    }

    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}
@end
