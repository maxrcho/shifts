  def send_reminders(department)
    message = department.department_config.reminder_message
    @users = department.active_users.select {|u| !u.payforms.blank?}.select {|u| !u.payforms.last.submitted}
    for user in @users
      ArMailer.deliver(ArMailer.create_due_payform_reminder(user, message, department))
    end
    puts "#{@users.length} users in the #{department.name} department "  +
         "have been reminded to submit their due payforms."
  end
  
  def send_warnings(department)
    message = department.department_config.warning_message
    start_date = (w = department.department_config.warning_weeks) ? Date.today - w.week : Date.today - 4.week
    @unsubmitted_payforms =  Payform.unsubmitted.in_department(department).between(start_date, Date.today)
  
    for payform in @unsubmitted_payforms     
        weeklist = payform.date.strftime("\t%b %d, %Y\n")
        ArMailer.deliver(ArMailer.create_late_payform_warning(payform.user, message.gsub("@weeklist@", weeklist), department))
    end  
    puts "#{@unsubmitted_payforms.collect(&:user).uniq.count} users in the #{department.name} department "  +
         "have been warned to submit their late payforms."
  end


#rake part
desc "Send automatic reminders for due payforms"

task (:auto_warn => :environment) do
  departments_that_want_users_warned = Department.all.select { |d| d.department_config.auto_warn }
  for dept in departments_that_want_users_warned
    send_warnings(dept)
  end
end

desc "Send automatic warnings for late payforms"

task (:auto_remind => :environment) do
  departments_that_want_users_reminded = Department.all.select { |d| d.department_config.auto_remind }
  for dept in departments_that_want_users_reminded
    send_reminders(dept)
  end
end
