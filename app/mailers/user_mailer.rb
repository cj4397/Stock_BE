class UserMailer < ApplicationMailer
    default from: 'from@example.com'

    def welcome_email
 @user = params[:user]
    @url  = 'https://stocks-fe.vercel.app/'
    mail(to:'calbo12244397@gmail.com', subject: 'Welcome to My Awesome Site')

        # mail(
        # to: 'calbo12244397@gmail.com',
        # subject: 'Any subject you want',
        # body: 'Lorem Ipsum notifications'
        # )

    end
end
