require "rspec/mocks"

Before do
  $rspec_mocks ||= Rspec::Mocks::Space.new
end

After do
  begin
    $rspec_mocks.verify_all
  ensure
    $rspec_mocks.reset_all
  end
end
