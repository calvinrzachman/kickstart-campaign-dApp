// Configure Web3 using Metamask Provider
import Web3 from "web3";

let web3;

if (typeof window !== "undefined" && window.web3 !== "undefined") {
  // We are running in the browser and user has Metamask
  web3 = new Web3(window.web3.currentProvider); // Browser only global variable
} else {
  // We are on the Server OR user is not running Metamask
  const provider = new Web3.providers.HttpProvider( // Make our own provider - Infura
    "https://rinkeby.infura.io/v3/e12a4f581ff546039c9189b70f19c53c"
  );
  web3 = new Web3(provider);
}

export default web3;

// ERROR: window is not defined !!
// Next makes use of server side rendering: whenever someone accesses our Next.js server,
// the server will take the React application, try to render the entire app itself, build an HTML
// document which it thens sends to the browser. BENEFIT: Users see content rendered much more quickly

// We have also assumed users are running Metamask
// We will collect all the data server side so that users can interact with our app WITHOUT Metamask
// ENSURE this code can be executed on either the server or the browser
