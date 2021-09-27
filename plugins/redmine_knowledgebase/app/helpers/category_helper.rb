module CategoryHelper
    def authorize_for(controller, action)
        User.current.allowed_to?({:controller => controller,:action =>
        action}, @project)
        End
end
