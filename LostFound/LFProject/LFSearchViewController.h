//
//  LFSearchViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 28/02/2015.
//
//

#import <UIKit/UIKit.h>

@class LFSearchViewController;

@protocol LFSearchViewControllerDelegate <NSObject>

- (void)presentSearchViewController:(LFSearchViewController *)controller;

@end

@interface LFSearchViewController : UIViewController <UITableViewDelegate>

@property  (nonatomic, weak )id<LFSearchViewControllerDelegate> delegate;


@end