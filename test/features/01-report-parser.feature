Feature: Report Parser
  This will load in a report in the ndjson format and extract the data we need.  By using the standard message format this makes this feature compatible with any cucumber implementation in any language

  @manual
  Scenario: Ingest output from another tool
    Given I have some feature specs
    And I have run them in the language / tool of my choice
    And the cucumber runtime has output an ndjson document
    When this document is mounted into this docker container
    Then this docker container will extract the required output