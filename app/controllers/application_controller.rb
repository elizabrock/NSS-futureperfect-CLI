class ApplicationController
  include Formatter

  def initialize params
    @params = params
  end

  private

  def params
    @params
  end
end
