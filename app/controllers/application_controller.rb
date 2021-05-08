class ApplicationController < ActionController::API

    def response_bad_request
      render status: 400, json: { status: 400, 
                                  message: 'Bad Request', 
                                  invalid_params: [
                                                    { 
                                                      reason: "page & limit must both exist and must be a '0 =< int' ",
                                                      example: "?page=2&limit=2",
                                                      note: "0 will be used as 1"
                                                    }
                                                  ]
                                }
    end

    def response_not_found
      render status: 404, json: { status: 404,message: 'Not Found'}
    end

end
