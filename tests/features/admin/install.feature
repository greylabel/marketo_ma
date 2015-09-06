@api
Feature: Module setup
  In order to prove that this module can be installed and uninstalled cleanly
  As an administrator
  I need to do the following

  Background: Reset to a clean state
    Given the "marketo_ma, marketo_ma_user, marketo_ma_webform" modules are uninstalled
    And the cache has been cleared

  @install
  Scenario: Install all Marketo MA modules
    Given the "marketo_ma, marketo_ma_user, marketo_ma_webform" modules are enabled
    And the cache has been cleared
    And I am logged in as a user with the "administrator" role
    When I go to "/admin/config/search/marketo_ma"
    Then I should see the heading "Marketo MA"
    And I should see a "#marketo-ma-admin-settings-form" element

  @uninstall
  Scenario: Disable and uninstall all Marketo MA modules
    Given the "marketo_ma, marketo_ma_user, marketo_ma_webform" modules are enabled
    And the cache has been cleared
    And I run drush "vset" "marketo_ma_bogus 'bogus'"

    When I am logged in as a user with the "administrator" role
    And I go to "/admin/config/search/marketo_ma"
    And I fill in "marketo_ma_munchkin_account_id" with "bogus"
    And I fill in "marketo_ma_munchkin_api_private_key" with "bogus"
    When I press "Save configuration"
    Then I should see "The configuration options have been saved."

    When the "marketo_ma, marketo_ma_user, marketo_ma_webform" modules are uninstalled
    And I run drush "vget" "marketo_ma --format=json"
    Then drush output should contain '{"marketo_ma_bogus":"bogus"}'
