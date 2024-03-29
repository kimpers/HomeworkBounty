# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
#ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  #config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.before(:suite) do
    DatabaseCleaner[:mongoid].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner[:mongoid].start
  end

  config.after(:each) do
    DatabaseCleaner[:mongoid].clean
  end
	config.include Capybara::DSL
	config.before :each do
		@country = Country.create!(:name => 'South Korea')
		@school = @country.schools.create!({:name => 'KTH', :website => "kth.se", :email_domain => 'kth.se'})
		@user_args = {:username => 'auto_user', :password => 'password123', :email => 'test@kth.se', :role => 'user'}
		@user = @school.students.create!(@user_args)
		@user.confirm!
		@user2_args ={:username => 'auto_user2', :password => 'password123', :email => 'test2@kth.se', :role => 'user'}
		@user2 = @school.students.create!(@user2_args)
		@user2.confirm!
		@category = Category.create!({:name => 'Computer science'})
		@tag = Tag.create!({:name => 'Ruby'})
		@tag1 = Tag.create!({:name => 'Rails'})
		@tag2 = Tag.create!({:name => 'JQuery'})
		@question = @user.questions_made.create!({:title => 'Räven raskar över isen',:body => 'Men han är lika glad för det', :question_category => @category._id,:tags => [@tag,@tag2]})
		@answer = @question.answers.create!({:body => "test answer", :author_to_answer => @user})
		@answer2 = @question.answers.create!({:body => "test answer2", :author_to_answer => @user2})
		@reply = @answer.replies.create!(:body => "test reply", :author =>  @user2.username, :count => @answer.replies.length+1)
		@reply1 = @answer.replies.create!(:body => "second reply", :author =>  @user.username, :count => @answer.replies.length+1)
	end
end

