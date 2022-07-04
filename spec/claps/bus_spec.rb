# frozen_string_literal: true

RSpec.describe Claps::Bus do
  context "when handler is not registered" do
    it "raises an error" do
      expect { subject.call "entity.create" }.to raise_error Claps::UnregisteredHandlerError
    end
  end

  context "when handler is already registered" do
    let(:handler_mock) { spy }
    let(:params) { { id: 1 } }

    before :each do
      subject.register command: "entity.create", handler: handler_mock
    end

    it "raises an error" do
      expect do
        subject.register command: "entity.create", handler: -> {}
      end.to raise_error Claps::MultipleHandlerError
    end

    it "executes the handler" do
      subject.call "entity.create", params

      expect(handler_mock).to have_received(:call).with(params)
    end
  end
end
