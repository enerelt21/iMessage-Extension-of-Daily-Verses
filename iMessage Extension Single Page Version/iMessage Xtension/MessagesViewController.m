//
//  MessagesViewController.m
//  iMessage Xtension
//
//  Created by Bat-Erdene, Ene on 6/4/19.
//  Copyright © 2019 Bat-Erdene, Ene. All rights reserved.
//

#import "MessagesViewController.h"
#import "CollectionViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface MessagesViewController ()
@property (strong, nonatomic) NSMutableArray *verses;
@property (strong, nonatomic) NSMutableArray *dateComp;
@property (strong, nonatomic) NSString *translation;
@end

static NSString * const reuseIdentifier = @"Daily Verses";

@implementation MessagesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getVerses];
    [self.translationButton setTitle:@"NIV" forState:UIControlStateNormal];
    [self.translationButton setBackgroundColor: [UIColor whiteColor]];
    [self.translationButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //[self.translationButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size: 16]];
    self.translationButton.layer.cornerRadius = 10;
    self.translationButton.clipsToBounds = YES;

    self.navigationItem.title = @"Daily Verses";
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self.collectionView registerClass:CollectionViewCell.class forCellWithReuseIdentifier:reuseIdentifier];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(118, 118);
}
-(void) getVerses{
    self.verses = [NSMutableArray array];
    self.dateComp = [NSMutableArray array];
    NSDateComponents *todayComp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: [NSDate date]];
    NSDateComponents *comp = [[NSDateComponents alloc] init] ;
    comp.year = 2019;
    comp.month = 1;
    comp.day = 1;
    
    NSDate *jan1Date = [[NSCalendar currentCalendar] dateFromComponents:comp];
    NSDate *jan2Date = jan1Date;
    NSString *month = NSString.new;
    NSString *day = NSString.new;
    self.translation = @"NIV";
    while(comp.month != todayComp.month || comp.day != todayComp.day || comp.year != todayComp.year){
        comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate: jan2Date];
        //NSLog(@"Year: %ld    Month: %ld    Day: %ld", (long)comp.year, (long)comp.month, (long)comp.day);
        if (comp.month < 10)
            month = [NSString stringWithFormat:@"0%ld", comp.month];
        else
            month = [NSString stringWithFormat:@"%ld", comp.month];
        if (comp.day < 10)
            day = [NSString stringWithFormat:@"0%ld", comp.day];
        else
            day = [NSString stringWithFormat:@"%ld", comp.day];
        NSString *urlString = [NSString stringWithFormat:@"https://votd.olivetree.com/%@_%@_%@.jpg", month, day, self.translation];
        
        [self.dateComp addObject:[NSString stringWithFormat:@"%@/%@/%ld", month, day, (long)comp.year]];
        [self.verses addObject:urlString];
        jan1Date = jan2Date;
        jan2Date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:jan1Date options:0];
    }
}
-(void)onChangeTranslation:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Translations" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.sourceView = self.translationButton;
    
    for (NSString *trans in @[@"NIV", @"NKJV", @"NVI", @"KJV"])
    {
        UIAlertAction *action = [UIAlertAction actionWithTitle:trans style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showTranslation:trans];
        }];
        [alert addAction:action];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showTranslation:(NSString *)translation
{
    self.translation = translation;
    [self.collectionView reloadData];
    [self.translationButton setTitle:translation forState:UIControlStateNormal];
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.verses.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    self.verses[self.verses.count - indexPath.row - 1] = [self.verses[self.verses.count - indexPath.row - 1] stringByReplacingOccurrencesOfString:@"NIV" withString:self.translation];
    NSURL *url = [NSURL URLWithString:self.verses[self.verses.count - indexPath.row - 1]];
    self.verses[self.verses.count - indexPath.row - 1] = [self.verses[self.verses.count - indexPath.row - 1] stringByReplacingOccurrencesOfString:self.translation withString:@"NIV"];
    
    cell.url = url;
    cell.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake( cell.bounds.origin.x, cell.bounds.origin.y, 50, 12)];
    [cell.cellLabel setText:self.dateComp[self.verses.count - indexPath.row - 1]];
    //NSLog(@"%@", cell.cellLabel.text);
    [cell.cellLabel setTextAlignment: NSTextAlignmentCenter];
    //cell.cellLabel.frame = CGRectMake(cell.center.x, cell.center.y, 10, 5);
    [cell.cellLabel setBackgroundColor:[UIColor whiteColor]];
    [cell.cellLabel setTextColor:[UIColor blackColor]];
    [cell.cellLabel setFont:[UIFont boldSystemFontOfSize:8]];
    cell.cellLabel.layer.cornerRadius = 5;
    cell.cellLabel.clipsToBounds = YES;
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([cell.url isEqual:url])
            {
                cell.verseImage.image = [UIImage imageWithData:data];
                [cell.verseImage addSubview:cell.cellLabel];
            }
        });
        if (error)
        {
            NSLog(@"The process of getting bible verses failed: %@", error);
            return;
        }
    }] resume];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSMessageTemplateLayout *temp = MSMessageTemplateLayout.new;
    self.verses[self.verses.count - indexPath.row - 1] = [self.verses[self.verses.count - indexPath.row - 1] stringByReplacingOccurrencesOfString:@"NIV" withString:self.translation];
    NSURL *url = [NSURL URLWithString:self.verses[self.verses.count - indexPath.row - 1]];
     self.verses[self.verses.count - indexPath.row - 1] = [self.verses[self.verses.count - indexPath.row - 1] stringByReplacingOccurrencesOfString:self.translation withString:@"NIV"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    temp.image = [UIImage imageWithData:data];

    self.message = MSMessage.new;
    self.message.layout = temp;
    /*MSSticker *sticker = [[MSSticker alloc] initWithContentsOfFileURL:url localizedDescription:@"Sticker" error:nil];
    //[sticker initWithContentsOfFileURL:url localizedDescription:@"Sticker" error:nil];
    [self.activeConversation insertSticker:sticker completionHandler:^(NSError * _Nullable error) {
        NSLog(@"error: %@", error.localizedDescription);
    }];*/
    //[self.activeConversation insertSticker:sticker completionHandler:nil];
    if ([self activeConversation] != nil) {
        [self.activeConversation insertMessage:self.message completionHandler:^(NSError * _Nullable error) {
            NSLog(@"error: %@", error.localizedDescription);
        }];
    }
//    else
//        NSLog(@"Conversation is nil");

    if (self.presentationStyle == MSMessagesAppPresentationStyleExpanded)
        [self requestPresentationStyle:MSMessagesAppPresentationStyleCompact];

}
#pragma mark - Conversation Handling

-(void)didBecomeActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the inactive to active state.
    // This will happen when the extension is about to present UI.
    
    // Use this method to configure the extension and restore previously stored state.
}

-(void)willResignActiveWithConversation:(MSConversation *)conversation {
    // Called when the extension is about to move from the active to inactive state.
    // This will happen when the user dissmises the extension, changes to a different
    // conversation or quits Messages.
    //[self.activeConversation insertMessage:self.message completionHandler:nil];
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough state information to restore your extension to its current state
    // in case it is terminated later.
}

-(void)didReceiveMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when a message arrives that was generated by another instance of this
    // extension on a remote device.
    
    // Use this method to trigger UI updates in response to the message.
}

-(void)didStartSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user taps the send button.
    //[self.activeConversation sendMessage:self.message completionHandler:nil];
}

-(void)didCancelSendingMessage:(MSMessage *)message conversation:(MSConversation *)conversation {
    // Called when the user deletes the message without sending it.
    
    // Use this to clean up state related to the deleted message.
}

-(void)willTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called before the extension transitions to a new presentation style.

    // Use this method to prepare for the change in presentation style.
}

-(void)didTransitionToPresentationStyle:(MSMessagesAppPresentationStyle)presentationStyle {
    // Called after the extension transitions to a new presentation style.
    
    // Use this method to finalize any behaviors associated with the change in presentation style.
}

@end
