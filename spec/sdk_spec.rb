require "spec_helper"

RSpec.describe Evntaly::SDK do
  let(:developer_secret) { "dev_secret" }
  let(:project_token)    { "project_token" }
  let(:sdk)              { described_class.new(developer_secret: developer_secret, project_token: project_token) }

  describe "#initialize" do
    it "sets default values correctly" do
      expect(sdk.base_url).to eq("https://app.evntaly.com/prod")
      expect(sdk.developer_secret).to eq(developer_secret)
      expect(sdk.project_token).to eq(project_token)
      expect(Evntaly::SDK.tracking_enabled?).to be true
    end
  end

  describe "#set_timeout" do
    it "updates the timeout value" do
      sdk.set_timeout(20)
      expect(sdk.timeout).to eq(20)
    end
  end

  describe "#check_limit" do
    it "returns true if limit is not reached" do
      response = instance_double(Net::HTTPResponse, body: { limitReached: false }.to_json)
      allow(sdk).to receive(:send_request).and_return(response)

      expect(sdk.check_limit).to be true
    end

    it "returns false if limit is reached" do
      response = instance_double(Net::HTTPResponse, body: { limitReached: true }.to_json)
      allow(sdk).to receive(:send_request).and_return(response)

      expect(sdk.check_limit).to be false
    end

    it "returns false and logs error if API format is unexpected" do
      response = instance_double(Net::HTTPResponse, body: { unexpected: true }.to_json)
      allow(sdk).to receive(:send_request).and_return(response)

      expect { sdk.check_limit }.to output(/Error checking limit/).to_stdout
      expect(sdk.check_limit).to be false
    end
  end

  describe "#track" do
    let(:event) do
      Evntaly::Event.new(
        title: "Test",
        description: "Desc",
        message: "Msg",
        data: {},
        tags: [],
        notify: false,
        icon: "icon",
        apply_rule_only: false,
        user: { id: "user123" },
        type: "info",
        session_id: "sess",
        feature: "feature",
        topic: "topic"
      )
    end

    it "tracks event when enabled and limit not reached" do
      allow(sdk).to receive(:check_limit).and_return(true)
      response = instance_double(Net::HTTPResponse, code: "200")
      allow(sdk).to receive(:send_request).and_return(response)

      expect { sdk.track(event) }.to output(/Event tracked successfully/).to_stdout
    end

    it "does not track when tracking is disabled" do
      Evntaly::SDK.disable_tracking
      expect { sdk.track(event) }.to output(/Tracking is disabled/).to_stdout
    end

    it "does not track when check_limit returns false" do
      allow(sdk).to receive(:check_limit).and_return(false)
      expect { sdk.track(event) }.to output(/checkLimit returned false/).to_stdout
    end

    it "raises error when response code is not 2xx" do
      allow(sdk).to receive(:check_limit).and_return(true)
      response = instance_double(Net::HTTPResponse, code: "500")
      allow(sdk).to receive(:send_request).and_return(response)

      expect { sdk.track(event) }.to raise_error(/Failed to track event/)
    end
  end

  describe "#identify_user" do
    let(:user) do
      Evntaly::User.new(
        id: "u1",
        email: "test@example.com",
        full_name: "Name",
        organization: "Org",
        data: {}
      )
    end

    it "sends identification request successfully" do
      response = instance_double(Net::HTTPResponse, code: "200", body: "ok")
      allow(sdk).to receive(:send_request).and_return(response)

      expect { sdk.identify_user(user) }.not_to raise_error
    end

    it "raises error on non-2xx response" do
      response = instance_double(Net::HTTPResponse, code: "500", body: "error")
      allow(sdk).to receive(:send_request).and_return(response)

      expect { sdk.identify_user(user) }.to raise_error(RuntimeError, /Failed to identify user/)
    end
  end

  describe "#disable_tracking and #enable_tracking" do
    it "toggles tracking_enabled" do
      Evntaly::SDK.disable_tracking
      expect(Evntaly::SDK.tracking_enabled?).to be false

      Evntaly::SDK.enable_tracking
      expect(Evntaly::SDK.tracking_enabled?).to be true
    end
  end
end
