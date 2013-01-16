require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Form1099 INT" do
  before(:all) do
    @form1099 = IrsForms::Form1099Int.new(data: [
      {:payer_contact_information => [
        'Payer Name, LLC', 'Address Line 1',
        'City, State 00000', '(555) 555-5555'],
      :payer_federal_id => 'XX-XXXXXXX',
      :recipient_federal_id => 'YY-YYYYYY1',
      :recipient_name => 'Recipient Name',
      :recipient_street_address => 'Street Address Line 1',
      :recipient_city_state_zip => 'City, State 11111',
      :recipient_account_number => 'XXXXX',
      :interest_income => '9875383.39'},
      {:payer_contact_information => [
          'Payer Name, LLC', 'Address Line 1',
          'City, State 00000', '(555) 555-5555'],
        :payer_federal_id => 'XX-XXXXXXX',
        :recipient_federal_id => 'YY-YYYYYY2',
        :recipient_name => 'Recipient Name',
        :recipient_street_address => 'Street Address Line 1',
        :recipient_city_state_zip => 'A very long name for a City, State 11111',
        :interest_income => '999'},
      {:payer_contact_information => [
          'Payer Name, LLC', 'Address Line 1',
          'City, State 00000', '(555) 555-5555'],
        :payer_federal_id => 'XX-XXXXXXX',
        :recipient_federal_id => 'YY-YYYYYY3',
        :recipient_name => 'Recipient Name',
        :recipient_street_address => 'Street Address Line 1',
        :recipient_city_state_zip => 'City, State 11111',
        :interest_income => '9'}
    ])
  end
  it "should print correctly for each copy" do
    IrsForms::Form1099Int::COPIES.each do |copy|
      @form1099.copy = copy
      pdf = @form1099.to_pdf(:with_template => true)
      write_content_to_file("f1099int#{copy}_data_and_template.pdf", pdf)
      assert_data_matches_file_content("f1099int#{copy}_data_and_template.pdf", pdf)
    end
  end
  it "should generate with offset" do
    @form1099.x_offset = 20 # right 20px
    @form1099.y_offset = -20 # down 20px
    @form1099.copy = 'A'
    pdf = @form1099.to_pdf(:with_template => true)
    write_content_to_file("f1099intA_data_and_template_offset.pdf", pdf)
    assert_data_matches_file_content("f1099intA_data_and_template_offset.pdf", pdf)
  end
end
