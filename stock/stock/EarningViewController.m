//
//  EarningViewController.m
//  stock
//
//  Created by daniel on 4/23/15.
//  Copyright (c) 2015 DK. All rights reserved.
//


/* one tr sample:
 <tr>
 <td>
 <a href="http://www.nasdaq.com/symbol/tgt/premarket" title="Pre-market Quotes"><img src="http://www.nasdaq.com/images/weather_sun.jpg" alt="Pre-Market Quotes" height="16" width="16"></a>
 </td>
 <td>
 <a id="two_column_main_content_CompanyTable_companyname_5" href="http://www.nasdaq.com/earnings/report/tgt">Target Corporation (TGT) <br/><b>Market Cap: $46.52B</b></a>
 </td>
 <td>
 11/18/2015
 </td>
 <td>
 Oct 2015
 </td>
 <td>
 $0.86
 </td>
 <td>
 12
 </td>
 <td style="">
 11/19/2014
 </td>
 <td>
 $0.54
 </td>
 <td style="display:none">
 <span style='color:green'>Met</span>
 </td>
 </tr>
 */
#import "EarningViewController.h"
#import "TFHpple.h"
#import "ERModel.h"
#import "EarningTableViewCell.h"

#import "UIImageView+AFNetworking.h"
#import "StockDetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

#import "DKNightVersion.h"

#import "UIImage+Tint.h"

static NSString *kStyledActiveCellIdentifier = @"StyledActiveProgressiveGridCell";

#define TICK    NSDate *methodStart = [NSDate date];
#define TOCK    NSLog(@"executionTime = %f", [[NSDate date] timeIntervalSinceDate:methodStart]);

@interface EarningViewController () <UITableViewDataSource, UITableViewDelegate, EarningTableViewCellDelegate>

//@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateField;
@property (nonatomic, strong) UITableView *ERtableView;
@property (nonatomic, copy) NSArray *rows;
@property (nonatomic, copy) NSMutableArray *ERModelRows;
@property (nonatomic, copy) NSArray *sortedArray;
@property (nonatomic, assign, getter=isSortedByCap) BOOL sortedByCap;


@property (nonatomic, copy) NSArray *tableViewRows;

@end

@implementation EarningViewController

- (void)loadView {
    [super loadView];
//    self.refreshButton = [[UIButton alloc] init];
//    [self.view addSubview:self.refreshButton];
    
    self.dateField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.dateField.borderStyle = UITextBorderStyleRoundedRect;
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MMM-dd"]; //@"dd/MMM/YYYY hh:min a"];
    self.dateField.placeholder = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    [self.view addSubview:self.dateField];
    
    self.ERtableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.ERtableView.delegate = self;
    self.ERtableView.dataSource = self;
    self.ERtableView.separatorColor = [UIColor lightGrayColor];
    self.ERtableView.separatorInset = UIEdgeInsetsMake(0, -7, 0, 0);
    self.ERtableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.ERtableView registerClass:[EarningTableViewCell class] forCellReuseIdentifier:kStyledActiveCellIdentifier];

    // iOS 8 or later
    self.ERtableView.rowHeight = UITableViewAutomaticDimension;
    self.ERtableView.estimatedRowHeight = 64;
//    self.ERtableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.ERtableView];
    
    //
    _sortedByCap = NO;

    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        self.view.normalBackgroundColor = [UIColor whiteColor];
        self.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        self.ERtableView.normalBackgroundColor = [UIColor whiteColor];
        self.ERtableView.nightBackgroundColor = UIColorFromRGB(0x343434);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
    UIView *statusBarView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:statusBarView];
    
    self.dateField.frame = CGRectMake(0, rect.size.height, self.view.bounds.size.width, 44);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.ERtableView.frame = CGRectMake(0, rect.size.height + 44, self.view.bounds.size.width, self.view.bounds.size.height - statusBarView.frame.size.height - self.dateField.frame.size.height);
    // inset just make it show down 20, but when scroll it, cell could scroll to 0.
    self.ERtableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 49.0f, 0.0f);
    
    _datePicker = [[UIDatePicker alloc]init];
    _datePicker.datePickerMode=  UIDatePickerModeDate;
    [self.dateField setInputView:_datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:cancelBtn, space, doneBtn, nil]];
    [self.dateField setInputAccessoryView:toolBar];

    // fetch and show datay
    [self reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // hidden navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - public 
- (void)reloadData {
    [self fetchDataWithDate:self.dateField.text == nil?self.dateField.placeholder : self.dateField.text];
}

# pragma mark - private

- (void)fetchData {
    NSURLSession *session = [NSURLSession sharedSession];
    
    // http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=2015-Oct-21
    // @"https://itunes.apple.com/search?term=apple&media=software"
    // http://chuansong.me/account/bigcompany007
    
    // handle local html file
    NSURL *htmlPath = [[NSBundle mainBundle] URLForResource:@"oct_23" withExtension:@"html"];
    NSString*stringPath = [htmlPath absoluteString]; //this is correct
    
    //you can again use it in NSURL eg if you have async loading images and your mechanism
    //uses only url like mine (but sometimes i need local files to load)
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringPath]];
//    UIImage *ready = [[[UIImage alloc] initWithData:data] autorelease];
    
    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:@"http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=2015-Oct-23"] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
        NSArray *elements  = [doc searchWithXPathQuery:@"//table[@class='USMN_EarningsCalendar']"];
        
        // handle no earning report day (elements == 0)
        if ( [elements count]!=0 ) {
            NSArray *arr = [elements[0] searchWithXPathQuery:@"//tr"];  // arr how many ER on this day.
            self.rows = arr;
        } else {
            self.rows = nil;
        }

        //convert raw data to model
        
        _ERModelRows = [NSMutableArray array];
        for (TFHppleElement *element in _rows) {
            ERModel *erModel = [[ERModel alloc] initWithHTMLTFHppleElement:element];
            // first item is row of title
            [_ERModelRows addObject:erModel];
        }

//        NSLog(@"String sent from server %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ERtableView reloadData];
        });
//    }];
//    
//    [dataTask resume];  // important
}

- (void)fetchDataWithDate:(NSString *)date {
    NSURLSession *session = [NSURLSession sharedSession];
    
    // http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=2015-Oct-21
    // @"https://itunes.apple.com/search?term=apple&media=software"
    // http://chuansong.me/account/bigcompany007
    
//    select * from html where url="http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=2015-Oct-21" and xpath='//table[@class="USMN_EarningsCalendar"]'
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.nasdaq.com/earnings/earnings-calendar.aspx?date=%@", date];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedFailureReason] message:[error localizedRecoverySuggestion] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
        NSString *queryString = @"//table[@class='USMN_EarningsCalendar']";
        NSArray *elements  = [doc searchWithXPathQuery:queryString];
        
        // handle no earning report day (elements == 0)
        if ([elements count] != 0) {
            NSArray *arr = [elements[0] searchWithXPathQuery:@"//tr"];  // arr how many confirmed ER on this day.
            self.rows = arr;
        } else {
            self.rows = nil;
        }
        
        //convert raw data to model
        
        _ERModelRows = [NSMutableArray array];
        for (TFHppleElement *element in _rows) {
            ERModel *erModel = [[ERModel alloc] initWithHTMLTFHppleElement:element];
            // first item is row of title
            [_ERModelRows addObject:erModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // _sortedArray might be empty since async
            [self.ERtableView reloadData];
        });
        
        _sortedArray = [[NSArray alloc] init];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            NSArray *sortedArray;
            _sortedArray = [_ERModelRows sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [(ERModel*)a marketCap];
                NSString *second = [(ERModel*)b marketCap];
                // p, M, B, a
                
                NSString *firstSymbol = [first substringFromIndex: [first length] - 1];
                NSString *secondSymbol = [second substringFromIndex: [second length] - 1];
                NSString *firstNumber = [first substringFromIndex: 1];
                NSString *secondNumber = [second substringFromIndex: 1];

                if ( [firstSymbol isEqualToString:@"p"] || [secondSymbol isEqualToString:@"p"]) {
                    return NSOrderedAscending;
                } else {
                    if ([firstSymbol isEqualToString:secondSymbol]) {
                        return [firstNumber floatValue] < [secondNumber floatValue];
                    }
                    return [firstSymbol compare:secondSymbol];
                }
            }];
            if (_sortedByCap) {
                [_ERtableView reloadData];
            }
        });
        
        // Invalidate Session
        [session finishTasksAndInvalidate];
    }];
    
    [dataTask resume];
}

# pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortedByCap?[self.sortedArray count]:[self.ERModelRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[EarningTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ERModel *modelItem = _sortedByCap?[self.sortedArray objectAtIndex:indexPath.row]:[self.ERModelRows objectAtIndex:indexPath.row];
    // TODO: enhance here, cell scroll lagging since image from url. -- Done!
    if (modelItem.timeImgUrlString.length > 0) {
//        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:modelItem.timeImgUrlString]]];
        if ([modelItem.timeImgUrlString isEqualToString:@"http://www.nasdaq.com/images/weather_sun.jpg"]) {
//            UIImage *image = [UIImage imageNamed:@"weather_sun.jpg"];
//            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            UIGraphicsBeginImageContext(rect.size);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            CGContextClipToMask(context, rect, image.CGImage);
//            CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
//            CGContextFillRect(context, rect);
//            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            cell.leftImageView.image = img;
            cell.leftImageView.image = [UIImage imageNamed:@"summer"];
        } else if ([modelItem.timeImgUrlString isEqualToString:@"http://www.nasdaq.com/images/half_moon.jpg"]) {
            cell.leftImageView.image = [UIImage imageNamed:@"night"];
        } else {
            cell.leftImageView.image = [UIImage imageNamed:@"estimate_zack"];
        }
    } else {
        cell.leftImageView.image = [UIImage imageNamed:@"USDollar-25"];
    }
    [cell.leftImageView sizeToFit];
    
    cell.titleLabel.text = modelItem.name;
    cell.rightTitle.text = modelItem.marketCap;
    
//     scroll cell cause lag, do it async, or using SDWebImage 
////     http://stackoverflow.com/questions/14579079/slow-loading-the-images-from-url-in-uitableview
    dispatch_async(dispatch_get_main_queue(), ^{
//        cell.subImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.nasdaq.com//charts/%@_smallrm.jpeg",modelItem.NASDAQSymbol]]]];
        if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNight) {
            [cell.subImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.nasdaq.com//charts/%@_smallrm.jpeg",modelItem.NASDAQSymbol]] placeholderImage:nil];
            cell.subImageView.image = [cell.subImageView.image imageWithGradientTintColor:UIColorFromRGB(0xc3c3c3)];//UIColorFromRGB(0x343434)];
        } else {
            [cell.subImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.nasdaq.com//charts/%@_smallrm.jpeg",modelItem.NASDAQSymbol]] placeholderImage:nil];
        }
        // TODO: change image background to clearColor
//        cell.subImageView.image = [yourImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    });
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.toggle.hidden = NO;
        cell.toggle.on = _sortedByCap;
        cell.toggleText.hidden = NO;
        cell.delegate = self;
    } else {
        
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return;
    
    ERModel *modelItem = _sortedByCap?[self.sortedArray objectAtIndex:indexPath.row]:[self.ERModelRows objectAtIndex:indexPath.row];

    StockDetailViewController *detailVC = [[StockDetailViewController alloc] initWithNASDAQSymbol:modelItem.NASDAQSymbol];
    detailVC.title = modelItem.name;
//    detailVC.fd_interactivePopDisabled = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
//    UINavigationController *navController = self.navigationController;
//    [self.view removeFromSuperview];
//    [self.view addSubview:navController.view];
    
    // Pop this controller and replace with another
//    [navController popViewControllerAnimated:NO];//not to see pop
    
//    [navController pushViewController:detailVC animated:YES];//to see push or u can change it to not to see.
}

//This function is where all the magic happens
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    //!!!FIX for issue #1 Cell position wrong------------
    if(cell.layer.position.x != 0){
        cell.layer.position = CGPointMake(0, cell.layer.position.y);
    }
    
    //4. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
}

//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 85.0;
//}

# pragma mark - date text field

- (void)ShowSelectedDate {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MMM-dd"]; //@"dd/MMM/YYYY hh:min a"];
    self.dateField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:_datePicker.date]];
    [self.dateField resignFirstResponder];
    
    // update tableview based on selected date
    [self fetchDataWithDate:self.dateField.text];
}

- (void)cancel {
    [self.dateField resignFirstResponder];
}

# pragma mark - EarningTableViewCellDelegate

- (void)reloadEarningTableView:(EarningTableViewCell *)cell {
    NSLog(@"successfully to table view controller from cell");
    self.ERModelRows = [_sortedArray mutableCopy];
    _sortedByCap = YES;
    [self.ERtableView reloadData];
}

-(void)reloadEarningTableViewBySwitch:(id)sender {
    UISwitch *onoff = (UISwitch *)sender;
    if (onoff.on) {
        _sortedByCap = YES;
    } else {
        _sortedByCap = NO;
    }
    // TODO: add circle animation on sorted button.
    
//    let center = self.view.convertPoint(center, fromView: settings.view)
//    self.view.animateCircularWithDuration(0.5, center: center, animations: {
//        self.theme = darkside ? .dark : .light
//    })
//    CGPoint test = self.ERtableView convertPoint(darkSideSwitch.center, fromView: darkSideSwitch.superview)
//    CGPoint center = [self.view convertPoint:onoff.center fromView:self.view];
//    [self.view animateCircularWithDuration:0.5 center:center animations:nil];
    
    [self.ERtableView reloadData];
}


@end
