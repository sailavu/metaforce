require 'spec_helper'

describe Metaforce::Job::Deploy do
  let(:client) { double('metadata client') }
  let(:path) { File.expand_path('../../../fixtures/payload.zip', __FILE__) }
  let(:job) { described_class.new client, path }

  describe '.payload' do
    subject { job.payload }

    context 'when the path is a file' do
      it { should be_a String }
    end

    context 'when the path is a directory' do
      let(:path) { File.expand_path('../../../fixtures', __FILE__) }
      it { should be_a String }
    end
  end

  describe '.perform' do
    before do
      client.should_receive(:deploy).with(job.payload, {}).and_return(Hashie::Mash.new(id: '1234'))
    end

    subject { job.perform }
    it { should be_a String }
  end

  describe '.status' do
    before do
      client.should_receive(:status).with(job.id, :deploy).and_return(Hashie::Mash.new(done: true))
    end

    subject { job.status }
    its(:done) { should be_true }
  end

  describe '.done?' do
    before do
      client.should_receive(:status).with(job.id, :deploy).and_return(Hashie::Mash.new(done: done))
    end

    context 'when done' do
      let(:done) { true }
      subject { job.done? }
      it { should be_true }
    end

    context 'when not done' do
      let(:done) { false }
      subject { job.done? }
      it { should be_false }
    end
  end
end
