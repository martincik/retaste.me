Feature: Profile
  In order manage user profile
  as a user
  wants profile page 

  Scenario: Edit user
    Given a user is logged in as user
      And I am on the edit profile page for logged in user
    When I fill in "Username" with "Laco"
      And I fill in "Name" with "Ladislav Martincik"
      And I fill in "Email" with "ladislav.martincik@gmail.com"
      And I press "Update"
    Then I should see "User profile successfully updated."
    
  Scenario: Edit user with blank email
    Given a user is logged in as user
      And I am on the edit profile page for logged in user
    When I fill in "Email" with ""
      And I press "Update"
    Then I should see "Email can't be blank"
    
  Scenario: Create profile
    Given a user is logged in as user
      And I am on the new profile page for logged in user
    When I fill in "Username" with "Netro"
      And I fill in "Name" with "Petr Zaparka"
      And I fill in "Email" with "netro82@gmail.com"
      And I press "Update"
    Then I should see "User profile successfully created."
    