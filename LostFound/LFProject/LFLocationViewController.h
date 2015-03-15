//
//  LFLocationViewController.h
//  LostFound
//
//  Created by Adam O'Flynn on 14/03/2015.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface LFLocationViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *locationView;
@property (strong, nonatomic) MKPointAnnotation *listingLoc;

@end
