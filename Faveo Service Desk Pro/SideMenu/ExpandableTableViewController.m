//
//  ExpandableTableViewController.m
//  Faveo Service Desk Pro
//
//  Created by Mallikarjun on 03/08/18.
//  Copyright © 2018 Ladybird Web Solution Pvt Ltd. All rights reserved.
//



#import "ExpandableTableViewController.h"
#import "ExpandableTableViewCell.h"
#import "SWRevealViewController.h"
#import "MyTickets.h"
#import "UnassignedTickets.h"
#import "ClosedTickets.h"
#import "TrashTickets.h"
#import "UnApprovedTickets.h"
#import "AboutUsViewController.h"
#import "ClientListViewController.h"
#import "TestingView.h"
#import "LoginViewController.h"
#import "CreateTicketView.h"
#import "InboxTickets.h"
#import "RMessage.h"
#import "RMessageView.h"
#import "ProblemList.h"
#import "CreateProblem.h"
#import "UIImageView+Letters.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalVariables.h"
#import "ChangeList.h"
#import "CreateChange.h"

@interface ExpandableTableViewController ()<RMessageProtocol>
{
     NSUserDefaults *userDefaults;
     GlobalVariables *globalVariables;
}


@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;

@end

@implementation ExpandableTableViewController
{
    NSArray *arr;
}
NSUInteger g_ExpandedCellIndex = 0;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    //SideBar specific initialisation
    [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self setTableView];
    [self setProfileImage];
    
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    globalVariables=[GlobalVariables sharedInstance];
    
    //
    //select the data.plist as per the language set for the app
    NSDictionary *dict=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"enData" ofType:@"plist"]];
    self.items=[dict valueForKey:@"Items"];
    self.itemsInTable=[[NSMutableArray alloc] init];
    [self.itemsInTable addObjectsFromArray:self.items];
}

- (void) setTableView {
    //UIColor patternColor =  [UIColor colorWithPatternImage:image]. Then you apply this as the background color of the view. [someView setBackgroundColor:patternColor];
    UIImage *bgImage = [UIImage imageNamed:@"Background"];
    UIColor *patternColor = [UIColor colorWithPatternImage:bgImage];
    self.tableView.backgroundColor = patternColor;
    self.headerView.backgroundColor = patternColor;
    
    self.tableView.separatorColor = [UIColor blackColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void) setProfileImage {
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    // self.profileImageView.layer.borderWidth = 3.0f;
    //  self.profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    if([[userDefaults objectForKey:@"profile_pic"] hasSuffix:@".jpg"] || [[userDefaults objectForKey:@"profile_pic"] hasSuffix:@".jpeg"] || [[userDefaults objectForKey:@"profile_pic"] hasSuffix:@".png"] )
    {
        [_profileImageView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"profile_pic"]]
                              placeholderImage:[UIImage imageNamed:@"default_pic.png"]];
    }else
    {
        //   NSString * name = [NSString];
        NSString * name = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"profile_name"]];
        [_profileImageView setImageWithString:[name substringToIndex:1] color:nil ];
    }
    
    
    
    _userNameLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"profile_name"]];
    _userEmailLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"userEmail"]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *Title= [[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"Name"];
    //NSString *CellIdentifier= [[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"id"];
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [self createCellWithTitle:Title cellId:CellIdentifier imageName:[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"image"] indexPath:indexPath];
    
    //    ExpandableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // cell.backgroundColor = TOP_HEADER_BG;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //check if the row at indexPath is a child of an expanded parent.
    //At a time only one parent would be in expanded state
    NSInteger indexSelected = indexPath.row;
    NSDictionary *dicSelected  =[self.itemsInTable objectAtIndex:indexSelected];
    /**
     Resolved the issue of top line separator dissapearing upon selecting a row (hackishly) by reloading the selected cell
     */
    @try {
        [self.menuTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    @catch (NSException *exception) {
    }
    
    [tableView setSectionIndexBackgroundColor:[UIColor blackColor]];
    //
    //Collapse any other expanded cell by iterating through the table cells.
    //Don't collapse if the selected cell is a child of an expanded row.
    NSDictionary *dicCellToCollapse  =[self.itemsInTable objectAtIndex:g_ExpandedCellIndex];
    NSInteger numRowsCollapsed = 0;
    NSInteger level = [[dicSelected valueForKey:@"level"] integerValue];
    
    if(level==0 && [dicCellToCollapse valueForKey:@"SubItems"] && (g_ExpandedCellIndex != indexPath.row))
    {
        NSArray *arr=[dicCellToCollapse valueForKey:@"SubItems"];
        BOOL isTableExpanded=NO;
        
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        //
        //Collapse the parent cell if its expanded
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
            numRowsCollapsed = [arr count]-1;
        }
    }
    
    //
    //go about the task of expanding the cell if it has subitems
    NSDictionary *dic;
    if (g_ExpandedCellIndex < indexPath.row && numRowsCollapsed)
    {
        dic = [self.itemsInTable objectAtIndex:indexPath.row-numRowsCollapsed-1];
    }
    else
    {
        dic = [self.itemsInTable objectAtIndex:indexPath.row];
        
    }
    
    
    
    //
    //Check if the selected cell has SubItems i.e its a Parent cell
    if([dic valueForKey:@"SubItems"])
    {
        arr=[dic valueForKey:@"SubItems"];
        BOOL isTableExpanded=NO;
        
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        //
        //Collapse the parent cell if its expanded
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        //
        //Else expand the cell to show SubItems
        else
        {
            //
            //store the location of the cell that is expanded
            NSUInteger rowIndex;
            if (g_ExpandedCellIndex < indexPath.row && numRowsCollapsed)
            {
                rowIndex = indexPath.row-numRowsCollapsed;//zero based index
                g_ExpandedCellIndex = indexPath.row-numRowsCollapsed-1;//zero based index
            }
            else
            {
                rowIndex = indexPath.row+1;
                g_ExpandedCellIndex = indexPath.row;
            }
            //
            //Insert the SubItems
            
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:rowIndex inSection:0]];
                [self.itemsInTable insertObject:dInner atIndex:rowIndex++];
                
            }
            [self.menuTableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationTop];
            
            
        }
    }
    //Else a subItem has been clicked. We need to push the relevant view into segue
    else
    {
        //1.getquote   2.home
        //3.1 indices 3.2 gainers  3.3 turnover
        //Problem 4.1 sme_marketwatch  4.2  sme_marketstats
        //chnage 5.1 changeSubLevel1 5.2 newChangeSubLevel1
        //6. sme_marketstats
        // 7. settings
        
        NSString* strId =[dic valueForKey:@"id"];
        NSLog(@"STR_ID : %@",strId);
        
        UIStoryboard * storyboard;
        UINavigationController *navController;
        
                 if([strId isEqualToString:@"CreateTicketId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                   CreateTicketView  * controller = (CreateTicketView *)[storyboard instantiateViewControllerWithIdentifier:@"CreateTicketViewId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"InboxId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     InboxTickets * controller = (InboxTickets *)[storyboard instantiateViewControllerWithIdentifier:@"inboxId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"MyTicketsId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     MyTickets * controller = (MyTickets *)[storyboard instantiateViewControllerWithIdentifier:@"myTicketsId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"UnassignedId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     UnassignedTickets * controller = (UnassignedTickets *)[storyboard instantiateViewControllerWithIdentifier:@"unAssignedId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"ClosedId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     ClosedTickets * controller = (ClosedTickets *)[storyboard instantiateViewControllerWithIdentifier:@"closedId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"TrashId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     TrashTickets * controller = (TrashTickets *)[storyboard instantiateViewControllerWithIdentifier:@"trashId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"sme_marketwatch"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     
                     ProblemList * controller = (ProblemList *)[storyboard instantiateViewControllerWithIdentifier:@"problemId"];
                     
                     navController = [[UINavigationController alloc] initWithRootViewController: controller];
                     
                     [navController setViewControllers: @[controller] animated: YES];
                     
                 }
                 else if([strId isEqualToString:@"sme_marketstats"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     
                     globalVariables.createProblemConditionforVC = @"newAlone";
                     
                     CreateProblem * controller = (CreateProblem *)[storyboard instantiateViewControllerWithIdentifier:@"CreateProblemId"];
                     
                     navController = [[UINavigationController alloc] initWithRootViewController: controller];
                     
                     [navController setViewControllers: @[controller] animated: YES];
                     
                 }
                 else if([strId isEqualToString:@"changeSubLevel1"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     
                
                     ChangeList * controller = (ChangeList *)[storyboard instantiateViewControllerWithIdentifier:@"ChangeListId"];
                     
                     navController = [[UINavigationController alloc] initWithRootViewController: controller];
                     
                     [navController setViewControllers: @[controller] animated: YES];
                     
                 }
                 else if([strId isEqualToString:@"newChangeSubLevel1"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     
                     globalVariables.createChangeConditionforVC = @"newChangeAlone";
                     
                     CreateChange * controller = (CreateChange *)[storyboard instantiateViewControllerWithIdentifier:@"CreateChangeId"];
                     
                     navController = [[UINavigationController alloc] initWithRootViewController: controller];
                     
                     [navController setViewControllers: @[controller] animated: YES];
                     
                 }
                 else if([strId isEqualToString:@"UnapprovedId"] || [strId isEqualToString:@"home"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

//                     UnApprovedTickets * controller = (UnApprovedTickets *)[storyboard instantiateViewControllerWithIdentifier:@"unApprovedId"];

                     TestingView * controller = (TestingView *)[storyboard instantiateViewControllerWithIdentifier:@"testId"];


                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"UsersListId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     ClientListViewController * controller = (ClientListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"clientListId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }
                 else if([strId isEqualToString:@"AboutUsId"])
                 {
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     AboutUsViewController * controller = (AboutUsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"AboutId"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 } //LogoutId

                 else if([strId isEqualToString:@"LogoutId"])
                 {
                     [self wipeDataInLogout];
                     
                     storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

                     
                     if (self.navigationController.navigationBarHidden) {
                         [self.navigationController setNavigationBarHidden:NO];
                     }
                     
                     [RMessage showNotificationInViewController:self.navigationController
                                                          title:NSLocalizedString(@" Faveo Helpdesk ", nil)
                                                       subtitle:NSLocalizedString(@"You've logged out, successfully...!", nil)
                                                      iconImage:nil
                                                           type:RMessageTypeSuccess
                                                 customTypeName:nil
                                                       duration:RMessageDurationAutomatic
                                                       callback:nil
                                                    buttonTitle:nil
                                                 buttonCallback:nil
                                                     atPosition:RMessagePositionNavBarOverlay
                                           canBeDismissedByUser:YES];
                     
                     LoginViewController * controller = (LoginViewController *)[storyboard instantiateViewControllerWithIdentifier:@"Login"];

                     navController = [[UINavigationController alloc] initWithRootViewController: controller];

                     [navController setViewControllers: @[controller] animated: YES];

                 }

                [self.revealViewController setFrontViewController:navController];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];


    }
}


-(void)wipeDataInLogout{
    
   // [self sendDeviceToken];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    
}


-(void)CollapseRows:(NSArray*)ar
{
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[self.itemsInTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"SubItems"];
        if(arInner && [arInner count]>0)
        {
            [self CollapseRows:arInner];
        }
        
        if([self.itemsInTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [self.menuTableView beginUpdates];
            [self.itemsInTable removeObjectIdenticalTo:dInner];
            [self.menuTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                        [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                        ]
                                      withRowAnimation:UITableViewRowAnimationLeft];
            [self.menuTableView endUpdates];
            
            
        }
        
    }
    
    
    
}

- (UITableViewCell*)createCellWithTitle:(NSString *)title cellId:(NSString *)cellId imageName:(NSString *)imageName  indexPath:(NSIndexPath*)indexPath
{
    ExpandableTableViewCell *cell = [self.menuTableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[ExpandableTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:cellId];
    }
    int posX = cell.imgMenuItem.frame.origin.x;
    int posY = cell.imgMenuItem.frame.origin.y;
    //Get Quote item has just the image, there is no title. So resize the imageView as per GetQuote image or regular icon
    if ([title isEqualToString:@"Get Quote"])
    {
        cell.lblTitle.text = @"";
        cell.imgMenuItem.frame = CGRectMake(posX, posY, 100, 20);
    }
    else
    {
        cell.lblTitle.text = title;
        cell.imgMenuItem.frame = CGRectMake(posX, posY, 16, 16);
    }
    
    cell.imgMenuItem.image = [UIImage imageNamed:imageName];
    NSInteger intIndentLevel = [[[self.itemsInTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue];
    [cell setIndentationLevel:intIndentLevel];
    cell.indentationWidth = 25;
    
    return cell;
}

-(void)showSubItems :(id) sender
{
    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.menuTableView];
    NSIndexPath *indexPath = [self.menuTableView indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    if(btn.alpha==1.0)
    {
        if ([[btn imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"down-arrow.png"]])
        {
            [btn setImage:[UIImage imageNamed:@"up-arrow.png"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setImage:[UIImage imageNamed:@"down-arrow.png"] forState:UIControlStateNormal];
        }
        
    }
    
    NSDictionary *d=[self.itemsInTable objectAtIndex:indexPath.row] ;
    NSArray *arr=[d valueForKey:@"SubItems"];
    if([d valueForKey:@"SubItems"])
    {
        BOOL isTableExpanded=NO;
        for(NSDictionary *subitems in arr )
        {
            NSInteger index=[self.itemsInTable indexOfObjectIdenticalTo:subitems];
            isTableExpanded=(index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [self.itemsInTable insertObject:dInner atIndex:count++];
            }
            [self.menuTableView insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    
    
}

@end
