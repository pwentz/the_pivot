require 'rails_helper'

RSpec.feature "Visitor can add items to cart" do
  scenario "they see the items in their cart" do

    Cart.new(nil)
    business = create(:business)
    location = create(:location) do |loc|
      loc.properties.create(attributes_for(:property, business_id: business.id))
    end
    property = location.properties.first

    visit property_path(property, business_name: property.business.slug)

    expect(page).to have_content("Cart Items: 0")

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "08/30/2016"
    fill_in 'booking[end_date]', with: "09/05/2016"

    click_on "Book Me"

    expect(page).to have_content("Cart Items: 1")

    click_link("Cart Items")

    expect(current_path).to eq('/cart')
    expect(page).to have_content(business.name)
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
    expect(page).to have_content("$120,000.00")
    expect(page).to have_content("Total Guests: 2")
    expect(page).to have_content("Check-In: 08/30/2016")
    expect(page).to have_content("Check-Out: 09/05/2016")
    expect(page).to have_css("img[src*='http://img09.deviantart.net']")
  end

  scenario "a visitor can add multiple items to their cart" do
    Cart.new(nil)
    business = create(:business)
    location = create(:location) do |loc|
      loc.properties.create(attributes_for(:property, business_id: business.id))
      loc.properties.create(attributes_for(:property, business_id: business.id, price_per_guest: 3000.0, max_occupancy: 6, title: "The Waldorf", description: "Nice rooms" ))
    end
    property = location.properties.first
    property2 = location.properties.last

    visit property_path(property, business_name: property.business.slug)

    expect(page).to have_content("Cart Items: 0")

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "08/30/2016"
    fill_in 'booking[end_date]', with: "09/05/2016"

    click_on "Book Me"

    visit property_path(property2, business_name: property.business.slug)

    expect(page).to have_content("Cart Items: 1")

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "09/06/2016"
    fill_in 'booking[end_date]', with: "09/09/2016"

    click_on "Book Me"

    expect(page).to have_content("Cart Items: 2")

    click_link("Cart Items")

    expect(current_path).to eq('/cart')
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
    expect(page).to have_content("$120,000.00")
    expect(page).to have_content("Total Guests: 2")
    expect(page).to have_content("Check-In: 08/30/2016")
    expect(page).to have_content("Check-Out: 09/05/2016")
    expect(page).to have_css("img[src*='http://img09.deviantart.net']")
    expect(page).to have_content(property2.title)
    expect(page).to have_content(property2.description)
    expect(page).to have_content("$18,000.00")
    expect(page).to have_content("Total Guests: 2")
    expect(page).to have_content("Check-In: 09/06/2016")
    expect(page).to have_content("Check-Out: 09/09/2016")
    expect(page).to have_css("img[src*='http://img09.deviantart.net']")
    expect(page).to have_content("$138,000.00")
  end

  scenario "they can add multiple items to their cart from different businesses" do
    Cart.new(nil)
    user = create(:user)
    user2 = create(:user, username: "Jason")
    business = create(:business, user: user)
    business2 = create(:business, name: "The Waldorf", user: user2)
    location = create(:location) do |loc|
      loc.properties.create(attributes_for(:property, business_id: business.id))
      loc.properties.create(attributes_for(:property, business_id: business2.id, price_per_guest: 3000.0, max_occupancy: 6, title: "The Waldorf", description: "Nice rooms"))
    end
    property = location.properties.first
    property2 = location.properties.last

    visit property_path(property, business_name: property.business.slug)

    expect(page).to have_content("Cart Items: 0")

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "08/30/2016"
    fill_in 'booking[end_date]', with: "09/05/2016"

    click_on "Book Me"

    visit property_path(property2, business_name: property.business.slug)

    expect(page).to have_content("Cart Items: 1")

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "09/06/2016"
    fill_in 'booking[end_date]', with: "09/09/2016"

    click_on "Book Me"

    expect(page).to have_content("Cart Items: 2")

    click_link("Cart Items")

    expect(current_path).to eq('/cart')
    expect(page).to have_content(business.name)
    expect(page).to have_content(property.title)
    expect(page).to have_content(property.description)
    expect(page).to have_content("$120,000.00")
    expect(page).to have_content("Total Guests: 2")
    expect(page).to have_content("Check-In: 08/30/2016")
    expect(page).to have_content("Check-Out: 09/05/2016")
    expect(page).to have_css("img[src*='http://img09.deviantart.net']")
    expect(page).to have_content(business2.name)
    expect(page).to have_content(property2.title)
    expect(page).to have_content(property2.description)
    expect(page).to have_content("$18,000.00")
    expect(page).to have_content("Total Guests: 2")
    expect(page).to have_content("Check-In: 09/06/2016")
    expect(page).to have_content("Check-Out: 09/09/2016")
    expect(page).to have_css("img[src*='http://img09.deviantart.net']")
    expect(page).to have_content("$138,000.00")
  end

  scenario "they see a flash notice when adding item to cart" do
    Cart.new(nil)
    business = create(:business)
    location = create(:location) do |loc|
      loc.properties.create(attributes_for(:property, business_id: business.id))
    end
    property = location.properties.first

    visit property_path(property, business_name: property.business.slug)

    find('#booking_occupancy').find(:xpath, 'option[2]').select_option
    fill_in 'booking[starting_date]', with: "08/30/2016"
    fill_in 'booking[end_date]', with: "09/05/2016"

    click_on "Book Me"

    within(".flash-success") do
      expect(page).to have_content("Successfully added booking to cart!")
    end
  end
end
