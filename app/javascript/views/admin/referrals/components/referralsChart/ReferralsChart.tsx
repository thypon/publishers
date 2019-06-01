import * as React from "react";

import Select from "brave-ui/components/formControls/select";
import Chart from "chart.js";
import Card from "../../../../../components/card/Card";

interface IReferralsChartProps {
  referralCodes: any;
}

interface IReferralsChartState {
  selectedReferralCode: any;
  downloadsToggle: any;
  installsToggle: any;
  confirmationsToggle: any;
}

export default class Referrals extends React.Component<
  IReferralsChartProps,
  IReferralsChartState
> {
  private node;
  constructor(props) {
    super(props);
    this.state = {
      confirmationsToggle: true,
      downloadsToggle: true,
      installsToggle: true,
      selectedReferralCode: 0
    };
  }

  public componentDidMount() {
    this.createReferralsChart(
      this.props.referralCodes[this.state.selectedReferralCode]
    );
  }

  public componentDidUpdate() {
    this.createReferralsChart(
      this.props.referralCodes[this.state.selectedReferralCode]
    );
  }

  public handleReferralCodeSelect = e => {
    this.setState({ selectedReferralCode: e.target.value });
  };

  public handleDataSelect = index => {
    switch (index) {
      case 0:
        this.setState(prevState => ({
          downloadsToggle: !prevState.downloadsToggle
        }));
        break;
      case 1:
        this.setState(prevState => ({
          installsToggle: !prevState.installsToggle
        }));
        break;
      case 2:
        this.setState(prevState => ({
          confirmationsToggle: !prevState.confirmationsToggle
        }));
        break;
    }
  };

  public createReferralsChart(referralCode) {
    const node = this.node;

    if (!referralCode) {
      return;
    }
    const stats = referralCode.stats;
    const chartLabels = [];
    const downloads = [];
    const installs = [];
    const confirmations = [];

    stats.forEach((stat, index) => {
      if (index < stats.length - 1) {
        if (stat.date !== stats[index + 1].date) {
          chartLabels.push(stat.date);
          downloads.push(stat.downloads);
          installs.push(stat.installs);
          confirmations.push(stat.confirmations);
        }
      }
      if (index === stats.length - 1) {
        chartLabels.push(stat.date);
        downloads.push(stat.downloads);
        installs.push(stat.installs);
        confirmations.push(stat.confirmations);
      }
    });

    if (!this.state.downloadsToggle) {
      downloads = [];
    }
    if (!this.state.installsToggle) {
      installs = [];
    }
    if (!this.state.confirmationsToggle) {
      confirmations = [];
    }

    const chartData = {
      datasets: [
        {
          backgroundColor: "#FFFFFF00",
          borderColor: "#FF6384",
          data: downloads,
          label: "Downloads"
        },
        {
          backgroundColor: "#FFFFFF00",
          borderColor: "#36A2EB",
          data: installs,
          label: "Installs"
        },
        {
          backgroundColor: "#FFFFFF00",
          borderColor: "#9966FF",
          data: confirmations,
          label: "Confirmations"
        }
      ],
      labels: chartLabels
    };

    const chartSettings = {
      data: chartData,
      options: {
        legend: {
          display: false
        },
        scales: {
          yAxes: [
            {
              display: false
            }
          ]
        }
      },
      type: "line"
    };

    const myChart = new Chart(node, chartSettings);
  }

  public render() {
    const confirmationsOpacity = this.state.confirmationsToggle ? 1 : 0.5;
    const installsOpacity = this.state.installsToggle ? 1 : 0.5;
    const downloadsOpacity = this.state.downloadsToggle ? 1 : 0.5;
    return (
      <Card>
        <div
          style={{
            color: "#686978",
            fontSize: "22px",
            fontWeight: "bold",
            paddingBottom: "10px",
            textAlign: "center"
          }}
        >
          Referrals Stats
        </div>
        <div
          style={{
            alignItems: "center",
            display: "flex",
            justifyContent: "center",
            width: "100%"
          }}
        >
          {this.props.referralCodes.length > 0 && (
            <canvas
              style={{ height: "400px", width: "100%" }}
              ref={node => (this.node = node)}
            />
          )}
          {this.props.referralCodes.length === 0 && (
            <h5 className="mt-5 text-muted">No referral codes </h5>
          )}
        </div>
        <div
          style={{
            margin: "auto",
            paddingTop: "20px",
            textAlign: "center",
            width: "25%"
          }}
        >
          <ReferralCodeSelect
            referralCodes={this.props.referralCodes}
            handleReferralCodeSelect={this.handleReferralCodeSelect}
          />
        </div>
        <div
          style={{
            display: "flex",
            justifyContent: "center",
            marginTop: "24px"
          }}
        >
          <div>
            <div style={{ display: "flex" }}>
              <div
                onClick={() => this.handleDataSelect(2)}
                style={{
                  backgroundColor: "#9966FF",
                  borderRadius: "50%",
                  cursor: "pointer",
                  height: "16px",
                  marginRight: "4px",
                  marginTop: "4px",
                  opacity: confirmationsOpacity,
                  width: "16px"
                }}
              />
              <div
                style={{
                  color: "#686978",
                  fontSize: "16px",
                  textAlign: "center"
                }}
              >
                Confirmation
              </div>
            </div>
            <div
              onClick={() => this.handleDataSelect(1)}
              style={{ display: "flex" }}
            >
              <div
                style={{
                  backgroundColor: "#36A2EB",
                  borderRadius: "50%",
                  cursor: "pointer",
                  height: "16px",
                  marginRight: "4px",
                  marginTop: "4px",
                  opacity: installsOpacity,
                  width: "16px"
                }}
              />
              <div
                style={{
                  color: "#686978",
                  fontSize: "16px",
                  textAlign: "center"
                }}
              >
                Installs
              </div>
            </div>
            <div
              onClick={() => this.handleDataSelect(0)}
              style={{ display: "flex" }}
            >
              <div
                style={{
                  backgroundColor: "#FF6384",
                  borderRadius: "50%",
                  cursor: "pointer",
                  height: "16px",
                  marginRight: "4px",
                  marginTop: "4px",
                  opacity: downloadsOpacity,
                  width: "16px"
                }}
              />
              <div
                style={{
                  color: "#686978",
                  fontSize: "16px",
                  textAlign: "center"
                }}
              >
                Downloads
              </div>
            </div>
          </div>
        </div>
      </Card>
    );
  }
}

function ReferralCodeSelect(props) {
  const dropdownOptions = props.referralCodes.map((referralCode, index) => (
    <option key={index} value={index}>
      {referralCode.referralCode}
    </option>
  ));
  if (props.referralCodes.length > 0) {
    return (
      <select
        onChange={e => {
          props.handleReferralCodeSelect(e);
        }}
      >
        {dropdownOptions}
      </select>
    );
  } else {
    return <React.Fragment />;
  }
}
