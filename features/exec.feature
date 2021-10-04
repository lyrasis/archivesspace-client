Feature: Exec
  Scenario: With an invalid request type
    When I run `asclient exec all`
    Then the output should match /asclient exec TYPE PATH/
