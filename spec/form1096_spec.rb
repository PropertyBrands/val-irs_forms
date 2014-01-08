require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Form1096" do
  before(:each) do
    @form1096 = IrsForms::Form1096.new
  end

  it "should generate the template_filepath" do
    dir = File.expand_path(File.dirname(__FILE__) + '/../templates')
    @form1096.template_filepath.should == "#{dir}/f1096.pdf"
  end

  it "should generate PDF on the template" do
    pdf = @form1096.to_pdf(:with_template => true)
    write_content_to_file('f1096_with_template.pdf', pdf)
    assert_data_matches_file_content('f1096_with_template.pdf', pdf)
  end

  describe "with a three forms of data" do
    before(:each) do
      @form1096.data = {
        :filer_name => 'Filer Name',
        :filer_street_address => 'Street Address Line 1',
        :filer_city_state_zip => 'City, State 11111',
        :contact_name => 'John Smith',
        :telephone_number => '(555) 555-5555',
        :email_address => 'john.smith@example.com',
        :fax_number => '(555) 555-5556',
        :employer_identification_number => '111-111111',
        :social_security_number => '111-11-1111',
        :total_number_of_forms => '123',
        :total_amount_reported => '123456.78',
        :type_of_form => '1099msc'
      }
    end

    it "should generate PDF with data on the template" do
      pdf = @form1096.to_pdf(:with_template => true)
      write_content_to_file('f1096_with_data_and_template.pdf', pdf)
      assert_data_matches_file_content('f1096_with_data_and_template.pdf', pdf)
    end

    it "check mark for 1099int in correct location" do
      @form1096.data[:type_of_form] = '1099int'
      pdf = @form1096.to_pdf(:with_template => true)
      write_content_to_file('f1096_for_1099int.pdf', pdf)
      assert_data_matches_file_content('f1096_for_1099int.pdf', pdf)
    end

    it "check mark for 1099msc in correct location" do
      @form1096.data[:type_of_form] = '1099msc'
      pdf = @form1096.to_pdf(:with_template => true)
      write_content_to_file('f1096_for_1099msc.pdf', pdf)
      assert_data_matches_file_content('f1096_for_1099msc.pdf', pdf)
    end

    it "should generate PDF with data and no template" do
      pdf = @form1096.to_pdf # default is to not use template
      write_content_to_file('f1096_with_data_and_no_template.pdf', pdf)
      assert_data_matches_file_content('f1096_with_data_and_no_template.pdf', pdf)
    end

    it "should generate PDF with data on the template with test offset" do
      @form1096.x_offset = 20 # right 20px
      @form1096.y_offset = -20 # down 20px
      pdf = @form1096.to_pdf(:with_template => true)
      write_content_to_file('f1096_with_data_and_template_offset.pdf', pdf, true)
      assert_data_matches_file_content('f1096_with_data_and_template_offset.pdf', pdf)
    end
  end

end
