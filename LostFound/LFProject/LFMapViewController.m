//
//  LFMapViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import "LFMapViewController.h"

@interface LFMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation LFMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mapView setDelegate:self];
    
    /* Caters for iOS7 I think */
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    /* Check if denied from location servies */
    if (status == kCLAuthorizationStatusDenied) {
        NSString *title = @"Location services are off for this app";
        NSString *message = @"To use background location you must turn on 'While Using the App in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    
    /* Check to see if user has ever authorized */
    if(status == kCLAuthorizationStatusNotDetermined) {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    
    /* Cache any current location info */
    CLLocation *currentLocation = self.locationManager.location;
    
    if(currentLocation) {
        self.currentLocation = currentLocation;
    }
    
     _mapView.showsUserLocation = YES;
    
    CLLocationCoordinate2D coord = {currentLocation.coordinate.latitude, currentLocation.coordinate.longitude};
    MKCoordinateSpan span = {.latitudeDelta =  1, .longitudeDelta =  1};
    MKCoordinateRegion region = {coord, span};
    [_mapView setRegion:region];
    
    
    //gonna use this to mark listings on the map. ***Watch this space****
    /*CLLocationCoordinate2D listing;
    listing.latitude = 0;
    listing.longitude = 0;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:listing];
    [annotation setTitle:@"Title"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
     */

    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
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
