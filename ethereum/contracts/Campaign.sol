// Kickstart Campaign DApp
// A collection of smart contracts for a basic kickstart campaign Solidity/React dApp
pragma solidity ^0.4.24;

// Main Campaign Contract
contract Campaign {
    
    // Create a Spending Request
    struct Request {
        string description;     // Justify the request
        address recipient;      // Indicate end recipient 
        uint value;             // The amount to be paid to recipient
        bool complete; 
        // Add Voting Mechanism
    } 
    
    //--------Define Contract Variables-----------
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers; 
    Request[] public requests;
    
    //--------Define Function Modifiers-----------
    modifier onlyManager() {
        require(msg.sender == manager, "Only the campaign mangager can call");
        _;
    }
    
    //--------Contract Constructor-----------
    constructor(address _creator, uint _minCont) public {
        manager = _creator;
        minimumContribution = _minCont;
    }
    
    //--------Define Main Contract Functions-----------
    function contribute() public payable {
        require(msg.value >= minimumContribution,"Donation must exceed minimum contribution");
        //Add sender to list of contributers
        approvers[msg.sender] = true;
    }
    
    function createRequest(string description, address recipient, uint value) 
        public onlyManager() 
    {
        Request memory newRequest = Request({
            description: description,
            recipient: recipient,
            value: value,
            complete: false
        });   
      
        requests.push(newRequest);
        // Campaign manager creates a request to spend funds
    }
    
}

//-----------Future Updates--------------
/*
    - Add a voting mechanism
    - Add approveRequest() and finalizeRequest() functions
    - Add Donation phase/state. Then upon reaching goal enter the spending state
       which unlocks ability to create, vote for, and finalize spend requests
       Make use of: //--------Introduce State Flow to Smart Contract-----------
    - Add check that spend requests do not attempt to transfer more than contract 
       balance (unless we can rely on ETH to do this)
    - Add a pull payment function which allows users to withdraw funds after a specified time
       if the campaign goal is not met
*/

//-----------Questions--------------
//-----------Changes--------------
//-----------Testing--------------
