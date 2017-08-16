//
//  UIView+AGRDraggable.m
//  DraggableView
//
//  Created by 实验室 on 2017/7/26.
//  Copyright © 2017年 实验室. All rights reserved.
//

#import "UIView+AGRDraggable.h"
#import <objc/runtime.h>

@implementation UIView (Draggable)

- (void)makeDraggable
{
    NSAssert(self.superview, @"Super view is required when make view draggable");
    
    [self makeDraggableInView:self.superview damping:0.4];
}

- (void)makeDraggableInView:(UIView *)view damping:(CGFloat)damping
{
    if (!view) return;
    [self removeDraggable];
    
    self.agr_playground = view;
    self.agr_damping = damping;
    
    [self agr_creatAnimator];
    [self agr_addPanGesture];
}

- (void)removeDraggable
{
    [self removeGestureRecognizer:self.agr_panGesture];
    self.agr_panGesture = nil;
    self.agr_playground = nil;
    self.agr_animator = nil;
    self.agr_snapBehavior = nil;
    self.agr_attachmentBehavior = nil;
    self.agr_centerPoint = CGPointZero;
}

- (void)updateSnapPoint
{
    self.agr_centerPoint = [self convertPoint:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) toView:self.agr_playground];
    self.agr_snapBehavior = [[UISnapBehavior alloc] initWithItem:self snapToPoint:self.agr_centerPoint];
    self.agr_snapBehavior.damping = self.agr_damping;
}

- (void)agr_creatAnimator
{
    self.agr_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.agr_playground];
    [self updateSnapPoint];
}

- (void)agr_addPanGesture
{
    self.agr_panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(agr_panGesture:)];
    [self addGestureRecognizer:self.agr_panGesture];
}

#pragma mark - Gesture

- (void)agr_panGesture:(UIPanGestureRecognizer *)pan
{
    CGPoint panLocation = [pan locationInView:self.agr_playground];
    
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        [self updateSnapPoint];
        
        UIOffset offset = UIOffsetMake(panLocation.x - self.agr_centerPoint.x, panLocation.y - self.agr_centerPoint.y);
        [self.agr_animator removeAllBehaviors];
        self.agr_attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self
                                                               offsetFromCenter:offset
                                                               attachedToAnchor:panLocation];
        [self.agr_animator addBehavior:self.agr_attachmentBehavior];
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        [self.agr_attachmentBehavior setAnchorPoint:panLocation];
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled ||
             pan.state == UIGestureRecognizerStateFailed)
    {
        [self.agr_animator addBehavior:self.agr_snapBehavior];
        [self.agr_animator removeBehavior:self.agr_attachmentBehavior];
    }
}

#pragma mark - Associated Object

- (void)setAgr_playground:(id)object {
    objc_setAssociatedObject(self, @selector(agr_playground), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)agr_playground {
    return objc_getAssociatedObject(self, @selector(agr_playground));
}

- (void)setAgr_animator:(id)object {
    objc_setAssociatedObject(self, @selector(agr_animator), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIDynamicAnimator *)agr_animator {
    return objc_getAssociatedObject(self, @selector(agr_animator));
}

- (void)setAgr_snapBehavior:(id)object {
    objc_setAssociatedObject(self, @selector(agr_snapBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UISnapBehavior *)agr_snapBehavior {
    return objc_getAssociatedObject(self, @selector(agr_snapBehavior));
}

- (void)setAgr_attachmentBehavior:(id)object {
    objc_setAssociatedObject(self, @selector(agr_attachmentBehavior), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIAttachmentBehavior *)agr_attachmentBehavior {
    return objc_getAssociatedObject(self, @selector(agr_attachmentBehavior));
}

- (void)setAgr_panGesture:(id)object {
    objc_setAssociatedObject(self, @selector(agr_panGesture), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIPanGestureRecognizer *)agr_panGesture {
    return objc_getAssociatedObject(self, @selector(agr_panGesture));
}

- (void)setAgr_centerPoint:(CGPoint)point {
    objc_setAssociatedObject(self, @selector(agr_centerPoint), [NSValue valueWithCGPoint:point], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGPoint)agr_centerPoint {
    return [objc_getAssociatedObject(self, @selector(agr_centerPoint)) CGPointValue];
}

- (void)setAgr_damping:(CGFloat)damping {
    objc_setAssociatedObject(self, @selector(agr_damping), @(damping), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)agr_damping {
    return [objc_getAssociatedObject(self, @selector(agr_damping)) floatValue];
}

@end
