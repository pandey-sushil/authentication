# This is a base controller which catches the unhandled exceptions of the 
# derived classes and notifies the stakeholders.
module Authentication
  class ApplicationController < ActionController::Base
    include Authentication::RenderError
    rescue_from Exception do |e|
      ExceptionNotifier.notify_exception(e, exception_recipients: GlobalConstant::TEST_DEVS, data: params.permit!)
      render json: {hasErrors: true, success: false, errorCode: 'REQUEST_FAILED'}, status: :expectation_failed
    end
  end
end
