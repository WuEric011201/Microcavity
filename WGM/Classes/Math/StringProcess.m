//
//  StringProcess.m
//  microcavity
//
//  Created by Xiangyi Xu on 9/11/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import "StringProcess.h"

@implementation StringProcess

- (BOOL)textFieldDecimalNumberJudge:(UITextField *)textField decimalNumbers: (NSInteger)decimalNumbers maxInput: (double) max minInput: (double) min
{
    BOOL valid= false;
    
    if ([textField.text length] > 0)
    {
        //Current Input Character
        unichar single = [textField.text characterAtIndex:textField.text.length-1];
        
        if([textField.text length] == 1)
        {
            //Judge the first input character
            if(single == '.')
            {
                textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(textField.text.length-1, 1) withString:@""];
                valid = false;
            }
            
            //Judge the input range
            if([textField.text doubleValue] <= max && [textField.text doubleValue] >= min)
            {
                valid = true;
            }
            
            
        }
        else
        {
            //Judge the decimal point numbers
            if([self justRepeatStringNumbers:textField.text repeatSingleCharacter:'.']>1)
            {
                textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(textField.text.length-1, 1) withString:@""];
                valid = false;
            }
            
            //Judge the decimal number
            if([self calculateDecimalNumbers:textField.text]>decimalNumbers)
            {
                textField.text = [textField.text stringByReplacingCharactersInRange:NSMakeRange(textField.text.length-1, 1) withString:@""];
                valid = false;
            }

            //Judge the input range
            if([textField.text doubleValue] <= max && [textField.text doubleValue] >= min)
            {
                valid = true;
            }  

            
        }
        
    }
    return valid;
}


/** Calculate the repeat single character in string  */
- (NSInteger)justRepeatStringNumbers:(NSString *) string repeatSingleCharacter:(int) repeatString
{
    int number = 0;
    for(int i=0; i<string.length; i++)
    {
        if([string characterAtIndex:i] == '.')
        {
            number++;
        }
    }
    return number;
}

/** Calculate the decimal number in string  */
- (NSInteger)calculateDecimalNumbers:(NSString *) string
{
    NSInteger number = 0;
    number = string.length-[string rangeOfString:@"."].location-1;
    return number;
}

/** Limited Range Output  */
- (double)limitRangeValue:(double) intput maxOutput: (double) max minOutput:(double) min defaultOutput:(double) defOut isUseDefaultOutrange: (BOOL) isUse

{
    if(intput<min)
    {
        if(isUse)
        {
            intput=defOut;
        }
        else
        {
            intput=min;
        }
    }
    else if(intput>max)
    {
        if(isUse)
        {
            intput=defOut;
        }
        else
        {
            intput=max;
        }
    }
    
   else
   {
       intput=intput;
   }
    
    return intput;
}


@end
