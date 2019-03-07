ado("que eu esteja no google") do
  visit('http://www.google.com')
end

Quando("busco por selenium ruby bindings") do
  fill_in('q', :with => 'selenium ruby').native.send_keys(:return)
end

Então("acho as inforações sobre selenium ruby") do
  assert_text('ruby' , 'selenium')
end

Então("bindings") do
  assert_text('bindings')
end

