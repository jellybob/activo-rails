Dummy::Application.routes.draw do
  match 'secondary_navigation_test' => "application#secondary_navigation_test"
  match 'control_sets_test' => "application#control_sets_test"
  match 'breadcrumbs_test' => "application#breadcrumbs_test"
  match 'content_boxes/vanilla' => "content_boxes#vanilla"
  match 'content_boxes/with_classes' => "content_boxes#with_classes"
  match 'content_boxes/with_id' => "content_boxes#with_id"
end
