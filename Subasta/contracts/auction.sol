// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.4.24;

contract Auction {
    //Declare some variables
    address internal auction_owner;
    uint256 public auction_start;
    uint256 public auction_end;
    uint256 public highestBid; 
    address public highestBidder; 
    enum auction_state {
        CANCELLED, STARTED
    }
    
    //////////////////////////////Events//////////////////////////////
    //Informs us of a newly registered bid and provides us with the bidder's address and the bid
    event BidEvent(address indexed highestBidder, uint256 highestBid);
    //Logs the withdrawal operations, giving the withdrawer's address and the withdrawal amount
    event WithdrawalEvent(address withdrawer, uint256 amount);
    //will be issued once the auction has been canceled and will issue a message, Auction canceled , with the time of cancellation
    event CanceledEvent(string message, uint256 time);

    struct add {
        string Brand;
        string Rnumber;
    }

    add public Mycar;

    address[] bidders;

    mapping(address => uint) public bids; 
    auction_state public STATE;
    
    //check if the auction is still open
    modifier an_ongoing_auction(){ 
        require(now <= auction_end);
        _;
    }

    //restricts the authorization to execute a function to the owner of the contract
    modifier only_owner() {
        require(msg.sender == auction_owner);
        _;
    }
    //////////////////////////////Post auction//////////////////////////////
    function Post_add(string memory _nombreAtraccion, uint _precio) public Unicamente (msg.sender) {
        // Creacion de una atraccion en Disney 
        MappingAtracciones[_nombreAtraccion] = atraccion(_nombreAtraccion,_precio, true);
        // Almacenamiento en un array el nombre de la atraccion 
        Atracciones.push(_nombreAtraccion);
        // Emision del evento para la nueva atraccion 
        emit nueva_atraccion(_nombreAtraccion, _precio);
    }

    //////////////////////////////Bidding Function//////////////////////////////
    function bid() public payable an_ongoing_auction returns (bool){ 
        //Check preconditions(That the new offer is greater than the previous one)
        require(bids[msg.sender] + msg.value > highestBid, "can't bid, Make a higher Bid");

        //Keep the new bidder with the highest offer(If the offer was successful)
        highestBidder = msg.sender;
        highestBid = msg.value;
        //Add the address of the bidder to the array of participants
        bidders.push(msg.sender);
        //Update the offer of the participant in our mapping offers
        bids[msg.sender] = bids[msg.sender] + msg.value;

        //Returns true to indicate a successful execution (bidding) and emit the BidEvent
        emit BidEvent(highestBidder, highestBid);
        return true;
    } 
    
    //////////////////////////////Withdrawing Bids//////////////////////////////
    function withdraw() public returns (bool){
        //Check preconditions(the auction ended)
        require(now > auction_end , "can't withdraw, Auction is still open");
        
        //Send ether and throw if the send fails (roll back method execution) 
        uint amount = bids[msg.sender];
        bids[msg.sender] = 0; msg.sender.transfer(amount);
        WithdrawalEvent(msg.sender, amount);
        
        //Emit a log event and return true to indicate a successful
        return true;
    } 
    
    //////////////////////////////Cancel Auction//////////////////////////////
    //Check preconditions(executed exclusively by the owner of the auction)
    function cancel_auction() only_owner an_ongoing_auction public returns (bool) { 
        //modify the status of the auction has been canceled
        STATE = auction_state.CANCELLED;
        // Use "CanceledEvent" event 
        CanceledEvent("Auction Cancelled", now);
        // return true to indicate a successful
        return true;
    }

    function destruct_auction() external only_owner returns (bool) { 
        //Check preconditions(the auction ended)
        require(now > auction_end, "You can't destruct the contract,The auction is still open");
        
        for (uint i = 0;
        i < bidders.length;
        i++){
        
        assert(bids[bidders[i]] == 0);
        }
        
        selfdestruct(auction_owner);
        return true;
        } 
} 