Feature: CSV Exporter
  This container can indeed export to google sheets, but this is not required.  You can also just dump a CSV for local viewing in your spreadsheet software of choice

  @skip
  Scenario: Export to array of arrays
    Given I have created an ndjson cucmber message file
    When I parse it
    Then I output an array of arrays in the correct format

  @skip
  Scenario: Export to CSV
    Given I have the OUTPUT_CSV env var enabled
    And I have the output dir mounted into the container
    When I produce an array of arrays
    Then it gets dumped to a CSV file on the host machine