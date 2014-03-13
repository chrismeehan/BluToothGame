#import "SendFartsViewController.h"

@implementation SendFartsViewController
@synthesize fartSession;  //dont forget to synthesise the session for the set and get.

- (void)viewDidLoad {
    [super viewDidLoad];
	
	fartPicker = [[GKPeerPickerController alloc] init];   //Get the GKPPC that will find the players.
	fartPicker.delegate = self;
	// GKPeerPickerConnectionTypeNearby via BlueTooth   or     GKPeerPickerConnectionTypeOnline via Internet
	fartPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    
	fartPeers=[[NSMutableArray alloc] init];   //Get the array set up where the players will go.
	
	// Create the buttons,   nothing to see here.
	UIButton *btnConnect = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnConnect addTarget:self action:@selector(connectToPeers:) forControlEvents:UIControlEventTouchUpInside];
	[btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
	btnConnect.frame = CGRectMake(20, 100, 280, 30);
    [self.view addSubview:btnConnect];

	btnConnect.tag = 12;   //But here, we are giving the button a tag (int).   Now we can tell it to leave from anywhere.
	
}
//We invented this method.
// When the button "connect" finally gets hit, the picker displays like a popup saing "looking for others.."
- (void) connectToPeers:(id) sender{
	[fartPicker show]; //This is the GKPPC's popup.
}


//The iphone must secretly call this 1st, it returns a session back to the iPhone with id=   "com.vivianaranha.sendfart", that's it. It doesnt even use the parameters.
#pragma mark -
#pragma mark GKPeerPickerControllerDelegate
// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
	// Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
	GKSession* session = [[GKSession alloc] initWithSessionID:@"com.vivianaranha.sendfart" displayName:nil sessionMode:GKSessionModePeer];
    return [session autorelease];
}

//THis method tells the delegate that the controller connected a peer to the session.
//Once a peer is connected to the session, your application should take ownership of the session, dismiss the peer picker, and then use the session to communicate with the other peer.
//      picker = The controller that connected the peer.      session = The session that the peer is connected to.
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session{
	// Get the session and assign it locally
    self.fartSession = session;
    session.delegate = self;
    //No need of the picker anymore
	picker.delegate = nil;
    [picker dismiss];
    [picker autorelease];
}

//When my peer gets connected, this method gets called with state, "GKPeerStateConnected". Lets change the buttons to play mode.
#pragma mark -
#pragma mark GKSessionDelegate
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
	if(state == GKPeerStateConnected){
		// Add the peer to the Array
		[fartPeers addObject:peerID];
        //Tell the user that this peer has now been connected.
		NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];

		//Acknowledge that we will be sending data
		[session setDataReceiveHandler:self withContext:nil];
		
		[[self.view viewWithTag:12] removeFromSuperview];
		
        //Create 2 buttons that will send a different peice of data when hit.
		UIButton *btnLoudFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btnLoudFart addTarget:self action:@selector(sendALoudFart:) forControlEvents:UIControlEventTouchUpInside];
		[btnLoudFart setTitle:@"Loud Fart" forState:UIControlStateNormal];
		btnLoudFart.frame = CGRectMake(20, 150, 280, 30);
		[self.view addSubview:btnLoudFart];
		
		UIButton *btnSilentFart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[btnSilentFart addTarget:self action:@selector(sendASilentAssassin:) forControlEvents:UIControlEventTouchUpInside];
		[btnSilentFart setTitle:@"Silent Assassin" forState:UIControlStateNormal];
		btnSilentFart.frame = CGRectMake(20, 200, 280, 30);
		[self.view addSubview:btnSilentFart];
	}
}

//So all those methods just get called at the beginning. The following get called throughout the game:

// Here is where you send the data.....
- (void) sendALoudFart:(id)sender{
	NSString *loudFart = @"Brrrruuuuuummmmmmmppppppppp";
	// Send the fart to Peers using the current sessions
	[fartSession sendData:[loudFart dataUsingEncoding: NSASCIIStringEncoding] toPeers:fartPeers withDataMode:GKSendDataReliable error:nil];
}
- (void) sendASilentAssassin:(id)sender{
	NSString *silentAssassin = @"Puuuuuuuusssssssssssssssss";
	// Send the fart to Peers using the current sessions
	[fartSession sendData:[silentAssassin dataUsingEncoding: NSASCIIStringEncoding] toPeers:fartPeers withDataMode:GKSendDataReliable error:nil];
}

// Here is where you receive the data. And the NSData, "data" is all we need to know.
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
	//Convert received NSData to NSString to display
   	NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	//Dsiplay the fart as a UIAlertView
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fart Received" message:whatDidIget delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[whatDidIget release];
}




- (void)dealloc {
	[fartPeers release];
    [super dealloc];
}

@end
