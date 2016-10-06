require 'spec_helper'

feature "User can see other users" do
  let(:user) do
    user = User.create(
      id: 1,
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  let(:user_one) do
    user_one = User.create(
      id: 2,
      provider: "github",
      uid: "2",
      username: "bingbo1",
      email: "bingbo1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "successful addition of a member into a meetup" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )

    visit "/"
    sign_in_as user
    click_link("Sign Out")
    sign_in_as user_one

    click_link("BLASTOFF")
    click_button("JOIN!")

    expect(page).to have_content("bingbo1")
  end

  scenario "two members added to a meetup" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )

    user_two = User.create(
      id: 3,
      provider: "github",
      uid: "3",
      username: "loslos2",
      email: "loslos2@me.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    visit "/"
    sign_in_as user
    click_link("Sign Out")
    sign_in_as user_one

    click_link("BLASTOFF")
    click_button("JOIN!")
    visit "/"
    click_link("Sign Out")

    visit "/"
    sign_in_as user_two
    click_link("BLASTOFF")
    click_button("JOIN!")

    expect(page).to have_content("bingbo1")
    expect(page).to have_content("loslos2")
  end

  scenario "user gets error message if they join twice" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )

    visit "/"
    sign_in_as user
    click_link("Sign Out")
    sign_in_as user_one

    click_link("BLASTOFF")
    click_button("JOIN!")
    click_button("JOIN!")


    expect(page).to have_content("You have already joined this meetup!")
  end
  scenario "multiple users can join a meetup but an error message appears if one joins twice" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )

    user_two = User.create(
      id: 3,
      provider: "github",
      uid: "3",
      username: "loslos2",
      email: "loslos2@me.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    visit "/"
    sign_in_as user
    click_link("Sign Out")
    sign_in_as user_one

    click_link("BLASTOFF")
    click_button("JOIN!")
    visit "/"
    click_link("Sign Out")

    visit "/"
    sign_in_as user_two
    click_link("BLASTOFF")
    click_button("JOIN!")
    click_button("JOIN!")

    expect(page).to have_content("bingbo1")
    expect(page).to have_content("loslos2")
    expect(page).to have_content("You have already joined this meetup!")
  end
end
