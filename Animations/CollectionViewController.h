//
//  CollectionViewController.h
//  Animations
//
//  Created by Oleg Trakhman on 1/10/14.
//  Copyright (c) 2014 animations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UICollectionViewController
{
    NSArray *cellImages;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@end
