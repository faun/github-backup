require 'spec_helper'
require 'api_spike'

describe ApiSpike do
  it "should list gist URLs" do
    urls = subject.gist_urls
    p urls
    urls.should_not be_empty
  end
end
