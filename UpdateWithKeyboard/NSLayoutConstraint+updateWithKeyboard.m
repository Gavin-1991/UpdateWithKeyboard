//
//  NSLayoutConstraint+updateWithKeyboard.m
//  UpdateWithKeyboard
//
//  Created by liukai on 24/05/2017.
//  Copyright © 2017 com.liukai.updateWithKeyboard. All rights reserved.
//

#import "NSLayoutConstraint+updateWithKeyboard.h"
#import <objc/runtime.h>

static char const * const originalHeightKey = "originalHeightKey";
static char const * const deallocHelperKey  = "DeallocHelper";

@interface ConstraintDeallocHelper : NSObject

@property (assign, nonatomic) NSLayoutConstraint *constraint;
- (id)initWithConstraint:(NSLayoutConstraint *)constriant;

@end

@implementation ConstraintDeallocHelper

- (id)initWithConstraint:(NSLayoutConstraint *)constriant
{
    self = [super init];
    
    if (self)
    {
        self.constraint = constriant;
    }
    
    return self;
}

- (void)dealloc
{
    if (self.constraint)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.constraint];
    }
}
@end

@implementation NSLayoutConstraint (updateWithKeyboard)

- (void)setUpdateWithKeyboard:(BOOL)updateWithKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary * info             = [aNotification userInfo];
    CGSize         kbSize           = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    NSNumber      *durationValue    = info[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration         = durationValue.doubleValue;
    
    NSNumber            *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve curve      = (UIViewAnimationCurve)curveValue.intValue;
    
    [self setKeyboardHeight:kbSize.height withAnimation:YES duration:duration curve:curve];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary * info             = [aNotification userInfo];
    
    NSNumber      *durationValue    = info[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration         = durationValue.doubleValue;
    
    NSNumber            *curveValue = info[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve curve      = (UIViewAnimationCurve)curveValue.intValue;
    
    [self setKeyboardHeight:0 withAnimation:YES duration:duration curve:curve];
}

- (void)setupDeallocHelper
{
    if (!objc_getAssociatedObject(self, deallocHelperKey))
    {
        ConstraintDeallocHelper *helper = [[ConstraintDeallocHelper alloc] initWithConstraint:self];
        objc_setAssociatedObject(self, deallocHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (NSNumber *)initalHeight
{
    return objc_getAssociatedObject(self, originalHeightKey);
}

- (void)setInitalHeight:(NSNumber *)initalHeight
{
    objc_setAssociatedObject(self, originalHeightKey, initalHeight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)superView
{
    UIView *first, *second;
    
    if ([self.firstItem isKindOfClass:[UIView class]])
    {
        first = self.firstItem;
    }
    
    if ([self.secondItem isKindOfClass:[UIView class]])
    {
        second = self.secondItem;
    }
    
    if (first && second)
    {
        if (first.superview == second)
        {
            return second;
        }
        else if (second.superview == first)
        {
            return first;
        }
        else if (first.superview)
        {
            return first.superview;
        }
        else if (second.superview)
        {
            return second.superview;
        }
        else
        {
            return nil;
        }
    }
    else if (first)
    {
        return first.superview ? first.superview : first;
    }
    else if (second)
    {
        return second.superview ? second.superview : second;
    }
    else
    {
        return nil;
    }
}

- (void)setKeyboardHeight:(CGFloat)height withAnimation:(BOOL)animation duration:(NSTimeInterval)duration curve:(UIViewAnimationCurve)curve
{
    if (animation)
    {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:(curve << 16)
                         animations:^{
                             self.constant = height + [self.initalHeight floatValue];
                             [self.superView layoutIfNeeded];
                         }
                         completion:nil];
    }
    else
    {
        self.constant = height + [self.initalHeight floatValue];
    }

}

@end
