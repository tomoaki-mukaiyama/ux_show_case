class ApplicationController < ActionController::API

    def response_bad_request
      render status: 400, json: { status: 400, 
                                  message: 'Bad Request', 
                                  invalid_url: 'page & limit must exist'
                                }
    end

    def response_not_found
      render status: 404, json: { status: 404,message: 'Not Found'}
    end
    def respond_tag_type_error
      render status: 400, json: { status: 400, message: "must be userflow_tag"}
    end

end
