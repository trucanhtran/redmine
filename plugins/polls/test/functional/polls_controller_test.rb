require File.expand_path('../../test_helper', __FILE__)

class PollsControllerTest < ActionController::TestCase
  fixtures :projects

  # Replace this with your real tests.
  def test_truth
    get :index, params: { project_id: 1 }

    assert_response :success
    assert_template 'index'

  end
end
