require 'spec_helper'

feature "User signs in" do
    let(:user) do
      User.create(
        provider: "github",
        uid: "1",
        username: "jarlax1",
        email: "jarlax1@launchacademy.com",
        avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
      )
    end
  scenario "successful addition of meetup" do
    visit "/"
    sign_in_as user

    click_link("Add New Meetup")

    fill_in(:name, with: "TO INFINITE!")
    fill_in(:location, with: "The Nebula")
    fill_in(:description, with: "Bring your spacesuit")

    click_button("Add Meetup")

    expect(page).to have_content "TO INFINITE!"
  end

  scenario "unsuccessful form submission" do
    visit "/"
    click_link("Add New Meetup")
    click_button("Add Meetup")

    expect(page).to have_content "You must log in!"
  end

  scenario "error messages are submitted if form is empty" do
    user = User.create(
      id: 1,
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
    visit "/"
    sign_in_as user
    click_link("Add New Meetup")
    click_button("Add Meetup")

    expect(page).to have_content("ERROR: Description can't be blank")
    expect(page).to have_content("ERROR: Location can't be blank")
    expect(page).to have_content("ERROR: Name can't be blank")
  end

  scenario "Submitting Form takes you to the show page" do
    user = User.create(
      id: 1,
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )

    visit "/"
    sign_in_as user

    click_link("Add New Meetup")

    fill_in(:name, with: "TO INFINITE!")
    fill_in(:location, with: "The Nebula")
    fill_in(:description, with: "Bring your spacesuit")
    click_button("Add Meetup")

    expect(page).to have_content("TO INFINITE!")
    expect(page).to have_content("The Nebula")
    expect(page).to have_content("Bring your spacesuit")
  end

  end
