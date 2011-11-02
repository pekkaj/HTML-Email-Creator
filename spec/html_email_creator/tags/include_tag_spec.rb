require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe HtmlEmailCreator::IncludeTag do
    
  it "should return user's home directory based email directory" do
    run_in_fixture_dir("with_config") do
      Liquid::Template.parse("{% include 'Quotes/henry_ford' what: 'door' %}").render({}).should == "A bore is a person who opens his door and puts his feats in it."
      Liquid::Template.parse("{% include 'Quotes/henry_ford' what: 'car' %}").render({}).should == "A bore is a person who opens his car and puts his feats in it."
    end
  end
end