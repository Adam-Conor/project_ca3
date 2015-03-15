//
//  LFCategoriesViewController.m
//  LostFound
//
//  Created by Adam O'Flynn on 10/03/2015.
//
//

#import "LFCategoriesViewController.h"
#import "LFCreateListingViewController.h"
#import "Listing.h"

@interface LFCategoriesViewController ()

@end

static NSString *cat;

@implementation LFCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.tag = indexPath.row;
    switch (cell.tag) {
        case 0:
            cat = @"animals";
            self.category = cat;
            //NSLog(self.category);
            //[self performSegueWithIdentifier:@"sendData" sender:self];
            break;
        case 1:
            cat = @"clothing";
            self.category = cat;
            break;
        case 2:
            cat = @"jewellery";
            self.category = cat;
            break;
        case 3:
            cat = (@"tickets");
            self.category = cat;
            break;
        case 4:
            cat = (@"other");
            self.category = cat;
            break;
        case 5:
            cat = (@"electronics");
            self.category = cat;
            break;
        case 6:
            cat = (@"personal");
            self.category = cat;
            break;
        default:
            break;
    }
}
- (IBAction)sendData:(id)sender {
    NSLog(cat);
    self.category = cat;
    [self performSegueWithIdentifier:@"sendData" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[LFCreateListingViewController class]]) {
            LFCreateListingViewController *mainViewConroller = segue.destinationViewController;
            if (self.category) {
                NSLog(self.category);
                mainViewConroller.category = self.category;
            }
            else{
                mainViewConroller.category = @"";
                NSLog(self.category);
            }
    }
    
}


@end
