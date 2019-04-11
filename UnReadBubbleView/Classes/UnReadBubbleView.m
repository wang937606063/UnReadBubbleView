//
//  UnReadBubbleView.m
//  BubbleViewDemo
//
//  Created by wpf on 15/3/18.
//  Copyright (c) 2019年 wangpengfei. All rights reserved.
//

#import "UnReadBubbleView.h"

@implementation UnReadBubbleView{
    
    UIBezierPath *cutePath;
    UIColor *fillColorForCute;
    
    CADisplayLink *displayLink;
    
    UIView *frontView;
    UIView *backView;
    CGFloat r1; // backView
    CGFloat r2; // frontView
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;
    CGFloat cosDigree;
    CGFloat sinDigree;
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    CGRect oldBackViewFrame;
    CGPoint initialPoint;
    CGPoint oldBackViewCenter;
    CAShapeLayer *shapeLayer;
    
    UIPanGestureRecognizer *pan;
    
    CGFloat critical;
}

-(void)setFrame:(CGRect)frame{
    if (frame.size.width!=frame.size.height) {
        _bubbleWidth = frame.size.height=frame.size.width;
        initialPoint = frame.origin;
    }
    [super setFrame:frame];
}

-(void)setBubbleWidth:(CGFloat)bubbleWidth{
    _bubbleWidth=bubbleWidth;
}

-(id)init{
    if (self=[super init]) {
        self.frame=CGRectMake(0, 0, 25, 25);
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
        _viscosity=10;
        _breakViscosity=_viscosity/2.;
        _bubbleColor = [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1];
        _allowPan=YES;
        _showGameCenterAnimation=NO;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragMe:)];
        _viscosity  = 8;
        _breakViscosity=_viscosity/3.0;
        _bubbleColor = [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1];
        _allowPan=YES;
        _showGameCenterAnimation=NO;
        self.bubbleWidth = frame.size.height;
        initialPoint = frame.origin;
        self.bubbleLabel = [[UILabel alloc]init];
    }
    return self;
}

-(void)removeFromSuperview{
    
    [frontView removeFromSuperview];
    [backView removeFromSuperview];
    frontView=nil;
    backView=nil;
    
    [super removeFromSuperview];
}

-(void)didMoveToSuperview{
    [self start];
}

-(void)start{
    float bubblewidth;
    switch (self.bubbleShape) {
        case BubbleViewCircle:
            bubblewidth = self.bubbleWidth;
            break;
        case BubbleViewSmall:
            bubblewidth = self.bubbleWidth+5;
            break;
        case BubbleViewBig:
            bubblewidth = self.bubbleWidth+15;
            break;
    }
    
    shapeLayer = [CAShapeLayer layer];
    
    self.backgroundColor = [UIColor clearColor];
    frontView = [[UIView alloc]initWithFrame:CGRectMake(initialPoint.x,initialPoint.y, bubblewidth, self.bubbleWidth)];
    
    r2 = self.bubbleWidth / 2;
    frontView.layer.cornerRadius = r2;
    frontView.backgroundColor = self.bubbleColor;
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(frontView.frame.origin.x, frontView.frame.origin.y, 20, 20)];
    r1 = self.bubbleWidth / 2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = self.bubbleColor;
    
    
    self.bubbleLabel.frame = CGRectMake(0, 0, frontView.bounds.size.width, frontView.bounds.size.height);
    self.bubbleLabel.textColor = [UIColor whiteColor];
    self.bubbleLabel.textAlignment = NSTextAlignmentCenter;
    self.bubbleLabel.backgroundColor = [UIColor clearColor];
    [frontView insertSubview:self.bubbleLabel atIndex:0];
    
    [self.superview addSubview:backView];
    [self.superview addSubview:frontView];
    
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    
    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);   // O
    pointP = CGPointMake(x2+r2, y2);  // P
    
    oldBackViewFrame = backView.frame;
    oldBackViewCenter = backView.center;
    
    backView.hidden = YES;
    
    if (_showGameCenterAnimation) {
        [self AddAniamtionLikeGameCenterBubble];
    }
    else{
        [self RemoveAniamtionLikeGameCenterBubble];
    }
    
    if (_allowPan) {
        [frontView addGestureRecognizer:pan];
    }
    else{
        [frontView removeGestureRecognizer:pan];
    }
}

-(void)dragMe:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self.superview];
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        backView.hidden = NO;
        fillColorForCute = self.bubbleColor;
        if (_showGameCenterAnimation) {
            [self RemoveAniamtionLikeGameCenterBubble];
        }
        if (displayLink == nil) {
            displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        
    }else if (ges.state == UIGestureRecognizerStateChanged){
        frontView.center = dragPoint;
        if (r1 <= _breakViscosity) {
            fillColorForCute = [UIColor clearColor];
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];
            [displayLink invalidate];
            displayLink = nil;
            
        }
        else {
            CGFloat xDist = (frontView.frame.origin.x - initialPoint.x);
            
            CGFloat yDist = (frontView.frame.origin.y - initialPoint.y);
            critical=sqrtf(xDist*xDist+yDist*yDist);
        }
        
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        CGFloat xDist = (frontView.frame.origin.x - initialPoint.x);
        
        CGFloat yDist = (frontView.frame.origin.y - initialPoint.y);
        CGFloat newCritical=sqrtf(xDist*xDist+yDist*yDist);
        
        if (r1 <=_breakViscosity&&critical<newCritical) {
            NSBundle * bundle = [NSBundle bundleForClass:[self class]];
            
            UIImageView * imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Image0"]];
            imageview.bounds = CGRectMake(0, 0, self.bubbleWidth*2, self.bubbleWidth*2);
            imageview.center = frontView.center;
            [frontView.superview addSubview:imageview];
            imageview.backgroundColor = [UIColor clearColor];
            [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(changeImageviewPicture:) userInfo:imageview repeats:YES];
            [self removeFromSuperview];
            if (self.backBlock) {
                self.backBlock();
            }
        }
        else{
            backView.hidden = YES;
            fillColorForCute = [UIColor clearColor];
            [shapeLayer removeFromSuperlayer];
            if ([[[UIDevice currentDevice] systemVersion] compare:@"6.9"] == NSOrderedAscending) {
                
            [UIView animateWithDuration:0.5 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                 frontView.center = oldBackViewCenter;
            } completion:^(BOOL finished) {
                if (finished) {
                    if (_showGameCenterAnimation) {
                        [self AddAniamtionLikeGameCenterBubble];
                    }
                    [displayLink invalidate];
                    displayLink = nil;
                }

                
            }];
            } else{
            
            [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                frontView.center = oldBackViewCenter;
            } completion:^(BOOL finished) {
                
                if (finished) {
                    if (_showGameCenterAnimation) {
                        [self AddAniamtionLikeGameCenterBubble];
                    }
                    [displayLink invalidate];
                    displayLink = nil;
                }
                
            }];
            }
        }
    }
}
//播放帧动画
-(void)changeImageviewPicture:(NSTimer*)timer{
    static int count = 1;
    UIImageView * imageview = timer.userInfo;
    NSBundle * bundle = [NSBundle bundleForClass:[self class]];
    NSString * imagebundldPath =[bundle pathForResource:@"UnReadBubbleView" ofType:@"bundle"];
    
    
    [imageview setImage:[UIImage imageWithContentsOfFile:[imagebundldPath stringByAppendingPathComponent:[NSString stringWithFormat:@"idcloud%d.png",count]]]];
    count++;
    if (count == 5) {
        [timer invalidate];
        count = 0;
        [imageview removeFromSuperview];
    }
}

#pragma mark - refresh view
-(void)displayLinkAction:(CADisplayLink *)dis{
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = frontView.center.x;
    y2 = frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    //    NSLog(@"%f", acosf(cosDigree));
    r1 = oldBackViewFrame.size.width / 2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    [self drawRect];
}

-(void)drawRect{
    
    
    backView.center = oldBackViewCenter;
    backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
    backView.layer.cornerRadius = r1;
    
    
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    
    if (backView.hidden == NO) {
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColorForCute CGColor];
        [self.superview.layer insertSublayer:shapeLayer below:frontView.layer];
    }
    
}

#pragma mark - GameCenter Animation

-(void)AddAniamtionLikeGameCenterBubble{
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(frontView.frame, frontView.bounds.size.width / 2 - 3, frontView.bounds.size.width / 2 - 3);
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

-(void)RemoveAniamtionLikeGameCenterBubble{
    [frontView.layer removeAllAnimations];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
