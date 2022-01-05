//
//  ViewController.h
//  microcavity
//
//  Created by Xiangyi Xu on 7/30/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface ViewController : UIViewController

/** Singleton Mode */
SingletonH(ViewController)

- (void) switchButtonStatus:(UIButton*)button unfunctionedColor:(UIColor*)unfunctionedColor functionedColor:(UIColor*)functionedColor unfunctionedTitleLabel:(NSString*)unfunctionedTitleLabel functionedTitleLabel:(NSString*)functionedTitleLabel;

- (BOOL) checkButtonStatus:(UIButton*)button unfunctionedColor:(UIColor*)unfunctionedColor functionedColor:(UIColor*)functionedColor;
- (void)updateLDTECButtonStatus;
- (void)startTimer;
- (void)stopTimer;
- (void)updateButtonStatusUDPDisconnect;
- (void)updateButtonStatusUDPConnect;
- (void)setLaserOperationButton:(BOOL) status;
- (void)closePopupView;

@end

