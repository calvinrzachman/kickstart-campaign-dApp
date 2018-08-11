// Kickstart Campaign DApp
// A collection of smart contracts for a basic kickstart campaign Solidity/React dApp
pragma solidity ^0.4.24;

// Campaign Headquarters: A Multi-Campaign Managing Contract 
// which solves the Campaign deployment problem (security/app-integration)
contract CampaignHQ {
    address[] public activeCampaigns;
    
    function createCampaign(uint _minCont, uint _quorum, uint _fundingGoal) public returns(address) {
        // Creates contract, deploys and returns address
        address newCampaign = new Campaign(msg.sender, _minCont, _quorum, _fundingGoal); 
        activeCampaigns.push(newCampaign);
    }
    
    function getActiveCampaigns() public view returns(address[]) {
        return activeCampaigns;
    }
}


// Main Campaign Contract
contract Campaign {

    //--------Introduce State Flow to Smart Contract----------- (8/10)
    enum States {
        DONATION,       // Awaiting initial funding
        ACTIVE,         // Campaign begins - Request creation/finalization live 
        ACTIVE_WITHDRAW   // Campaign did not reach funding goal - Return Funds 
                        // It is always safer to let contributors withdraw their money themselves.
    } 
    
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
    uint public contributorCount;

    // UPDATE(8/10)
    uint public quorum; // Require that this is a number between 1 and 100 
    uint public fundingGoal;
    States state; 
    mapping(address => uint) private pendingReturns; // Allow withdrawals of funds
    

    //--------Define Function Modifiers-----------
    modifier onlyManager() {
        require(msg.sender == manager, "Only the campaign mangager can call");
        _;
    }

    modifier hasDonated() {
        require(contributors[msg.sender], "Only campaign contributors can call");
        _;
    }

    modifier isCurrentState(States _state) {    //Terminate if function is called during incorrect contract state
        require(state == _state, "Operation is not available in current state");
        _;
    }

    modifier hasNotVoted(uint index) {
        Request storage request = requests[index];
        require(!request.approvals[msg.sender], "This account has already voted");
        _;
    }
    
    //--------Contract Constructor-----------
    constructor(address _creator, uint _minCont, uint _quorum, uint _fundingGoal) public {
        manager = _creator;
        minimumContribution = _minCont;
        quorum = _quorum;
        fundingGoal = _fundingGoal; 
        state = States.ACTIVE_WITHDRAW;
        // Eventually set state to state = States.DONATION to initiate donation phase
    }
    
    //--------Define Main Contract Functions-----------
    function contribute() public payable {
        require(msg.value >= minimumContribution,"Donation must exceed minimum contribution");
        if (!contributors[msg.sender]) {       // ONLY unique contributers
            contributors[msg.sender] = true;   // Add sender to list of contributers
            contributorCount++;
        }
        // Allow multiple donations from same contributor but ONLY count them as one unique contributor

        pendingReturns[msg.sender] += msg.value;    // Store value for possible later return 
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

    function approveRequest(uint index) public hasDonated() hasNotVoted(index) {
        // Participants can approve a Spend Request 
        Request storage request = requests[index];
        
        // Participants can only vote once on a spending request
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function finalizeRequest(uint index) public onlyManager() {
        Request storage request = requests[index];
        require(!request.complete, "Request already finalized");
        require(request.approvalCount > (contributorCount / 2), "Quorum not reached");
        request.complete = true;
        request.recipient.transfer(request.value);
    }
    
     // UPDATE (8/10): Front End React Helper
    function getSummary() public view returns (uint, uint, uint, uint, address, uint, uint) {
        return (
            this.balance,
            minimumContribution, 
            requests.length,
            contributorCount,
            manager,
            quorum,
            fundingGoal
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }

    // UPDATE: Phase/State
    // UPDATE (8/10): Return - Allow user to withdraw funds from a campaign.
    function withdraw() 
        public 
        isCurrentState(States.ACTIVE_WITHDRAW)
        hasDonated()
    {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `transfer` returns (see the remark above about
            // conditions -> effects -> interaction).
            pendingReturns[msg.sender] = 0;
            contributors[msg.sender] = false;   // Remove withdrawer from list of contributors
            contributorCount--;

            msg.sender.transfer(amount);
        }
    }
    // NOTE: if they withdraw, they should be removed from the list of contributors

    //--------Fallback Function-----------
    function () public payable {}
    
}

// IMPORTANT NOTE: This project was completed with the help of Stephen Grider to gain familiarity and 
// experience working with web3 and Solidity. 
// It is for instructional and learning purposes ONLY and SHOULD NOT be used as stands 
// for a production application

//-----------Future Updates--------------
/*
    - Request approval Count continues to update after approval of request. This makes it appear
        as though the request was approved without quorum. (IMPORTANT) 
    - (DONE**) Add the ability to specify the quorum required for request approval
        Note: Since we cant use floating point need to covert the quorum number 
    - (DONE) Add the ability to specify a funding goal (in ether) for the campaign 
    - (DONE) Add a voting mechanism 
    - (DONE) Add approveRequest() and finalizeRequest() functions
    - (IN PROGRESS - Difficult/Long) Add Donation phase/state. Then upon reaching goal enter the spending state
       which unlocks ability to create, vote for, and finalize spend requests
       Make use of: //--------Introduce State Flow to Smart Contract-----------
    - (DONE - LIKELY) Add check that spend requests do not attempt to transfer more than contract 
       balance (unless we can rely on ETH to do this)
    - (DONE) Add a pull payment function which allows users to withdraw funds after a specified time
       if the campaign goal is not met

       - (DONE) Ensure that if contributor withdraws, they are removed from the list of contributors
       - BUG: If contributor gets paid by spending request, they cannot withdraw
    - (FIXED) contributorCount currently does not reflect number of UNIQUE contributors (IMPORTANT) 
*/

/*-----------Questions--------------
    - Do I need to add check that spend requests do not attempt to transfer more than contract 
       balance? Will Ethereum automatically handle this? -- Yes but perhaps it doesnt provide
       much info to user on error

*/  

/*-----------Comments--------------
  IMPORTANT NOTE: This project was completed with the help of Stephen Grider to gain familiarity and
    experience working with web3 and Solidity.
    It is for instructional and learning purposes ONLY and SHOULD NOT be used as stands
    for a production application

*/