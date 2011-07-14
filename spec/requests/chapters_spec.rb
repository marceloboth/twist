require 'spec_helper'

describe 'chapters' do
  let(:user) { create_user! }
  before do
    Resque.remove_queue("normal") # TODO: is there a better way than just putting this *everywhere*?
    @book = Book.create(:title => "Rails 3 in Action", 
                        :path => "http://github.com/radar/rails3book_test")
    run_resque_job!
    actually_sign_in_as(user)
  end
  
  it "can view a given chapter and its parts" do
    visit book_chapter_path(@book, @book.chapters.first)
    page!
    
    # Paragraph test
    within "p#ch01_3" do
      page.should have_content("It's great to have you with us on this journey throughout the world of Ruby on Rails.")
    end
    
    # Section test
    within "h2#ch01_5" do
      page.should have_content("1.1 What is Ruby on Rails?")
    end
    
    page.find("a#ch01_797")["href"].should == "http://en.wikipedia.org/wiki/MIT_License"
    
    # Sub-section test
    within "h3" do
      page.should have_content("1.1.1 Benefits")
    end

    # Formal paragraph
    within "h4" do
      page.should have_content("MVC")
    end
    
    # Informal example
    within "pre" do
      page.should have_content("rvm install 1.9.2")
    end
    
    # Titled example
    within "div.example#ch01_428" do
      within ".title" do
        page.should have_content("app/models/purchase.rb")
      end
      
      within "pre" do
        example_text = "class Purchase < ActiveRecord::Base"
        page.should have_content(example_text)
      end
    end
    
    # Table (oh boy, these are fun!)
    within "div.table" do
      within ".title" do
        page.should have_content("Routing helpers and their routes")
      end
      within "table" do
        within "thead tr td" do
          page.should have_content("Helper")
        end
        
        within "tbody tr td" do
          page.should have_content("purchases_path")
        end
      end
    end
    
    # Notes
    within "div.note" do
      page.should have_content("In the beginning...")
    end
  end
end