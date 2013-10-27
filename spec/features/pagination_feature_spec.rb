require 'spec_helper'

describe "Simple pagination", :feature do
  it "activates without any issues" do   
    expect {
      run_site('recipes') { activate :pagination }
    }.not_to raise_error
  end
end