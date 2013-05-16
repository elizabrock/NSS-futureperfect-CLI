require 'test/unit'
require_relative '../bootstrap_ar'

module DatabaseCleaner
  def before_setup
    super
    Project.destroy_all
  end
end
