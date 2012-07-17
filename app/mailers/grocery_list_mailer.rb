class GroceryListMailer < ActionMailer::Base
  default from: "requested.grocery.list@gmail.com"

  def generated_list_email(grocery_list_name, generated_list, to_email)
    @generated_list = generated_list
    mail(:to => to_email, :subject => "Grocery List: #{grocery_list_name}")
  end
end
