//
//  MeasurementCell.h
//  microcavity
//
//  Created by Xiangyi Xu on 8/10/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeasurementTag;

@interface MeasurementCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *measurementTitle;
@property (weak, nonatomic) IBOutlet UILabel *measurementValue;


/**Measure Data Model*/
@property (nonatomic, strong) MeasurementTag *measurementTag;

@end
