class RecordMailer < ActionMailer::Base

  def submit_feedback(params, ip)
    if params[:name].present?
      @name = params[:name]
    else
      @name = 'No name given'
    end

    if params[:to].present?
      @email = params[:to]
    else
      @email = 'No email given'
    end

    @message = params[:message]
    @url = params[:url]
    @ip = ip

    mail(:to => Settings.EMAIL_TO,
         :subject => "Feedback from SearchWorks",
         :from => "feedback@searchworks.stanford.edu",
         :reply_to => Settings.EMAIL_TO)
  end
end