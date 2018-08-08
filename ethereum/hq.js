// Create access to Campaign HQ for use by any part of appication
import web3 from "./web3.js";
import CampaignHQ from "./build/CampaignHQ.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignHQ.interface),
  "0x7f2015c6d0E3F025FE925ea3bAb93981884fAD5F" // Hard coded address of deployed CampaignHQ
);

export default instance; // If we ever need access to the deployed CampaignHQ import this file
