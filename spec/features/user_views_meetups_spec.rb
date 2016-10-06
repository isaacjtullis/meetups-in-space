require 'spec_helper'

feature "View list of meetups" do
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
  scenario "See Meetups" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )
    visit '/'

    expect(page).to have_content("BLASTOFF")
  end

  scenario "Clicking Meetup Name sends me to show page" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )

    visit '/'
    sign_in_as user

    click_link("BLASTOFF")
    expect(page).to have_content("BLASTOFF")
    expect(page).to have_content("TEN MILES OFF MARS ATMOSPHERE")
    expect(page).to have_content("We really enjoy seeing space right up close.")
  end

  scenario "Meetup Show Page should have user displayed" do
    Meetup.create(
      name: "BLASTOFF",
      location: "TEN MILES OFF MARS ATMOSPHERE",
      description: "We really enjoy seeing space right up close.",
      user_id: 1
    )

    visit '/'
    sign_in_as user

    click_link("BLASTOFF")
    expect(page).to have_content("BLASTOFF")
    expect(page).to have_content("TEN MILES OFF MARS ATMOSPHERE")
    expect(page).to have_content("We really enjoy seeing space right up close.")
    expect(page).to have_content("jarlax1")
  end
end
