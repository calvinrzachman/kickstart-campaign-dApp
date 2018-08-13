// Create access to Campaign HQ for use by any part of appication
import web3 from "./web3.js";
import CampaignHQ from "./build/CampaignHQ.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignHQ.interface),
  "0x9FA984c30C34D2f57b9C9B306fc9bedBE25f6aA9" // Hard coded address of deployed CampaignHQ
);

export default instance; // If we ever need access to the deployed CampaignHQ import this file
