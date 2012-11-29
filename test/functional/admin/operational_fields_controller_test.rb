require "test_helper"

class Admin::OperationalFieldsControllerTest < ActionController::TestCase
  setup do
    login_as :departmental_editor
  end

  should_be_an_admin_controller

  test "index should list policy teams ordered alphabetically by name" do
    team_b = create(:operational_field, name: "field-b")
    team_a = create(:operational_field, name: "field-a")

    get :index

    assert_equal [team_a, team_b], assigns(:operational_fields)
  end

  test "index should provide link to edit existing policy team" do
    operational_field = create(:operational_field)

    get :index

    assert_select_object(operational_field) do
      assert_select "a[href='#{edit_admin_operational_field_path(operational_field)}']"
    end
  end

  test "new should build a new policy team" do
    get :new

    refute_nil operational_field = assigns(:operational_field)
    assert_instance_of(OperationalField, operational_field)
  end

  test "new should display policy team form" do
    get :new

    assert_select "form[action=#{admin_operational_fields_path}]" do
      assert_select "input[name='operational_field[name]']"
    end
  end

  test "create should create a new policy team" do
    post :create, operational_field: { name: "field-a" }

    operational_field = OperationalField.last
    refute_nil operational_field
    assert_equal "field-a", operational_field.name
  end

  test "create should redirect to policy team list on success" do
    post :create, operational_field: { name: "field-a" }

    assert_redirected_to admin_operational_fields_path
  end

  test "create should re-render form with errors on failure" do
    create(:operational_field, name: "field-a")

    post :create, operational_field: { name: "field-a" }

    assert_template "new"
    assert_select ".errors"
  end

  test "edit should display policy team form" do
    operational_field = create(:operational_field, name: "field-a")

    get :edit, id: operational_field

    assert_select "form[action=#{admin_operational_field_path(operational_field)}]" do
      assert_select "input[name='operational_field[name]'][value='field-a']"
    end
  end

  test "udpate should modify policy team" do
    operational_field = create(:operational_field, name: "original")

    put :update, id: operational_field, operational_field: { name: "new" }

    operational_field.reload
    assert_equal "new", operational_field.name
  end
end