//
//  ModalWizard.h
//  CalJ
//
//  Created by gabriel on 11/25/16.
//  Copyright © 2016 Plenitech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModalWizardPage.h"

@interface ModalWizard : NSObject

+ (void) showWithPages: (NSArray<ModalWizardPage *> * _Nonnull) pages backCaption: (NSString * _Nullable) backCaption;

+ (void (^ _Nonnull) (ModalWizard * _Nonnull)) dismissAction;

- (void) dismiss;
- (void) goToPage: (NSUInteger) pageNum;

@property (nonatomic, readonly) UIView * _Nonnull view;

@end
