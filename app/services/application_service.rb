class ApplicationService

  class Result
    attr_accessor :data

    # Initialize method
    def initialize
      @data = {}
    end

    # Return service result
    # @return [Boolean]
    def success?
      @success
    end

    # Setup service result if success
    # @return [Boolean]
    def success!
      @success = true
    end

    # Setup service result if failed
    # @return [Boolean]
    def failed!
      @success = false
    end
  end

  attr_reader :result

  # Contructor Method
  def initialize(params={})
    @result = Result.new
  end

  # Execute main process of service class
  def call
    begin
      yield && result.success!
    rescue => e
      Rails.logger.info "Error when execute service #{e.inspect}"
      result.failed!
    end
  end

end
