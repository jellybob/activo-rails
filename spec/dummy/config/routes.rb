Dummy::Application.routes.draw do
  match 'secondary_navigation_test' => "application#secondary_navigation_test"
  match 'control_sets_test' => "application#control_sets_test"
  match 'breadcrumbs_test' => "application#breadcrumbs_test"
  match 'content_boxes/:action', :controller => "content_boxes"
end
