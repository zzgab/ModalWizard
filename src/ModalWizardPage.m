//
//  ModalWizardPage.m
//  CalJ
//
//  Created by gabriel on 11/25/16.
//  Copyright © 2016 Plenitech. All rights reserved.
//

#import "ModalWizardPage.h"
#import <objc/runtime.h>

@implementation ModalWizardPage
{
    UIView * view;
    UILabel * labelText;
    NSString * title;
    NSString * text;
    NSArray<ModalWizardButton *> * buttons;
    UIButton * btnBack;
}

+ (id _Nonnull) pageWithTitle: (NSString * _Nullable) title text: (NSString * _Nullable) text buttons: (NSArray<ModalWizardButton *> * _Nonnull) buttons
{
    ModalWizardPage * page = [[ModalWizardPage alloc] initWithTitle: title text: text buttons: buttons];
    [page autorelease];
    return page;
}

- (id) initWithTitle: (NSString *) pTitle text: (NSString *) pText buttons: (NSArray<ModalWizardButton *> * _Nonnull) pButtons
{
    self = [super init];
    title = [pTitle retain];
    text = [pText retain];
    buttons = [pButtons retain];
    
    view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor whiteColor];
    
    
    view.clipsToBounds = YES;
    
    
    // Page Title
    CGFloat fTitleBottom;
    if (nil != title) {
        UILabel * labelTitle = [[UILabel alloc] initWithFrame: CGRectMake(20, 70, view.frame.size.width, 40)];
        labelTitle.font = [UIFont boldSystemFontOfSize: 17];
        labelTitle.text = title;
        [view addSubview: labelTitle];
        [labelTitle release];
        fTitleBottom = 115;
    }
    else {
        fTitleBottom = 70;
    }
    
    // Label for page text
    labelText = [[UILabel alloc] initWithFrame: CGRectMake(20, fTitleBottom, view.frame.size.width - 2*20, 200)];
    labelText.backgroundColor = [UIColor clearColor];
    labelText.numberOfLines = 0;
    labelText.lineBreakMode = NSLineBreakByWordWrapping;
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.textColor = [UIColor blackColor];
    
    
    labelText.text = text;
    [view addSubview: labelText];
    
    
    // Adjust size of label according to its text
    CGRect textRect = [labelText.text boundingRectWithSize: CGSizeMake(labelText.frame.size.width, 450)
                                               options: NSStringDrawingUsesLineFragmentOrigin
                                            attributes: @{ NSFontAttributeName: labelText.font }
                                               context: nil];
    labelText.frame = CGRectMake(labelText.frame.origin.x, labelText.frame.origin.y, labelText.frame.size.width, textRect.size.height);
    
    
    
    // Calculate bottom of text:
    CGFloat fLabelBottom = labelText.frame.origin.y + labelText.frame.size.height;
    CGFloat fButtonsTop = fLabelBottom + 30;

    
    // Buttons

    // All buttons have same width:
    CGFloat fBtnWidth = view.frame.size.width / [buttons count];
    
    NSUInteger i = 0;
    for (ModalWizardButton * btn in buttons) {
        UIButton * uiButton = [UIButton buttonWithType: UIButtonTypeSystem];
        btn.uiButton = uiButton;
        uiButton.backgroundColor = [UIColor clearColor];
        [uiButton setTitle: btn.title forState: UIControlStateNormal];
        // Center the button in its Nth part of the width
        uiButton.frame = CGRectMake((i ++) * fBtnWidth, fButtonsTop, fBtnWidth, 40);
        
        // Use ObjC Runtim to create a weak association between the UIButton object, and
        // the applicative ModalWizardPage instance,
        // because addTarget won't accept a block, yet the selector will need to "know" me.
        [btn attach: self uibutton: uiButton];
        
        [uiButton addTarget: btn action: @selector(action:) forControlEvents: UIControlEventTouchUpInside];
        uiButton.alpha = 0.;
        [view addSubview: uiButton];
    }
    
    
    
    [self addBlueBars];
    return self;
}

- (void) addBlueBars
{
    // Une barre horizontale bleue
    UIView * vwTopBar = [[UIView alloc] initWithFrame: CGRectMake(0, 56, view.frame.size.width,  6)];
    vwTopBar.backgroundColor = [UIColor colorWithRed: 0x66 / 255. green: 0x99 / 255. blue: 0xcc / 255. alpha: 1.];
    [view addSubview: vwTopBar];
    [vwTopBar release];
    
    // Calcul du bottom du laius:
    CGFloat fLabelBottom = labelText.frame.origin.y + labelText.frame.size.height;
    
    // Une barre horizontale bleue
    UIView * vwBottomBar = [[UIView alloc] initWithFrame: CGRectMake(0, fLabelBottom + 16, view.frame.size.width,  6)];
    vwBottomBar.backgroundColor = [UIColor colorWithRed: 0x66 / 255. green: 0x99 / 255. blue: 0xcc / 255. alpha: 1.];
    [view addSubview: vwBottomBar];
    [vwBottomBar release];
    
    // The Back Button
    NSString * backStr = (_backCaption != nil ? [NSString stringWithFormat: @"« %@", _backCaption] : @"«");
    btnBack = [UIButton buttonWithType: UIButtonTypeSystem];
    btnBack.frame = CGRectMake(20, 20, 60, 40);
    btnBack.backgroundColor = [UIColor clearColor];
    [btnBack setTitle: backStr forState: UIControlStateNormal];
    [btnBack addTarget: self action:@selector(goBack) forControlEvents: UIControlEventTouchUpInside];
    [view addSubview: btnBack];
}

- (void) setHasBack:(BOOL)hasBack
{
    _hasBack = hasBack;
    btnBack.hidden = ! hasBack;
}

- (void) setBackCaption:(NSString *)backCaption
{
    _backCaption = backCaption;
    
    NSString * backStr = (_backCaption != nil ? [NSString stringWithFormat: @"« %@", _backCaption] : @"«");
    [btnBack setTitle: backStr forState: UIControlStateNormal];   
}

- (void) goBack
{
    [_wizard goBack];
}

- (UIView *) getView
{
    return view;
}

- (void) hideButtons
{
    for (ModalWizardButton * btn in buttons) {
        btn.uiButton.alpha = 0.;
    }
}

- (void) showButtons
{
    // Animate buttons appearance
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration: .4
                         animations:^{
                             for (ModalWizardButton * btn in buttons) {
                                 btn.uiButton.alpha = 1.;
                             }
                             
                             if (_hasBack) {
                                 btnBack.alpha = 1.;
                             }
                         }];
    });
}

- (void) dealloc
{
    [labelText release];
    [text release];
    [title release];
    [view release];
    [buttons release];
    
    [super dealloc];
}

@end
