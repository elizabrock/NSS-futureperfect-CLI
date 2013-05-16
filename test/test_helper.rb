require 'test/unit'
require_relative '../bootstrap_ar'

module DatabaseCleaner
  def after_teardown
    super
    Project.destroy_all
  end
end
