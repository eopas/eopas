# Monky Patch capybara to support delete
# class Capybara::Driver::RackTest < Capybara::Driver::Base
#   def visit_delete(path, attributes = {})
#     process(:delete, path, attributes)
#   end
# end
# 
# module Capybara
#   class Session
#     def visit_delete(url)
#       driver.visit_delete(url)
#     end
#   end
# 
#   class_eval <<-RUBY, __FILE__, __LINE__+1
#     def visit_delete(*args, &block)
#       page.visit_delete(*args, &block)
#     end
#   RUBY
# 
# end



