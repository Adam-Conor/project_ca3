//
//  Listing.h
//  LostFound
//
//  Created by Adam O'Flynn on 10/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Listing : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) PFGeoPoint *location;


@end
