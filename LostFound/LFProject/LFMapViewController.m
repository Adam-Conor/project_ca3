//
//  LFMapViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import <Parse/Parse.h>
#import "LFMapViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface LFMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.locationManager = [[CLLocationManager alloc] init];
    //self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    //if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //[self.locationManager requestWhenInUseAuthorization];
    //}
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if(status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
    
    // Cache any current location info
    CLLocation *currentLocation = self.locationManager.location;
    
    if(currentLocation) {
        self.currentLocation = currentLocation;
    }
    
    
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    [_mapView setDelegate:self];
    
    //self.circleOverlay = nil;
     //[_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    
    //[_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    //[_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
    
    /*CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
     */
    
    
    
    //if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
    //    [self.locationManager requestWhenInUseAuthorization];
    //}
    
    //[self.locationManager requestWhenInUseAuthorization];
    
    //CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    //if(authorizationStatus == kCLAuthorizationStatusAuthorized ||
     //   authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
      //  authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
      //  NSLog(@"Here"); //test log
        
        //[self.locationManager startUpdatingLocation];
        //_MapName.showsUserLocation = YES;
    
    
    // Start location updates
    //[self.locationManager startUpdatingLocation];
    
    // Cache any current location info
    /*CLLocation *currentLocation = self.locationManager.location;
    
    if(currentLocation) {
        self.currentLocation = currentLocation;
    }
     */

    //self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude), MKCoordinateSpanMake(10, 10));
    
    //_mapView.showsUserLocation = YES;
    
    NSLog(@"latitude %+.6f, longitude %+.6f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude); //test log
    
    //}
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

/*
 * Sends user to app settings to change location servies if they wish
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}

/*- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Error: %@", [error description]);
    
    if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if (error.code == kCLErrorLocationUnknown) {
        // todo: retry?
        // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}
 */

/*
 * Runs every time the view appears
 * Log for testing purposes
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"View Appeared");
}

/*
 * Runs every time the view disappears
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"Is that LeBlanc?");
}

/*
 * Start updating users location
 * For testing location changes are logged
 */

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
        
        //mic check 1, 2
        NSLog(@"latitude %+.6f, longitude %+.6f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    }
}

/*
 * Method to check did the authorization status change
 * Alerts user to re-enable location servies
 */

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
        {
            NSLog(@"kCLAuthorizationStatusAuthorized, YEEEEERRRRRRRRRRRR");
            
            // Re-enable the post button if it was disabled before.
            //self.navigationItem.rightBarButtonItem.enabled = YES;
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"kCLAuthorizationStatusDenied");
            
            //Alert user to allow location services
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lost & Found can’t access your current location.\n\nTo view nearby listing or create a listing at your current location, turn on access for Lost & Found to your location in the Settings under Location Services." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            
            // Disable the post button.
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:break;
    }
}

/*
 * Prepare locationManager
 */

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
    
    //mic check 1, 2
    NSLog(@"latitude %+.6f, longitude %+.6f\n", _currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude);
}


/*
 * What's this for?
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
