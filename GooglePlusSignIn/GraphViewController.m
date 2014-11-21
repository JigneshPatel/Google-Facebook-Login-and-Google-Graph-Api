//
//  GraphViewController.m
//  GooglePlusSignIn
//
//  Created by Ashish Pisey on 9/4/14.
//  Copyright (c) 2014 com.AshishPisey. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()
{
    UIImage *_chartImage;
}
@end

@implementation GraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Get Degrees from database, store them in an array of NSNumbers
   // ...
    
    
    [self test];
    
}

-(void)test{
    
    NSString* title = @"Height History";
    NSArray *axisXLabels = [NSArray arrayWithObjects:
                            @"Jan",
                            @"Feb",
                            @"Mar",
                            @"Jun",
                            @"Jul",
                            @"Aug",
                            nil];

    NSString *chartType;
    NSString *lc = @"lc";
    NSString *p = @"p";
    NSString *p3 = @"p3";
    NSString *pc = @"pc";
    
    NSArray *axisYLabels = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:50],
                            [NSNumber numberWithInt:150],
                            [NSNumber numberWithInt:200],
                            nil];
    
    NSArray *dataValues = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:130],
                           [NSNumber numberWithInt:140],
                           [NSNumber numberWithInt:140],
                           [NSNumber numberWithInt:150],
                           [NSNumber numberWithInt:170],
                           [NSNumber numberWithInt:180],
                           nil];
    
    NSString *lineColor = @"FF99FF";
    
    NSNumber *width = [NSNumber numberWithInt:300];
    
    NSNumber *hight = [NSNumber numberWithInt:200];
    
    NSNumber *minScale = [NSNumber numberWithInt:0];
    
    NSNumber *maxScale = [NSNumber numberWithInt:200];
    
    NSString *legendLabel = @"cm";
    
    chartType = lc;
    UIImage *barGraphImage =[self produceGoogleChartImage:title xAxis:axisXLabels yAxis:axisYLabels andData:dataValues color:lineColor
                                         chartWidth:width chartHight:hight chartType:chartType lagendLabel:legendLabel minScale:minScale maxScale:maxScale];
    self.graphImgViw.image = barGraphImage;

    chartType = p3;
    
    UIImage *pieImage = [self produceGoogleChartImage:title xAxis:axisXLabels yAxis:axisYLabels andData:dataValues color:lineColor chartWidth:width chartHight:hight chartType:chartType lagendLabel:legendLabel minScale:minScale maxScale:maxScale];
    
    self.pieImageView.image = pieImage;
    
}



-(UIImage *)produceGoogleChartImage:(NSString*)title
                              xAxis:(NSArray*)axisXLabels
                              yAxis:(NSArray*)axisYLabels
                            andData:(NSArray*)dataValues
                              color:(NSString*)lineColor
                         chartWidth:(NSNumber*)width
                         chartHight:(NSNumber*)hight
                          chartType:(NSString*)chartType
                        lagendLabel:(NSString*)legend
                           minScale:(NSNumber*)minScale
                           maxScale:(NSNumber*)maxScale{
    
    NSMutableString *myurl = [NSMutableString stringWithString:@"http://chart.googleapis.com/chart?chxl=0:|"];
    
    
    //axisXLabels
    int countAxisXLabels = [axisXLabels count];
    
    for(NSUInteger i = 0; i < countAxisXLabels; ++i)
    {
        NSNumber *value = [axisXLabels objectAtIndex:i];
        [myurl appendFormat:@"%@", value];
        if(i < countAxisXLabels - 1)
            [myurl appendString:@"|"];
    }
    
    [myurl appendString:@"|1:|"];
    
    
    //axisYLabels
    int countAxisYLabels = [axisYLabels count];
    for(NSUInteger i = 0; i < countAxisYLabels; ++i)
    {
        NSNumber *value = [axisYLabels objectAtIndex:i];
        [myurl appendFormat:@"%@", value];
        if(i < countAxisYLabels - 1)
            [myurl appendString:@"|"];
    }
    
    [myurl appendString:@"&chxr=0,0,105|1,3.333,100&chxt=x,y&chs="];
    
    //size
    [myurl appendFormat:@"%@x%@&cht=%@&chd=t:", width,hight,chartType];
    
    //dataValues
    int countDataValues = [dataValues count];
    
    for(NSUInteger i = 0; i < countDataValues; ++i)
    {
        NSNumber *value = [dataValues objectAtIndex:i];
        [myurl appendFormat:@"%@", value];
        if(i < countDataValues - 1)
            [myurl appendString:@","];
    }
    
    //legend
    [myurl appendFormat:@"&chdl=%@&chg=25,50&chls=2&",legend];
    
    //color
    [myurl appendFormat:@"chm=o,%@,0,-2,8&chco=%@",lineColor,lineColor];
    
    //title
    [myurl appendFormat:@"&chtt=+%@",title];
    
    //scale
    [myurl appendFormat:@"&chds=%@,%@",minScale,maxScale];
    
    
    
    NSString *theurl=[myurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:theurl]
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    NSURLResponse* response;
    NSError* error;
    NSData *imageData=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&response
                                                        error:&error]; NSLog(@"%@",error); NSLog(@"%@",response); NSLog(@"%@",imageData);
    
    UIImage *myimage = [[UIImage alloc] initWithData:imageData];
    
    
    return myimage;
    
    // Chart Wizard: https://developers.google.com/chart/image/docs/chart_wizard
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
