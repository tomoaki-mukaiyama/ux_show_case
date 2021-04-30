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

end
