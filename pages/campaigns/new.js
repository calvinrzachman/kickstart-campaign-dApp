import React, { Component } from "react";
import Layout from "../../components/Layout";
import { Button, Form, Input, Message } from "semantic-ui-react";

import hq from "../../ethereum/hq";
import web3 from "../../ethereum/web3";

import { Router } from "../../routes";

class CampaignNew extends Component {
  state = {
    minimumContribution: "",
    errorMessage: "",
    loading: false
  };

  onSubmit = async () => {
    // Browser will try to automatically submit form
    event.preventDefault();
    this.setState({ loading: true, errorMessage: "" });

    try {
      const accounts = await web3.eth.getAccounts();
      await hq.methods
        .createCampaign(this.state.minimumContribution)
        .send({ from: accounts[0] });
      Router.pushRoute("/"); // Redirect user to root route (home page)
    } catch (err) {
      this.setState({ errorMessage: err.message });
    }
    this.setState({ loading: false });
  };

  render() {
    return (
      <Layout>
        <h3>Create a New Campaign</h3>
        <Form onSubmit={this.onSubmit} error={!!this.state.errorMessage}>
          <Form.Field>
            <label>Minimum Contribution</label>
            <Input
              labelPosition="right"
              label="wei"
              value={this.state.minimumContribution}
              onChange={event =>
                this.setState({ minimumContribution: event.target.value })
              }
            />
          </Form.Field>
          <Message error header={"Oops!"} content={this.state.errorMessage} />
          <Button primary loading={this.state.loading}>
            Create Campaign!
          </Button>
        </Form>
      </Layout>
    );
  }
}

export default CampaignNew;

/*pass "" (false) to error upon first load*/
