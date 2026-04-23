@ignore
Feature: Common authentication

  Scenario: Get auth token
    Given url baseUrl + '/auth/login'
    And request { username: '#(username)', password: '#(password)' }
    When method POST
    Then status 200
    And def authToken = response.token
