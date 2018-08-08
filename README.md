# kickstart-campaign-dApp
A Smart Contract for a basic kickstart campaign - Solidity/React dApp 

## To run the application: 
  ### Deploy Contracts and Create Application Instance 
  1. Clone the repository
  2. Make sure you have all the necessary node modules installed (see package.json file for list of dependencies)  
   a. To install modules open up the command line and type 
  
    npm install
    
  3. Compile and Deploy the Smart Contract 
   a. Navigate to the ./ethereum directory and run:
    
    node compile.js
    
   b. After compiling, deploy the smart contract using:
   
    node deploy.js
    
   If all goes well you should see the following in the CLI:  
  
    Attempting to deploy from:  <Ethereum External Account Address (ex: Metamask)>
    Contract deployed to:  <Contract Address>
  
  4. Create a local instance of the CampaignHQ smart contract  
   a. Add the contract address to the hq.js file within ./ethereum directory:
   
    const instance = new web3.eth.Contract(
      JSON.parse(CampaignHQ.interface),
      "<Contract Address>" // Address of deployed CampaignHQ
    );
  
  5. Create a application instance on http://localhost:3000/ with the command:
    
    npm run dev
      
  ### Create a Kickstart Campaign 
  You can launch have users fund your campaigns. Campaign owners create requests to spend the donations 
  they receive. Campaign contributors then vote on which requests they approve. 
  In order for the owner to spend the funds, the request must reach a quorum of approval from the contributors 
  of the campaign. 
 
  This provides additional assurance to campaign contributors that their donations will not be misallocated. 
  The smart contract allows the owner to spend funds ONLY when a specified portion of campaign contributors vote for 
  and approve of the spending request.  
  
  #### Create Campaign 
  1. Select either the `Create Campaign` or `+` button
  2. Specify the minimum contribution to the campaign 
    
  #### View Campaign Details 
  1. Navigate to the home page where your newly created campaign should be visible on the list of `Open Campaigns`
  2. Locate your campaign and select `View Campaign`
  
  Here you will be presented with a collection of information on the campaign including:
    
  
  
   
    
  ### Unit test with Mocha  
    npm run test
