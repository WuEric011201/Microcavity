//
//  MeasurementMonitor.h
//  microcavity
//
//  Created by Xiangyi Xu on 8/11/16.
//  Copyright © 2016 Xiangyi Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface MeasurementMonitor : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

SingletonH(MeasurementMonitor)

- (void)updateTags;
- (void)initmeasureItems;
- (void)updateMeasureData;

@end
