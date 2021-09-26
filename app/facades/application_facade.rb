class ApplicationFacade
  def initialize(params: nil)
    @params = params
  end

  protected

  attr_reader :params
end
