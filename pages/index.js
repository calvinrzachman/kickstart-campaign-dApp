import React, { Component } from "react";
import hq from "../ethereum/hq.js";

import { Card, Button } from "semantic-ui-react";
import Layout from "../components/Layout";

import { Link } from "../routes"; // Allows us to create link tag which user can use

class CampaignIndex extends Component {
  static async getInitialProps() {
    const campaigns = await hq.methods.getActiveCampaigns().call();
    return { campaigns };
    // static is more efficient as it does not require rendering an instance of the component
  }

  renderCampaigns = () => {
    const items = this.props.campaigns.map(address => {
      return {
        header: address,
        description: (
          <Link route={`/campaigns/${address}`}>
            <a href="">View Campaign</a>
          </Link>
        ),
        fluid: true // Unconstrains width
      };
    });
    console.log(items);
    return <Card.Group items={items} />;
  };

  render() {
    return (
      <Layout>
        <div>
          <h3>Open Campaigns</h3>
          <Link route="/campaigns/new">
            <a>
              <Button
                floated="right"
                content="Create Campaign"
                icon="add circle"
                positive
              />
            </a>
          </Link>
          {this.renderCampaigns()}
        </div>
      </Layout>
    );
  }
}

export default CampaignIndex;

// With Next.js componentDidMount is not executed on the server - instead use getInitialProps()
// NOTE: This is only used with next.js

// Anchor Tag allows for the right click open in new tab functionality