AN.configure do |an|
  an.session_secret   = ENV['APP_SESSION_SECRET']
  an.session_secret ||= 'UuEo0OiCvSXRUHmCRahKRQLoDgoBz5lpKmwHxXh3QT89nBcVHljiqD8z0ODs2DiU' if AN.development? or AN.test?
#  AN.logger.error "There is no :session_secret provided!  Please specify one in ENV['APP_SESSION_SECRET']." unless an.session_secret
end
