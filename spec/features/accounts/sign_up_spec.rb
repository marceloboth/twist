require "rails_helper"

feature "Accounts" do
  scenario "creating an account" do
    visit root_path
    click_link "Create a new account"

    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create Account"

    expect(page).to have_content("Signed in as test@example.com")
    expect(page).to have_content("Your account has been successfully created.")
    expect(page.current_url).to eq("http://test.lvh.me/")
  end

  scenario "ensure subdomain is uniqueness" do
    Account.create!(subdomain: "test", name: "Text")

    visit root_path
    click_link "Create a new account"

    fill_in "Name", with: "Test"
    fill_in "Subdomain", with: "test"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"

    click_button "Create Account"

    expect(page.current_url).to eq("http://lvh.me/accounts")
    expect(page).to have_content("Sorry, your account could not be created.")

    subdomain_error = find('.account_subdomain .help-block').text
    expect(subdomain_error).to have_content("has already been taken")
  end
end
