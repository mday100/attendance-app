class Visitor < ActiveRecord::Base
	has_no_table
	column :email, :string
	column :fname, :string
	column :lname, :string
	validates_presence_of :email, :fname, :lname
	validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

	def subscribe
		mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key) 
		result = mailchimp.lists.subscribe({
			:id => Rails.application.secrets.mailchimp_list_id, 
			:email => {:email => self.email},
			:merge_vars => {:FNAME => self.fname,
							:LNAME => self.lname},
			:double_optin => false,
			:update_existing => true,
			:send_welcome => true 
			})
		Rails.logger.info("#{self.email} just signed in.") if result 
	end

end