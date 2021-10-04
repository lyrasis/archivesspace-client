Feature: Version
  Scenario: Output with 'v'
    When I run `asclient v`
    Then the output should match /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/

  Scenario: Output with -v
    When I run `asclient -v`
    Then the output should match /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/

  Scenario: Output with --version
    When I run `asclient --version`
    Then the output should match /^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/
