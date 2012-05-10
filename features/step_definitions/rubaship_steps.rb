Then /^I should see the message:$/ do |message|
  steps %{
    Then the output should match:
    """
    #{message}
    """
  }
end
