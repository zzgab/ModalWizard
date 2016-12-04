//
//  ModalWizard.m
//  CalJ
//
//  Created by gabriel on 11/25/16.
//  Copyright © 2016 Plenitech. All rights reserved.
//

#import "ModalWizard.h"

@implementation ModalWizard {
    NSArray<ModalWizardPage *> * pages;
    UIView * currentPageView;
    NSUInteger currentPageNum;
    NSString * _backCaption;
    
    // Represents the navigation stack (for the Back feature)
    NSMutableArray<NSNumber *> * pageStack;
}

+ (void) showWithPages: (NSArray<ModalWizardPage *> * _Nonnull) pages backCaption: (NSString * _Nullable) backCaption
{
    ModalWizard * wizard = [[[self class] alloc] initWithPages: pages backCaption: backCaption];
    
    [wizard show];
}

+ (void (^ _Nonnull) (ModalWizard * _Nonnull)) dismissAction
{
    void (^dismissAction) (ModalWizard * _Nonnull);
    dismissAction = ^(ModalWizard * _Nonnull wizard) {
        [wizard dismiss];
    };
    return dismissAction;
}

- (id) initWithPages: (NSArray<ModalWizardPage *> *) pgs backCaption: (NSString * _Nullable) backCaption
{
    self = [super init];
    _backCaption = [backCaption retain];
    pageStack = [[NSMutableArray alloc] initWithCapacity: 2];
    pages = [pgs retain];
    _view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    _view.backgroundColor = [UIColor whiteColor];
    
    return self;
}

- (void) dismiss
{
    
    [UIView animateWithDuration: 0.5
                     animations:^{
                         _view.transform = CGAffineTransformMakeTranslation(0, - _view.frame.size.height);
                     } completion:^(BOOL finished) {
                         [_view removeFromSuperview];
                         [self release];
                         // This is the smartest place to release the current object:
                         // It was allocated in a static way,
                         // and it must alsways terminate its life-cycle with one single dismiss call,
                         // and the is no reason for the caller to care about memory mgt of the Wizard anyway.
                     }];
}

- (void) show
{
    // Show the first page
    currentPageNum = 0;
    ModalWizardPage * page = (ModalWizardPage *)[pages objectAtIndex: 0];
    page.wizard = self;
    page.hasBack = NO;
    currentPageView = [page getView];
    
    [_view addSubview: currentPageView];
    _view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
    [[[UIApplication sharedApplication] keyWindow] addSubview: _view];
    
    [UIView animateWithDuration: .5
                     animations:^{
                         _view.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [page showButtons];
                     }];

}

- (void) goBack
{
    if ([pageStack count] == 0)
        return;
    
    NSUInteger goTo = [[pageStack lastObject] unsignedIntegerValue];
    [pageStack removeLastObject];
    [self goToPage: goTo pushHistory: NO];
}


- (void) goToPage: (NSUInteger) pageNum
{
    [self goToPage: pageNum pushHistory: YES];
}

- (void) goToPage: (NSUInteger) pageNum pushHistory: (BOOL) pushHistory
{
    
    // Bounds checking
    if (pageNum >= [pages count])
        return;
    
    
    // Manage the navigation stack
    if (pushHistory)
        [pageStack addObject: [NSNumber numberWithUnsignedInteger: currentPageNum]];
    
    
    // Determine direction of scroll
    BOOL pageIsBelow = (pageNum > currentPageNum);
                        
    
    // Obtain (or prepare) the requested page's view
    ModalWizardPage * page = (ModalWizardPage *) [pages objectAtIndex: pageNum];
    page.wizard = self;
    page.backCaption = _backCaption;
    page.hasBack = ([pageStack count] > 0);
    
    UIView * vw = [page getView];
    [page hideButtons];
    vw.transform = CGAffineTransformMakeTranslation(0, vw.frame.size.height * (pageIsBelow ? +1 : -1));
    [_view addSubview: vw];
    [UIView animateWithDuration: .3
                     animations:^{
                         vw.transform = CGAffineTransformIdentity;
                         currentPageView.transform = CGAffineTransformMakeTranslation(0, - vw.frame.size.height * (pageIsBelow ? +1 : -1));
                     } completion:^(BOOL finished) {
                         [currentPageView removeFromSuperview];
                         currentPageView = vw;
                         currentPageNum = pageNum;
                         [page showButtons];
                     }];
}

- (void) dealloc
{
    [_view release];
    [pages release];
    [pageStack release];
    [_backCaption release];
    [super dealloc];
}

@end
