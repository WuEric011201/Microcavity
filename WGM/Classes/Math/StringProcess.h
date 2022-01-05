//
//  StringProcess.h
//  microcavity
//
//  Created by Xiangyi Xu on 9/11/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StringProcess : UIViewController

- (BOOL)textFieldDecimalNumberJudge:(UITextField *)textField decimalNumbers: (NSInteger)decimalNumbers maxInput: (double) max minInput: (double) min;

- (NSInteger)justRepeatStringNumbers:(NSString *) string repeatSingleCharacter:(int) repeatString;
- (NSInteger)calculateDecimalNumbers:(NSString *) string;
- (double)limitRangeValue:(double) intput maxOutput: (double) max minOutput:(double) min defaultOutput:(double) defOut isUseDefaultOutrange: (BOOL) isUse;

@end
