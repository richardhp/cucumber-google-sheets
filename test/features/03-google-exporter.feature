Feature: Google Exporter
  This will dump the results into a google spreadsheet.  The spreadsheet has a template that allows easy viewing of test results, with some metrics as well

  @manual
  Scenario: Authenticate
    When I have the correct env vars set
    Then I can create an authenticated client to access the sheet

  @skip
  Scenario: Dump new results into sheet
    Given I have read an ndjson doc
    And the OUTPUT_GOOGLE env var is set to true
    When I compute the array of array of data
    Then I output it to a new sheet in the google document

  @skip
  Scenario: Update google doc dashboard
    When I output it to a new sheet in the google document
    Then I update the dashboard sheet to show the new results
    And update the metrics tables so the charts are up to date