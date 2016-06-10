require 'spec_helper'

RSpec.describe Bootscale::Cache do
  it "list all the files in the provided load paths" do
    load_path = [File.expand_path("spec/dummy/app/controllers"), File.expand_path("spec/dummy/app/helpers")]
    cache = described_class.build(load_path).to_h
    expect(cache.keys.sort).to eq %w(application_controller.rb application_helper.rb)
  end

  it "doesn't break if elements of the load path are Pathname instances" do
    load_path = [Pathname.new(File.expand_path('spec/dummy/app/controllers'))]
    cache = described_class.build(load_path).to_h
    expect(cache.keys.sort).to eq %w(application_controller.rb)
  end

  it "marks relative paths since they do not work normally or when switching directories" do
    expect_any_instance_of(Bootscale::Entry).to receive(:warn)
    load_path = ['spec/dummy/app/controllers']
    cache = described_class.build(load_path).to_h
    expect(cache).to eq "application_controller.rb" => false
  end
end
