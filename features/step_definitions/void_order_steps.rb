When(/^I void an order$/) do
  VCR.use_cassette('void_order') do
    @voided_order = ShipCompliant::VoidSalesOrder.by_order_key('ONS-1')
  end
end

When(/^I void an already void order$/) do
  VCR.use_cassette('void_voided_order') do
    @voided_order = ShipCompliant::VoidSalesOrder.by_order_key('ONS-1')
  end
end

Then(/^I should get a successful response$/) do
  @voided_order.success?.should be_truthy
end

Then(/^I should get an error message$/) do
  @voided_order.failure?.should be_truthy
  @voided_order.errors_count.should == 1

  error = @voided_order.errors[0]
  error.code.should == 200
  error.key.should == 'ONS-1'
  error.message.should == 'SalesOrder does not exist [ONS-1].'
  error.target.should == 'SalesOrder'
  error.type.should == 'Validation'
end
