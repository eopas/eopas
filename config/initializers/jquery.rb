# Switch the javascript_include_tag :defaults to use jquery instead of
# the default prototype helpers.
Eopas::Application.configure do
  config.action_view.javascript_expansions = { :defaults => ['jquery-1.4.2', 'rails'] }
end

