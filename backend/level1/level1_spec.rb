require_relative 'main.rb'
require 'rspec'

RSpec.describe Main do
  it 'compares expected output and output' do
    result = Main.call
    output = JSON.parse(File.read('./data/output.json'))
    expected_output = JSON.parse(File.read('./data/expected_output.json'))
    expect(output).to eq expected_output
  end
end
