Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1417945871789974', '05633d69c3785e830e86af978f164142',
           scope: "user_about_me,user_friends,friends_about_me"
end