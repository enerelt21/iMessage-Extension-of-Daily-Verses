//
//  MessagesViewController.h
//  iMessage Xtension
//
//  Created by Bat-Erdene, Ene on 6/4/19.
//  Copyright © 2019 Bat-Erdene, Ene. All rights reserved.
//

#import <Messages/Messages.h>
//#import "CollectionViewController.h"

@interface MessagesViewController : MSMessagesAppViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UIGestureRecognizer *tapExpand;
@property (strong) IBOutlet UICollectionView *collectionView;
@property (strong) IBOutlet UIButton *translationButton;
@property (strong, nonatomic) MSMessage *message;

-(IBAction)onChangeTranslation:(id)sender;
@end
