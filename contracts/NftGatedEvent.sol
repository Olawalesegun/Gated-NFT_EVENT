// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NftGatedEvent {
  address public nftTokenAddress;
 
 
  struct Event {
    uint256 eventId;
    string name;
    string descriptionOfEvent;
    string dateOfEvent;
    string timeOfEvent;
    uint256 noOfAttendeesExpected;
    address[] attendeesList;
  }

  error YouHaveToMintAnNFT();
  error AddressZeroDetected();

  event EventSuccessfulCreated(string name, string descriptionOfEvent);
  event RegistrationSuccesful(string name, string email);
  
  mapping(address => Event[]) createdEvents;
  mapping(address => bool) hasRegistered;
  
  constructor(address _nftTokenAddress) {
    require(_nftTokenAddress != address(0), "Address Zero Detected");
   
  }

  function createEvent(
    string memory _name, 
    string memory _description,
    string memory _doE, 
    string memory _timeOfEvent, 
    uint256 _noOfAttendeesExpected
    ) external{

      if(msg.sender == address(0)){
        revert AddressZeroDetected();
      }

      IERC721 _nftToken = IERC721(nftTokenAddress);
      
      if(_nftToken.balanceOf(msg.sender) < 1) {
        revert YouHaveToMintAnNFT();
      }
      uint256 counter = createdEvents[msg.sender].length;

      if(counter > 0) {
        counter++;
        Event storage eventss = createdEvents[msg.sender][counter];
        eventss.eventId = counter;
        eventss.name = _name;
        eventss.descriptionOfEvent = _description;
        eventss.dateOfEvent = _doE;
        eventss.timeOfEvent = _timeOfEvent;
        eventss.noOfAttendeesExpected = _noOfAttendeesExpected;

      }
      counter++;
      Event storage events = createdEvents[msg.sender][counter]; 
      events.eventId = counter;
      events.eventId = counter;
      events.name = _name;
      events.descriptionOfEvent = _description;
      events.dateOfEvent = _doE;
      events.timeOfEvent = _timeOfEvent;
      events.noOfAttendeesExpected = _noOfAttendeesExpected;

      emit EventSuccessfulCreated(_name, _description);

  }

  function registerForEvent(
    address _creator,
    uint256 _eventId,
    string memory _name,
    string memory _email
    ) external {

      if(msg.sender == address(0)){
        revert AddressZeroDetected();
      }

      createdEvents[_creator][_eventId].attendeesList.push(msg.sender);

      hasRegistered[msg.sender] = true;
      emit RegistrationSuccesful(_name, _email);
    }



//  TODO
//  We have 2 users:
//  1. Creator: they create events.
//  2. Attendee: they register for events.

//  Creator creates an event by clicking on the "create event" button. 
//  However, for a creator to create an event, they must own our specific NFT.
//  A creator can create multiple events.
//  Attendees register for the event.

//  HOW TO:
//  In Creating the Event, the creator will provide details such as:
//      - EventId (unique identifier for each event)
//      - Event Name
//      - Date of the Event
//      - Time of the Event
//      - Number of Attendees (event capacity)
//      - Speakers of the Event
//      - Array of Attendees (list of attendees registered for the event)
//      - Requirements to participate in the event (e.g., owning an NFT, other criteria)

//  Mappings:
//  - `mapping(address => Event[]) creatorEvents`: Because a creator can create multiple events, this mapping will store an array of events for each creator's address.
//  - `mapping(uint => Event) public events`: A global mapping of all events by their unique event ID.
//  - `mapping(uint => mapping(address => bool)) public eventRegistrations`: Mapping to track which attendees have registered for a particular event.

//  Create Event Function:
//  - We need to check that the creator owns the required NFT.
//  - If they don't own the NFT, revert the transaction with a message.
//  - If the NFT is verified, allow the creator to provide the event details (name, date, time, etc.).
//  - Add the event to the creator's list of events.
//  - Emit an event for successful event creation (e.g., `EventCreated`).

//  Attendee Registration Process:
//  - An attendee clicks on the "register for event" button.
//  - In the register method, the attendee provides the following details:
//      - Name
//      - Email
//  - These details are stored in a mapping of registered attendees for each event.
//  - We check that the event is not already full (compare the number of attendees with the maximum allowed).
//  - Optionally, check if there are additional requirements to participate in the event (e.g., specific NFT ownership).
//  - Add the attendee’s information (name, email, address) to the list of registered attendees.
//  - Emit an event for successful registration (e.g., `AttendeeRegistered`).

//  Attendee Information Structure:
//  - Define an `Attendee` struct to store attendee details:
//      - `string name`: Attendee's name.
//      - `string email`: Attendee's email.
//      - `address attendeeAddress`: The wallet address of the attendee.
//  - This struct will be stored in a `mapping(uint => Attendee[])` to link attendees to specific events.

//  Struct Definitions:
//  - Define the `Event` struct to store event details such as:
//      - `uint eventId`: Unique identifier for the event.
//      - `string eventName`: Name of the event.
//      - `uint date`: Date of the event (timestamp).
//      - `uint time`: Time of the event (timestamp).
//      - `uint maxAttendees`: The maximum number of attendees allowed for the event.
//      - `string[] speakers`: List of speakers for the event.
//      - `Attendee[] attendees`: Array of `Attendee` structs to store registered attendees.
//      - `string requirements`: Any specific requirements for attending the event.

//  Event and Attendee Structs:
//  ```solidity
//  struct Attendee {
//      string name;
//      string email;
//      address attendeeAddress;
//  }

//  struct Event {
//      uint eventId;
//      string eventName;
//      uint date;
//      uint time;
//      uint maxAttendees;
//      string[] speakers;
//      Attendee[] attendees;
//      string requirements;
//  }
//  ```



}