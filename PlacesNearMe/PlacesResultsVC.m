//
//  PlacesResultsVC.m
//  PlacesNearMe
//
//  Created by Kaitlyn Vu on 15/08/2014.
//  Copyright (c) 2014 Kaitlyn Vu. All rights reserved.
//

#import "PlacesResultsVC.h"
#import "GoogleAPI.h"
#import "PlaceSearching.h"

@implementation PlacesResultsVC

NSMutableArray *arrPlaceSearching;
CLLocationCoordinate2D coordinate;

- (NSMutableArray *)searchPlacesFromGoogle:(NSString *)radius placeType:(NSString *)placeType keyword:(NSString *)keyword {
    NSDictionary *json = [GoogleAPI searchPlaces:coordinate radius:radius placeType:placeType keyword:keyword];
    
    return [json objectForKey:@"results"];
}

//// Return the distance
//-(NSMutableArray *)searchDistancesFromGoogle:(NSMutableArray *)arrPlaces {
//    
//    // Get origins and destinations based on coordinates
//    // Result in arrDistances
//    NSString *origins = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
//    NSString *destinations = [self getDestinations:arrPlaces];
//    
//    // Get numbers of kilometers between origins and destinations
//    NSDictionary *json = [GoogleAPI searchDistances:origins destinations:destinations];
//    
//    return [[[json objectForKey:@"rows"] objectAtIndex:0] objectForKey:@"elements"];
//    
//}
//
////_____Get all destinations from searchPlacesFromGoogle method_____
//-(NSString *)getDestinations:(NSMutableArray *)arrPlaces {
//    
//    NSString *strDestinations;
//    
//    if ([arrPlaces count] > 0) {
//        NSDictionary *geometry = [[arrPlaces objectAtIndex:0] objectForKey:@"geometry"];
//        NSDictionary *location = [geometry objectForKey:@"location"];
//        NSString *lat = [location objectForKey:@"lat"];
//        NSString *lng = [location objectForKey:@"lng"];
//        int count = [arrPlaces count];
//        
//        strDestinations = [NSString stringWithFormat:@"%@,%@", lat, lng];
//        
//        for (int i = 1; i < count; i++) {
//            geometry = [[arrPlaces objectAtIndex:i] objectForKey:@"geometry"];
//            location = [geometry objectForKey:@"location"];
//            lat = [location objectForKey:@"lat"];
//            lng = [location objectForKey:@"lng"];
//            
//            strDestinations = [NSString stringWithFormat:@"%@|%@,%@", strDestinations, lat, lng];
//        }
//    }
//    return strDestinations;
//}

// Extract results from Google data
-(NSMutableArray *)getPlaceSearching:(NSMutableArray *)arrPlaces {
    
    NSMutableArray *arrPlaceSearching = [[NSMutableArray alloc] init];
    
    if ([arrPlaces count] > 0) {
//        NSMutableArray *arrDistances = [self searchDistancesFromGoogle:arrPlaces];
        
        int count = [arrPlaces count];
        for (int i = 0; i < count; i++) {
            NSDictionary *geometry = [arrPlaces[i] objectForKey:@"geometry"];
            NSDictionary *location = [geometry objectForKey:@"location"];
            
            PlaceSearching *ps = [[PlaceSearching alloc] init];
            ps.name = [[arrPlaces objectAtIndex:i] objectForKey:@"name"];
            ps.vicinity = [[arrPlaces objectAtIndex:i] objectForKey:@"vicinity"];
            ps.latitude = [location objectForKey:@"lat"];
            ps.longitude = [location objectForKey:@"lng"];
            ps.reference = [arrPlaces[i] objectForKey:@"reference"];
            //ps.units = [[[arrDistances objectAtIndex:i] objectForKey:@"distance"] objectForKey:@"text"];
            
            [arrPlaceSearching addObject:ps];
        }
    }
    return arrPlaceSearching;
}

//___DISPLAYRESULTS_____
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrPlaceSearching.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    int row = indexPath.row;
    
    PlaceSearching *ps = [[PlaceSearching alloc] init];
    ps = arrPlaceSearching[row];
    
    // Config cell
    // Place's name
    UILabel *lblName = [self createLabel:CGRectMake(5, 5, 310, 20) font:@"Arial-BoldMT" size:17 text:ps.name];
    [cell.contentView addSubview:lblName];
    
    // Place's address
    UILabel *lblVicinity = [self createLabel:CGRectMake(5, 25, 290, 20)font:@"Arial" size:14 text:ps.vicinity];
    [cell.contentView addSubview:lblVicinity];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

// Create label for cell
-(UILabel *)createLabel:(CGRect)rect
                   font:(NSString *)font
                   size:(int)size
                   text:(NSString *)text {
    UILabel *lbl = [[UILabel alloc] initWithFrame:rect];
    [lbl setFont:[UIFont fontWithName:font size:size]];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    lbl.text = text;
    
    return lbl;
}



-(void)viewDidLoad {
    [super viewDidLoad];
    
    coordinate.latitude = -37.7392411;
    coordinate.longitude = 144.9814237;
    NSString *radius = @"5000";
    NSString *placeType = @"establishment";
    NSString *keyword = @"school";
    arrPlaceSearching =[self searchPlacesFromGoogle:radius placeType:placeType keyword:keyword];
    
    NSMutableArray *arrPlaces = [self searchPlacesFromGoogle:radius placeType:placeType keyword:keyword];
    
    arrPlaceSearching = [self getPlaceSearching:arrPlaces];
    
    for (PlaceSearching *ps in arrPlaceSearching) {
        NSLog(@"%@", ps.name);
        NSLog(@"%@", ps.vicinity);
        NSLog(@"%@,%@", ps.latitude, ps.longitude);
    }
    
    
}



@end
