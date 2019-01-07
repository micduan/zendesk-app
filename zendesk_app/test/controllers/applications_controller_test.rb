class TicketsControllerTest < ActionDispatch::IntegrationTest
  	test "should get index" do
    	get "/"
    	assert_response :success
  	end

  	test "index includes text to set email when no email provided" do
  		get "/"
  		assert_includes @response.body, "Set\n the email you're accessing the API with."
      assert_response :success
  	end

  	test "index includes text to change email when email already provided" do
  		setup_session_email
  		get "/"
  		assert_includes @response.body, "Change\n the email you're accessing the API with."
  	  assert_response :success
    end

    private

  	def setup_session_email
  		post "/", params: { user_email: "m4duan@edu.uwaterloo.ca"}
  	end
end