class TicketsControllerTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

  setup do
    WebMock.disable_net_connect!(allow_localhost: true)
  end

	test "retrieving tickets succeeds when email provided" do
		setup_session_email
		get "/tickets"
		assert_response :success
	end

  test "retrieving tickets should redirect to home page if no email provided" do
    get "/tickets"
    assert_equal "Couldn't authenticate you", flash[:notice]
    assert_redirected_to "/"
  end

  test "retrieving tickets fails if invalid email provided" do
    setup_invalid_session_email
    get "/tickets"
    assert_equal "Couldn't authenticate you", flash[:notice]
    assert_redirected_to "/"
  end

  test "visiting new ticket page succeeds when email provided" do
		setup_session_email
		get "/tickets/new"
		assert_response :success
	end

  test "visiting new ticket page should redirect to home page if no email provided" do
    get "/tickets/new"
    assert_equal "You must set your email first!", flash[:notice]
    assert_redirected_to "/"
  end

  test "creating new ticket succeeds and redirects to tickets page" do
    post_params = {"external_id"=>"", "type"=>"", "subject"=>"", "description"=>"foo", "priority"=>"", "status"=>"new", "recipient"=>""}
    setup_session_email
    create_ticket(post_params)

    assert_redirected_to "/tickets/new"
  end

  test "creating new ticket fails when no description provided" do
    post_params = {"external_id"=>"", "type"=>"", "subject"=>"", "priority"=>"", "status"=>"new", "recipient"=>""}
    setup_session_email
    create_ticket(post_params)
    assert_redirected_to "/tickets/new"
    assert_equal "Error: RecordInvalid", flash[:notice]
  end

  test "viewing individual ticket succeeds when email provided" do
    setup_session_email
    stub_individual_ticket_api_call
    get "/tickets/1"
    assert_includes @response.body, "Sample ticket: Meet the ticket"
    assert_response :success
  end

  test "viewing individual ticket redirects to home page if no email provided" do
    get "/tickets/1"
    assert_redirected_to "/"
  end

  test "viewing individual ticket fails if invalid email provided" do
    setup_invalid_session_email
    get "/tickets/1"
    assert_redirected_to "/"
  end

  private

  def create_ticket(params)
    post "/tickets", params: params
  end

  def stub_individual_ticket_api_call
    WebMock.stub_request(:any, Rails.application.config.zendesk_api_ticket_url + "1.json").to_return(
      :status => 200,
      :body => {
        "ticket": {
            "url": "https://z3nsqidexercise-michaelduan.zendesk.com/api/v2/tickets/1.json",
            "id": 1,
            "external_id": nil,
            "via": {
                "channel": "sample_ticket",
                "source": {
                    "from": {},
                    "to": {},
                    "rel": nil
                }
            },
            "created_at": "2018-12-31T03:08:14Z",
            "updated_at": "2018-12-31T03:08:15Z",
            "type": "incident",
            "subject": "Sample ticket: Meet the ticket",
            "raw_subject": "Sample ticket: Meet the ticket",
            "description": "Hi z3nsqidexercise-,\n\nEmails, chats, voicemails, and tweets are captured in Zendesk Support as tickets. Start typing above to respond and click Submit to send. To test how an email becomes a ticket, send a message to support@z3nsqidexercise-michaelduan.zendesk.com.\n\nCurious about what your customers will see when you reply? Check out this video:\nhttps://demos.zendesk.com/hc/en-us/articles/202341799\n",
            "priority": "normal",
            "status": "open",
            "recipient": nil,
            "requester_id": 374758825032,
            "submitter_id": 374744995552,
            "assignee_id": 374744995552,
            "organization_id": nil,
            "group_id": 360003448052,
            "collaborator_ids": [],
            "follower_ids": [],
            "email_cc_ids": [],
            "forum_topic_id": nil,
            "problem_id": nil,
            "has_incidents": false,
            "is_public": true,
            "due_at": nil,
            "tags": [
                "sample",
                "support",
                "zendesk"
            ],
            "custom_fields": [],
            "satisfaction_rating": nil,
            "sharing_agreement_ids": [],
            "fields": [],
            "followup_ids": [],
            "brand_id": 360001988452,
            "allow_channelback": false,
            "allow_attachments": true
        }
      }.to_json
    )
  end

  def stub_all_tickets_api_call
    WebMock.stub_request(:get, Rails.application.config.zendesk_api_url).to_return(
      :status => 200,
      :body => {
          "tickets": [{
            "url": "https://z3nsqidexercise-michaelduan.zendesk.com/api/v2/tickets/111.json",
            "id": 111,
            "external_id": nil,
            "via": {
                "channel": "api",
                "source": {
                    "from": {},
                    "to": {},
                    "rel": nil
                }
            },
            "created_at": "2019-01-06T22:29:23Z",
            "updated_at": "2019-01-06T22:29:23Z",
            "type": nil,
            "subject": "hey",
            "raw_subject": "hey",
            "description": "The smoke is very colorful.",
            "priority": "urgent",
            "status": "new",
            "recipient": nil,
            "requester_id": 374744995552,
            "submitter_id": 374744995552,
            "assignee_id": nil,
            "organization_id": 360193471712,
            "group_id": 360003448052,
            "collaborator_ids": [],
            "follower_ids": [],
            "email_cc_ids": [],
            "forum_topic_id": nil,
            "problem_id": nil,
            "has_incidents": false,
            "is_public": true,
            "due_at": nil,
            "tags": [],
            "custom_fields": [],
            "satisfaction_rating": nil,
            "sharing_agreement_ids": [],
            "fields": [],
            "followup_ids": [],
            "brand_id": 360001988452,
            "allow_channelback": false,
            "allow_attachments": true
          },
          {
            "url": "https://z3nsqidexercise-michaelduan.zendesk.com/api/v2/tickets/130.json",
            "id": 130,
            "external_id": "",
            "via": {
                "channel": "api",
                "source": {
                    "from": {},
                    "to": {},
                    "rel": nil
                }
            },
            "created_at": "2019-01-07T04:12:52Z",
            "updated_at": "2019-01-07T04:12:52Z",
            "type": nil,
            "subject": "",
            "raw_subject": "",
            "description": "foo",
            "priority": nil,
            "status": "new",
            "recipient": nil,
            "requester_id": 374744995552,
            "submitter_id": 374744995552,
            "assignee_id": nil,
            "organization_id": 360193471712,
            "group_id": 360003448052,
            "collaborator_ids": [],
            "follower_ids": [],
            "email_cc_ids": [],
            "forum_topic_id": nil,
            "problem_id": nil,
            "has_incidents": false,
            "is_public": true,
            "due_at": nil,
            "tags": [],
            "custom_fields": [],
            "satisfaction_rating": nil,
            "sharing_agreement_ids": [],
            "fields": [],
            "followup_ids": [],
            "brand_id": 360001988452,
            "allow_channelback": false,
            "allow_attachments": true
          }],
          "next_page": nil,
          "previous_page": nil,
          "count": 2
      }.to_json
    )
  end

  def setup_invalid_session_email
    post "/", params: { user_email: "foo@edu.uwaterloo.ca"}
  end

  def setup_session_email
  	post "/", params: { user_email: "m4duan@edu.uwaterloo.ca"}
  end
end