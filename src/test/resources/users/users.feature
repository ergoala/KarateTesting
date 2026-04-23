Feature: Users API

  Background:
    Given url baseUrl

  @smoke
  Scenario: Get all users
    Given path '/users'
    When method GET
    Then status 200
    And match response == '#[] #object'
    And match response[0] == { id: '#number', name: '#string', username: '#string', email: '#string', address: '#object', phone: '#string', website: '#string', company: '#object' }

  @smoke
  Scenario: Get user by ID
    Given path '/users/1'
    When method GET
    Then status 200
    And match response.id == 1
    And match response.name == '#string'
    And match response.email == '#string'

  @regression
  Scenario: User not found returns 404
    Given path '/users/9999'
    When method GET
    Then status 404

  @regression
  Scenario Outline: Validate specific users
    Given path '/users/<id>'
    When method GET
    Then status 200
    And match response.name == '<name>'

    Examples:
      | id | name            |
      | 1  | Leanne Graham   |
      | 2  | Ervin Howell    |
      | 3  | Clementine Bauch |
