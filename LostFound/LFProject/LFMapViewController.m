//
//  LFMapViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 02/03/2015.
//
//

#import "LFMapViewController.h"
#import "LFMapListingViewController.h"
#import "ListingAnnotation.h"

@interface LFMapViewController ()


@property (nonatomic, strong) NSString *objectPressed;

@end

@implementation LFMapViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_mapView setDelegate:self];
    
    /* Caters for iOS7 */
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
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    
    /* Cache any current location info */
    CLLocation *currentLocation = _locationManager.location;
    
    if(currentLocation) {
        _currentLocation = currentLocation;
    }
    
    /* Show user location with blue dot */
     _mapView.showsUserLocation = YES;
    
    /* Open map on user */
    CLLocationCoordinate2D coord = {currentLocation.coordinate.latitude, currentLocation.coordinate.longitude};
    MKCoordinateSpan span = {.latitudeDelta =  1, .longitudeDelta =  1};
    MKCoordinateRegion region = {coord, span};
    [_mapView setRegion:region];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
    PFGeoPoint *loc = [PFGeoPoint geoPointWithLatitude:53.34877256273858 longitude:-6.259341214407965];
    PFQuery* locationQuery = [PFQuery queryWithClassName:@"Listing"];
    [locationQuery whereKey:@"location" nearGeoPoint:loc withinKilometers:500];
    [locationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) { //found match
            for (PFObject *listing in objects) {
                
                PFGeoPoint *listingPoint = [listing objectForKey:@"location"];
                
                ListingAnnotation *geoPointAnnotation = [[ListingAnnotation alloc]
                                                         init];
                geoPointAnnotation.title = [listing objectForKey:@"title"];
                geoPointAnnotation.subtitle = [listing objectForKey:@"status"];
                geoPointAnnotation.objectID = listing.objectId;
                //NSLog(@"%@",geoPointAnnotation.objectID);
                geoPointAnnotation.coordinate = CLLocationCoordinate2DMake(listingPoint.latitude, listingPoint.longitude);
                [self.mapView addAnnotation:geoPointAnnotation];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/* Update user's updated location */
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.mapView.centerCoordinate = userLocation.location.coordinate;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    static NSString *defaultPinID = @"identifier";
    pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    else{
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.pinColor = MKPinAnnotationColorRed;  //or Green or Purple
        
        pinView.enabled = YES;
        pinView.canShowCallout = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        //Accessoryview for the annotation view in ios.
        pinView.rightCalloutAccessoryView = btn;
        return pinView;
    }
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    
    [self performSegueWithIdentifier:@"showListing" sender:view.annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showListing"])
    {
        ListingAnnotation *anno = (ListingAnnotation *) sender;
        LFMapListingViewController *mp = [segue destinationViewController];
        mp.objectPressed = anno.objectID;
    }

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

/*
 * Runs every time the view appears
 * Starts updating location again
 */

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingLocation];
}

/*
 * Runs every time the view disappears
 * Stops updating location as not necessary
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

/*
 * Start updating users location
 */

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
    }
}

/*
 * Method to check did the authorization status change
 * Alerts user to re-enable location servies
 */

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse");
            
            /* Permission granted. Start updating location */
            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"kCLAuthorizationStatusDenied");
            
            /* Permission denied. Alert user to re-enable location servies */
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Lost & Found can’t access your current location.\n\nTo view nearby listing or create a listing at your current location, turn on access for Lost & Found to your location in the Settings under Location Services."
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
            
            [alertView show];
        }
            break;
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted: {
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

/* Changes location */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    self.currentLocation = newLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
