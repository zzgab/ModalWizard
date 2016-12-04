//
//  ModalWizardPage.h
//  CalJ
//
//  Created by gabriel on 11/25/16.
//  Copyright © 2016 Plenitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalWizardButton.h"

@interface ModalWizardPage : NSObject

+ (id _Nonnull) pageWithTitle: (NSString * _Nullable) title text: (NSString * _Nullable) text buttons: (NSArray<ModalWizardButton *> * _Nonnull) buttons;

- (UIView * _Nonnull) getView;
- (void) hideButtons;
- (void) showButtons;

@property (nonatomic, assign) ModalWizard * _Nonnull wizard;
@property (nonatomic, assign) BOOL hasBack;
@property (nonatomic, assign) NSString * _Nullable backCaption;

@end
