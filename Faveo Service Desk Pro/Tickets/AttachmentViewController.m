//
//  AttachmentViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 11/06/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//

#import "AttachmentViewController.h"
#import "attachmentListShowTableCell.h"
#import "Utils.h"
#import "GlobalVariables.h"
#import "AppDelegate.h"
#import "NSData+Base64.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"

@interface AttachmentViewController ()
{
    
    NSMutableArray *selectedArray;
    GlobalVariables *globalvariable;
    NSUserDefaults *userDefaults;
    NSMutableArray *fileAttachmentArray;
    NSString *fileName;
    Utils *utils;
    
    AVPlayer *playr;
    NSString *audioData;
    
}
@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
    self.title =@"Attachments Data";
    //[[AppDelegate sharedAppdelegate] hideProgressView];
    
    globalvariable=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
    fileAttachmentArray=[[NSMutableArray alloc]init];
    utils=[[Utils alloc]init];
    fileAttachmentArray=globalvariable.attachArrayFromConversation;
    
    //  self.tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    _webView1.hidden=YES;
    
    // to set black background color mask for Progress view
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
     [SVProgressHUD dismiss];
    
}

//This method is called before the view controller's view is about to be added to a view hierarchy and before any animations are configured for showing the view.
-(void)viewWillAppear:(BOOL)animated
{
    globalvariable=[GlobalVariables sharedInstance];
    userDefaults=[NSUserDefaults standardUserDefaults];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//This method asks the data source to return the number of sections in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return fileAttachmentArray.count;
}

//// This method asks the data source for a cell to insert in a particular location of the table view.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    attachmentListShowTableCell *cell=[tableView dequeueReusableCellWithIdentifier:@"attachListShowId"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"attachmentListShowTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //  for (int i = 0; i < fileAttachmentArray.count; i++) {
    
    NSDictionary *attachDictionary=[fileAttachmentArray objectAtIndex:indexPath.row];
    
    
    //    NSString *numStr = [NSString stringWithFormat:@"%@", [attachDictionary objectForKey:@"file"]];
    
    fileName=[attachDictionary objectForKey:@"name"];
    cell.attachmentName.text=fileName;
    
    
    NSString *fileSize=[NSString stringWithFormat:@"%@",[attachDictionary objectForKey:@"size"]];
    cell.sizeLabel.text=[NSString stringWithFormat:@"%@ KB",fileSize];
    
    NSString *fileType=[attachDictionary objectForKey:@"type"];
    
    NSLog(@"File Name : %@",fileName);
    NSLog(@"File size : %@",fileSize);
    NSLog(@"File Type : %@",fileType);
    
    //    printf("File Attachemnt(base64 String) : %s\n", [numStr UTF8String]);
    
    //  }
    
    if([fileName hasSuffix:@".doc"] || [fileName hasSuffix:@".DOC"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"doc"];
    }
    else if([fileName hasSuffix:@".pdf"] || [fileName hasSuffix:@".PDF"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"pdf"];
    }
    else if([fileName hasSuffix:@".css"] || [fileName hasSuffix:@".CSS"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"css"];
    }
    else if([fileName hasSuffix:@".csv"] || [fileName hasSuffix:@".CSV"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"csv"];
    }
    else if([fileName hasSuffix:@".xls"] || [fileName hasSuffix:@".XLS"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"xls"];
    }
    else if([fileName hasSuffix:@".rtf"] || [fileName hasSuffix:@".RTF"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"rtf"];
    }
    else if([fileName hasSuffix:@".sql"] || [fileName hasSuffix:@".SQL"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"sql"];
    }
    else if([fileName hasSuffix:@".gif"] || [fileName hasSuffix:@".GIF"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"gif2"];
    }
    else if([fileName hasSuffix:@".ppt"] || [fileName hasSuffix:@".PPT"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"ppt"];
    }
    else if([fileName hasSuffix:@".jpeg"] || [fileName hasSuffix:@".JPEG"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"jpg"];
    }
    else if([fileName hasSuffix:@".docx"] || [fileName hasSuffix:@".DOCX"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"doc"];
    }
    else if([fileName hasSuffix:@".pps"] || [fileName hasSuffix:@".PPS"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"ppt"];
    }
    else if([fileName hasSuffix:@".pptx"] || [fileName hasSuffix:@".PPTX"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"ppt"];
    }
    else if([fileName hasSuffix:@".jpg"] || [fileName hasSuffix:@".JPG"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"jpg"];
    }
    else if([fileName hasSuffix:@".png"] || [fileName hasSuffix:@".PNG"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"png"];
    }
    else if([fileName hasSuffix:@".zip"] || [fileName hasSuffix:@".ZIP"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"zip"];
    }
    
    else if([fileName hasSuffix:@".ico"] || [fileName hasSuffix:@".ICO"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"ico"];
    }
    else if([fileName hasSuffix:@".txt"] || [fileName hasSuffix:@".text"] || [fileName hasSuffix:@".TEXT"] || [fileName hasSuffix:@".TXT"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"txt"];
    }
    else if([fileName hasSuffix:@".html"] || [fileName hasSuffix:@".htm"] || [fileName hasSuffix:@".htmls"] || [fileName hasSuffix:@".HTML"] || [fileName hasSuffix:@".HTM"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"html"];
    }
    else if([fileName hasSuffix:@".mp3"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"mp3"];
    }
    else if([fileName hasSuffix:@".wav"] || [fileName hasSuffix:@".aac"] || [fileName hasSuffix:@".aiff"] || [fileName hasSuffix:@".aif"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"audioCommon"];
    }
    else if([fileName hasSuffix:@".avi"]){
        cell.attachmentImage.image=[UIImage imageNamed:@"avi"];
    }
    else if([fileName hasSuffix:@".mkv"]){
        cell.attachmentImage.image=[UIImage imageNamed:@"mkv"];
    }
    else if([fileName hasSuffix:@".mov"]){
        cell.attachmentImage.image=[UIImage imageNamed:@"mov"];
    }
    else if([fileName hasSuffix:@".wmv"]){
        cell.attachmentImage.image=[UIImage imageNamed:@"wmv"];
    }
    else if([fileName hasSuffix:@".flv"]){
        cell.attachmentImage.image=[UIImage imageNamed:@"flv"];
    }
    else if([fileName hasSuffix:@".mpeg"] || [fileName hasSuffix:@".mpg"]){
        cell.attachmentImage.image=[UIImage imageNamed:@"mpeg1"];
    }
    
    else if([fileName hasSuffix:@".webm"] || [fileName hasSuffix:@".3gp"] || [fileName hasSuffix:@".vob"] || [fileName hasSuffix:@".m4p"])
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"mp4"];
    }
    
    else
    {
        cell.attachmentImage.image=[UIImage imageNamed:@"commonImage"];
    }
    
    
    return cell;
    
    
}

// This method tells the delegate that the specified row is now selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _webView1.hidden=NO;
    
    [SVProgressHUD showWithStatus:@"Loading file"];
    [_webView1 reload];
    
    NSDictionary *attachDictionary=[fileAttachmentArray objectAtIndex:indexPath.row];
    NSString *numStr = [NSString stringWithFormat:@"%@", [attachDictionary objectForKey:@"file"]];
    NSString *fileName=[attachDictionary objectForKey:@"name"];
    //  NSString *fileType=[attachDictionary objectForKey:@"type"];
    
    NSString *typeMime;
    
    if([fileName hasSuffix:@".doc"] || [fileName hasSuffix:@".DOC"])
    {
        typeMime=@"application/msword";
    }
    else if([fileName hasSuffix:@".pdf"] || [fileName hasSuffix:@".PDF"])
    {
        typeMime=@"application/pdf";
    }
    else if([fileName hasSuffix:@".css"] || [fileName hasSuffix:@".CSS"])
    {
        typeMime=@"text/css";
    }
    else if([fileName hasSuffix:@".csv"] || [fileName hasSuffix:@".CSV"])
    {
        typeMime=@"text/csv";
    }
    else if([fileName hasSuffix:@".xls"] || [fileName hasSuffix:@".XLS"])
    {
        typeMime=@"application/vnd.ms-excel";
    }
    else if([fileName hasSuffix:@".xls"] || [fileName hasSuffix:@".XLS"])
    {
        typeMime=@"application/vnd.ms-excel";
    }
    else if([fileName hasSuffix:@".rtf"] || [fileName hasSuffix:@".RTF"])
    {
        typeMime=@"text/richtext";
    }
    else if([fileName hasSuffix:@".sql"] || [fileName hasSuffix:@".SQL"])
    {
        typeMime=@"text/sql";
    }
    else if([fileName hasSuffix:@".gif"] || [fileName hasSuffix:@".GIF"])
    {
        typeMime=@"image/gif";
    }
    else if([fileName hasSuffix:@".ppt"] || [fileName hasSuffix:@".PPT"])
    {
        typeMime=@"application/mspowerpoint";
    }
    else if([fileName hasSuffix:@".jpeg"] || [fileName hasSuffix:@".JPEG"])
    {
        typeMime=@"image/jpeg";
    }
    else if([fileName hasSuffix:@".docx"] || [fileName hasSuffix:@".DOCX"])
    {
        typeMime=@"application/vnd.openxmlformats-officedocument.wordprocessingml.document";
    }
    else if([fileName hasSuffix:@".pps"] || [fileName hasSuffix:@".PPS"])
    {
        typeMime=@"application/vnd.ms-powerpoint";
    }
    else if([fileName hasSuffix:@".pptx"] || [fileName hasSuffix:@".PPTX"])
    {
        typeMime=@"application/vnd.openxmlformats-officedocument.presentationml.presentation";
    }
    else if([fileName hasSuffix:@".jpg"] || [fileName hasSuffix:@".JPG"])
    {
        typeMime=@"image/jpg";
    }
    else if([fileName hasSuffix:@".png"] || [fileName hasSuffix:@".PNG"])
    {
        typeMime=@"image/png";
    }
    else if([fileName hasSuffix:@".bmp"] || [fileName hasSuffix:@".BMP"] ||  [fileName hasSuffix:@".bm"])
    {
        typeMime=@"image/bmp";
    }
    else if([fileName hasSuffix:@".ico"] || [fileName hasSuffix:@".ICO"])
    {
        typeMime=@"image/x-icon";
    }
    else if([fileName hasSuffix:@".txt"] || [fileName hasSuffix:@".text"] || [fileName hasSuffix:@".TEXT"] || [fileName hasSuffix:@".TXT"])
    {
        typeMime=@"text/plain";
    }
    else if([fileName hasSuffix:@".c"] || [fileName hasSuffix:@".c++"] || [fileName hasSuffix:@".C"] || [fileName hasSuffix:@".C++"] || [fileName hasSuffix:@".com"] || [fileName hasSuffix:@".conf"] || [fileName hasSuffix:@".cxx"])
    {
        typeMime=@"text/plain";
    }
    else if([fileName hasSuffix:@".def"] || [fileName hasSuffix:@".f90"] || [fileName hasSuffix:@".for"] || [fileName hasSuffix:@".h"] || [fileName hasSuffix:@".hh"] || [fileName hasSuffix:@".idc"] || [fileName hasSuffix:@".jav"] ||[fileName hasSuffix:@".java"] || [fileName hasSuffix:@".list"] || [fileName hasSuffix:@".m"] || [fileName hasSuffix:@".mar"] || [fileName hasSuffix:@".lst"] || [fileName hasSuffix:@".log"])
    {
        typeMime=@"text/plain";
    }
    else if([fileName hasSuffix:@".html"] || [fileName hasSuffix:@".htm"] || [fileName hasSuffix:@".htmls"] || [fileName hasSuffix:@".HTML"] || [fileName hasSuffix:@".HTM"] || [fileName hasSuffix:@".htx"])
    {
        typeMime=@"text/html";
    }
    else if([fileName hasSuffix:@".class"])
    {
        typeMime=@"application/java";
    }
    else
    {
        NSLog(@"I M in else condition.!");
        
    }
    
     [SVProgressHUD dismiss];
    
    if([fileName hasSuffix:@".mp3"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:audio/mp3;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
       
        
        
    }
    else if([fileName hasSuffix:@".wav"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:audio/wav;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
       
        
    }
    else if([fileName hasSuffix:@".aac"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:audio/aac;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
       
        
    }
    //    else if([fileName hasSuffix:@".m3u"])
    //    {
    //        NSURL *URL = [NSURL URLWithString:
    //                      [NSString stringWithFormat:@"data:audio/x-mpegurl;base64,%@",
    //                       numStr]];
    //
    //        //   NSURL *url = [NSURL URLWithString:URL];
    //        [_webView loadRequest:[NSURLRequest requestWithURL:URL]];
    //
    //    }
    else if([fileName hasSuffix:@".aiff"] || [fileName hasSuffix:@".aif"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:audio/aiff;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
       
        
    }
    
    
    else if([fileName hasSuffix:@".m4p"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:audio/m4p;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
    
        
    }
    
    
    
    // video srtarts
    else if([fileName hasSuffix:@".avi"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/avi;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
       
        
    }
    
    else if([fileName hasSuffix:@".mpeg"] || [fileName hasSuffix:@".mpg"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/x-mpeg2a;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
        
        
    }
    else if([fileName hasSuffix:@".mkv"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/mkv;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
        
        
    }
    else if([fileName hasSuffix:@".flv"]) //application/metastream
    { //video/x-msvideo
        
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/x-msvideo;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];

        
    }
    else if([fileName hasSuffix:@".wmv"])
    {  //video/x-ms-wmv
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/x-ms-wmv;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
        
    }
    
    else if([fileName hasSuffix:@".webm"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:multipart/form-data;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
        
        
    }
    
    else if([fileName hasSuffix:@".3gp"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:multipart/form-data;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];

        
    }
    else if([fileName hasSuffix:@".vob"]) //video/mpeg //video/dvd
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:multipart/form-data;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
       
        
    }
    else if([fileName hasSuffix:@".mp4"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/mp4;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
        
        
    }
    else if([fileName hasSuffix:@".mov"])
    {
        NSURL *URL = [NSURL URLWithString:
                      [NSString stringWithFormat:@"data:video/quicktime;base64,%@",
                       numStr]];
        
        //   NSURL *url = [NSURL URLWithString:URL];
        [_webView1 loadRequest:[NSURLRequest requestWithURL:URL]];
        
        
    }
    
    else if([fileName hasSuffix:@".zip"] || [fileName hasSuffix:@".ZIP"])
    {
        [utils showAlertWithMessage:NSLocalizedString(@"This file format is not supported for mobile device.", nil) sendViewController:self];
       
    }
    
    else{
        
        //    [utils showAlertWithMessage:NSLocalizedString(@"This file format is not supported for mobile device.", nil) sendViewController:self];
        // dataFromBase64String from NSData+Base64.h file
        NSData* myData = [NSData dataFromBase64String: numStr];
        
        [_webView1 loadData:myData
         //MIMEType:@"application/pdf"
                  MIMEType:typeMime
          textEncodingName:@"NSUTF8StringEncoding"
                   baseURL:[NSURL URLWithString:@"https://www.google.co.in/"]];
        [SVProgressHUD dismiss];
        
        
    }
    
    // zoom karnya sathi
    _webView1.scalesPageToFit = YES;
    _webView1.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.view addSubview:_webView1];
    _webView1.mediaPlaybackRequiresUserAction = NO;
    
    //  [[AppDelegate sharedAppdelegate] hideProgressView];
}




@end
