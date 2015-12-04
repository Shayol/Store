module CheckoutsHelper
  def checkout_progress_bar
  content_tag(:div, class: "checkout_nav") do
    wizard_steps.collect do |every_step|
      class_str = "unfinished"
      class_str = "current"  if every_step == step
      class_str = "finished" if past_step?(every_step)
      concat(
        content_tag(:div, class: "col-md-1") do
          link_to every_step.upcase, wizard_path(every_step), class: class_str
        end
      )
    end
    end
end
end
