require 'umatic'
require 'minitest/autorun'

describe Umatic::HTTPClient do

	it "can find correct url with redirections" do
		link = "http://google.com/"
		page = Umatic::HTTPClient.instance.open(link)
		page.wont_be_nil
		page.must_be_instance_of String
		page.must_equal "http://www.google.com/"
	end

	it "can fetch url content" do
		content = Umatic::HTTPClient.instance.get("http://www.google.com/")
		content.wont_be_nil
		content.must_be_instance_of String
		content.must_match(/I'm Feeling Lucky/)
	end

	it "can even fetch https url content" do
		content = Umatic::HTTPClient.instance.get("https://www.google.com/")
		content.wont_be_nil
	end

end
