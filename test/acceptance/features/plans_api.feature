# Automatically generated by Honest Code
# Do not edit this file as it will be overwritten

Feature: Plans API
  As an user
  I want to use the Plans API Endpoints

  Scenario: Delete plan
    Given a plan exists in the database
    And the attack1 module is available in attacks
    And 2 executors for attack1 exists in the database related to the plan
    When the user makes a "DELETE" request to "/plans/{plan_id}" endpoint
    Then no plans exists in the database
    And no executors exists in the database

  Scenario: Get plans endpoint returns all plans when option all is set to true
    Given a plan exists in the database
    And a plan marked as executed exists in the database
    When the user makes a "GET" request to "/plans/" endpoint with querystring
      | querystring  |
      | {"all":true} |
    Then the api responds with 2 plans
    And the response is HAL

  Scenario: Execute Plan
    Given the two_executors module is available in planners
    And the attack1 module is available in attacks
    When the user makes a "POST" request to "/plans/" endpoint with payload
      | payload                                                                                                                                                 |
      | {"name":"test plan", "attack":{"ref":"test.attacks.attack1:Attack1","args":{}}, "planner":{"ref":"test.planners.two_executors:TwoExecutors","args":{}}} |
    Then 2 executors are created in the database
    And 1 plans are created in the database
    And the executors are related to the created plan in the database

  Scenario: Get plans endpoint return only active plans
    Given a plan exists in the database
    And a plan marked as executed exists in the database
    When the user makes a "GET" request to "/plans/" endpoint
    Then the api responds with 1 plans
    And the response is HAL

  Scenario Outline: Execute Plan validates the attack payload
    Given the planner1 module is available in planners
    And the required_schema module is available in attacks
    When the user makes a "POST" request to "/plans/" endpoint with <payload>
    Then the api response code is <response_code>
    And the api response payload is <response>

    Examples:
      | payload                                                                                                                                                                                            | response_code | response                                                      |
      | {"name":"test plan", "attack":{"ref":"test.attacks.required_schema:RequiredSchema","args":{}},"planner":{"ref":"test.planners.planner1:Planner1","args":{}}}                                       | 400           | {"msg": "invalid payload 'property1' is a required property"} |
      | {"name":"test plan", "attack":{"ref":"test.attacks.required_schema:RequiredSchema","args":{"property1":"test"}},"planner":{"ref":"test.planners.planner1:Planner1","args":{}}}                     | 400           | {"msg": "invalid payload 'property2' is a required property"} |
      | {"name":"test plan", "attack":{"ref":"test.attacks.required_schema:RequiredSchema","args":{"property1":"test", "property2":"test"}},"planner":{"ref":"test.planners.planner1:Planner1","args":{}}} | 200           | {"msg": "ok"}                                                 |

  Scenario Outline: Execute Plan validates the planner payload
    Given the required_schema module is available in planners
    And the attack1 module is available in attacks
    When the user makes a "POST" request to "/plans/" endpoint with <payload>
    Then the api response code is <response_code>
    And the api response payload is <response>

    Examples:
      | payload                                                                                                                                                                                           | response_code | response                                                      |
      | {"name":"test plan", "attack":{"ref":"test.attacks.attack1:Attack1","args":{}},"planner":{"ref":"test.planners.required_schema:RequiredSchema","args":{}}}                                        | 400           | {"msg": "invalid payload 'property1' is a required property"} |
      | {"name":"test plan", "attack":{"ref":"test.attacks.attack1:Attack1","args":{}},"planner":{"ref":"test.planners.required_schema:RequiredSchema","args":{"property1":"test"}}}                      | 400           | {"msg": "invalid payload 'property2' is a required property"} |
      | {"name":"test plan", "attack":{"ref":"test.attacks.attack1:Attack1","args":{}},"planner":{"ref":"test.planners.required_schema:RequiredSchema","args":{"property1":"test", "property2": "test"}}} | 200           | {"msg": "ok"}                                                 |
