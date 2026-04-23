Feature: Orders API (Posts as proxy)

  Background:
    Given url baseUrl

  @smoke
  Scenario: Get all orders
    Given path '/posts'
    When method GET
    Then status 200
    And match response == '#[] #object'

  @smoke
  Scenario: Create a new order
    Given path '/posts'
    And request { userId: 1, title: 'New Order', body: 'Order details' }
    When method POST
    Then status 201
    And match response.id == '#number'
    And match response.title == 'New Order'

  @regression
  Scenario: Create order with data file
    * def orderData = read('data/orders-data.json')
    Given path '/posts'
    And request orderData[0]
    When method POST
    Then status 201
    And match response.userId == orderData[0].userId
