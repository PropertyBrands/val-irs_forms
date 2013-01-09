require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Form1099Misc Copy A" do
  before(:each) do
    @form1099 = IrsForms::Form1099Misc.new(copy: 'A')
  end

  it "should generate the template_filepath" do
     dir = File.expand_path(File.dirname(__FILE__) + '/../templates')
    @form1099.template_filepath.should == "#{dir}/f1099msc-copyA.pdf"
  end

  it "should generate PDF on the template" do
    pdf = @form1099.to_pdf(:with_template => true)
    write_content_to_file('copyA_with_template.pdf', pdf)
    assert_data_matches_file_content('copyA_with_template.pdf', pdf)
  end

  describe "with a three forms of data" do
    before(:each) do
      @form1099.data << {
        :payer_contact_information => [
          'Payer Name, LLC', 'Address Line 1',
          'City, State 00000', '(555) 555-5555'],
        :payer_federal_id => 'XX-XXXXXXX',
        :recipient_federal_id => 'YY-YYYYYY1',
        :recipient_name => 'Recipient Name',
        :recipient_street_address => 'Street Address Line 1',
        :recipient_city_state_zip => 'City, State 11111',
        :recipient_account_number => 'XXXXX',
        :nonemployee_compensation => '1234.56'
      }

      @form1099.data << {
        :payer_contact_information => [
          'Payer Name, LLC', 'Address Line 1',
          'City, State 00000', '(555) 555-5555'],
        :payer_federal_id => 'XX-XXXXXXX',
        :recipient_federal_id => 'YY-YYYYYY2',
        :recipient_name => 'Recipient Name',
        :recipient_street_address => 'Street Address Line 1',
        :recipient_city_state_zip => 'City, State 11111',
        :recipient_account_number => 'XXXXX',
        :nonemployee_compensation => '999'
      }

      @form1099.data << {
        :payer_contact_information => [
          'Payer Name, LLC', 'Address Line 1',
          'City, State 00000', '(555) 555-5555'],
        :payer_federal_id => 'XX-XXXXXXX',
        :recipient_federal_id => 'YY-YYYYYY3',
        :recipient_name => 'Recipient Name',
        :recipient_street_address => 'Street Address Line 1',
        :recipient_city_state_zip => 'City, State 11111',
        :recipient_account_number => 'XXXXX',
        :nonemployee_compensation => '9875383.39'
      }
    end

    it "should generate PDF with data on the template" do
      pdf = @form1099.to_pdf(:with_template => true)
      write_content_to_file('copyA_with_data_and_template.pdf', pdf)
      assert_data_matches_file_content('copyA_with_data_and_template.pdf', pdf)
    end

    it "should generate PDF with data and no template" do
      pdf = @form1099.to_pdf # default is to not use template
      write_content_to_file('copyA_with_data_and_no_template.pdf', pdf)
      assert_data_matches_file_content('copyA_with_data_and_no_template.pdf', pdf)
    end
  end

end

describe "Form1099" do
  before(:all) do
    @form1099 = IrsForms::Form1099Misc.new(data: [
      {:payer_contact_information => [
        'Payer Name, LLC', 'Address Line 1',
        'City, State 00000', '(555) 555-5555'],
      :payer_federal_id => 'XX-XXXXXXX',
      :recipient_federal_id => 'YY-YYYYYY3',
      :recipient_name => 'Recipient Name',
      :recipient_street_address => 'Street Address Line 1',
      :recipient_city_state_zip => 'City, State 11111',
      :recipient_account_number => 'XXXXX',
      :nonemployee_compensation => '9875383.39'},
      {:payer_contact_information => [
          'Payer Name, LLC', 'Address Line 1',
          'City, State 00000', '(555) 555-5555'],
        :payer_federal_id => 'XX-XXXXXXX',
        :recipient_federal_id => 'YY-YYYYYY2',
        :recipient_name => 'Recipient Name',
        :recipient_street_address => 'Street Address Line 1',
        :recipient_city_state_zip => 'City, State 11111',
        :recipient_account_number => 'XXXXX',
        :nonemployee_compensation => '999'}
    ])
  end
  it "should print correctly for each copy" do
    IrsForms::Form1099Misc::COPIES.each do |copy|
      @form1099.copy = copy
      pdf = @form1099.to_pdf(:with_template => true)
      write_content_to_file("f1099msc#{copy}_data_and_template.pdf", pdf)
      assert_data_matches_file_content("f1099msc#{copy}_data_and_template.pdf", pdf)
    end
  end
end
