//
//  ModalWizardButton.m
//  CalJ
//
//  Created by gabriel on 11/25/16.
//  Copyright © 2016 Plenitech. All rights reserved.
//

#import "ModalWizardButton.h"
#import "ModalWizardPage.h"
#import "ModalWizard.h"
#import <objc/runtime.h>

@implementation ModalWizardButton {
}


+ (id _Nonnull) buttonWithTitle: (NSString * _Nonnull) title action: (void (^ _Nonnull) (ModalWizard * _Nonnull)) action
{
    ModalWizardButton * button = [[ModalWizardButton alloc] initWithTitle: title action: action];
    [button autorelease];
    return button;
}

- (id) initWithTitle: (NSString *) title action: (void (^ _Nonnull) (ModalWizard * _Nonnull)) pAction
{
    self = [super init];
    _title = [title retain];
    self.action = pAction;
    return self;
}

- (void) action: (UIButton *) sender
{
    ModalWizardPage * page = (ModalWizardPage *) objc_getAssociatedObject(sender, "ModalWizardPage");
    ModalWizard * wizard = page.wizard;
    
    _action (wizard);
}

- (void) attach: (ModalWizardPage *) page uibutton: (UIButton *) uiButton
{
    // Use ObjC Runtim to create a weak association between the UIButton object, and
    // the applicative ModalWizardPage instance,
    // because addTarget won't accept a block, yet the selector will need to "know" me.
    _uiButton = [uiButton retain];
    objc_setAssociatedObject(_uiButton, "ModalWizardPage", page, OBJC_ASSOCIATION_ASSIGN);
}

- (void) dealloc
{
    // Release the OBJC associted objects
    objc_removeAssociatedObjects(_uiButton);
    [_uiButton release];
    
    [_title release];
    Block_release(_action);
    [super dealloc];
}

@end
