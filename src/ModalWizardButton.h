//
//  ModalWizardButton.h
//  CalJ
//
//  Created by gabriel on 11/25/16.
//  Copyright © 2016 Plenitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModalWizard;
@class ModalWizardPage;

@interface ModalWizardButton : NSObject

+ (id _Nonnull) buttonWithTitle: (NSString * _Nonnull) title action: (void (^ _Nonnull) (ModalWizard * _Nonnull)) action;

- (void) attach: (ModalWizardPage * _Nonnull) page uibutton: (UIButton * _Nonnull) uiButton;

@property (nonatomic, readonly) NSString * _Nullable title;
@property (nonatomic, assign) UIButton * _Nonnull uiButton;
@property (nonatomic, copy) void (^ _Nonnull action) (ModalWizard * _Nonnull);

@end
