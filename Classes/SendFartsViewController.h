
#import <UIKit/UIKit.h>
// 1. Import the gamekit framework            
#import <GameKit/GameKit.h>    //       DONT FORGET TO IMPORT THE GAMEKIT FRAMEWORK AND IMPORT THIS.

//    GKSessionDelegate - Used to maintain Sessions.
//    GKPeerPickerControllerDelegate - Gives an apple provided peer picker, where you can look for other devcies using the same apps to connect with.

@interface SendFartsViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate>{
	// Session Object. This handles all throughout the game.
	GKSession *fartSession;
	// PeerPicker Object. We can delete it as soon as we get the game setup.
	GKPeerPickerController *fartPicker;
	// U might have more than 2 players.
	NSMutableArray *fartPeers;
}
@property (retain) GKSession *fartSession;  //Getter and Setter on the GKSession.
//To connect and send data
- (void) connectToPeers:(id) sender;
- (void) sendALoudFart:(id)sender;
- (void) sendASilentAssassin:(id)sender;

@end

