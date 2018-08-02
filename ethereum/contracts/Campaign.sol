// Kickstart Campaign DApp
// A collection of smart contracts for a basic kickstart campaign Solidity/React dApp
pragma solidity ^0.4.24;

// Campaign Headquarters: A Multi-Campaign Managing Contract 
// which solves the Campaign deployment problem (security/app-integration)
contract CampaignHQ {
    address[] public activeCampaigns;
    
    function createCampaign(uint _minCont) public returns(address) {
        // Creates contract, deploys and returns address
        address newCampaign = new Campaign(msg.sender, _minCont); 
        activeCampaigns.push(newCampaign);
    }
    
    function getActiveCampaigns() public view returns(address[]) {
        return activeCampaigns;
    }
}


// Main Campaign Contract
contract Campaign {
    
    // Create a Spending Request
    struct Request {
        string description;     // Justify the request
        address recipient;      // Indicate end recipient 
        uint value;             // The amount to be paid to recipient
        bool complete; 
        // Voting mechanism
        mapping(address => bool) approvals;
        uint approvalCount;     // Track vote count (can't iterate over mapping)
    } 
    
    //--------Define Contract Variables-----------
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public contributors; 
    Request[] public requests;
    uint public contributerCount;
    
    //--------Define Function Modifiers-----------
    modifier onlyManager() {
        require(msg.sender == manager, "Only the campaign mangager can call");
        _;
    }

    modifier hasDonated() {
        require(contributors[msg.sender], "Only campaign contributors can call");
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
        if (!contributors[msg.sender]) {       // ONLY unique contributers
            contributors[msg.sender] = true;   // Add sender to list of contributers
            contributerCount++;
        }
        // Allow multiple donations from same contributor but ONLY count them as one unique contributor
    }
    
    function createRequest(string description, address recipient, uint value) 
        public onlyManager() 
    {
        Request memory newRequest = Request({
            description: description,
            recipient: recipient,
            value: value,
            complete: false,
            approvalCount: 0
        });   
      
        requests.push(newRequest);
        // Campaign manager creates a request to spend funds
    }

    function finalizeRequest(uint index) public onlyManager() {
        Request storage request = requests[index];
        require(!request.complete, "Request already finalized");
        require(request.approvalCount > (contributerCount / 2), "Quorum not reached");
        request.complete = true;
        request.recipient.transfer(request.value);
    }
    
}

//-----------Future Updates--------------
/*
    - (DONE) Add a voting mechanism 
    - (DONE) Add approveRequest() and finalizeRequest() functions
    - Add Donation phase/state. Then upon reaching goal enter the spending state
       which unlocks ability to create, vote for, and finalize spend requests
       Make use of: //--------Introduce State Flow to Smart Contract-----------
    - Add check that spend requests do not attempt to transfer more than contract 
       balance (unless we can rely on ETH to do this)
    - Add a pull payment function which allows users to withdraw funds after a specified time
       if the campaign goal is not met
    - (FIXED) contributorCount currently does not reflect number of UNIQUE contributors (IMPORTANT) 
*/

/*-----------Questions--------------
    - Do I need to add check that spend requests do not attempt to transfer more than contract 
       balance? Will Ethereum automatically handle this? -- Yes but perhaps it doesnt provide
       much info to user on error

*/  
//-----------Changes--------------
//-----------Testing--------------
