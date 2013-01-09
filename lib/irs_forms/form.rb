class IrsForms::Form

  def template_filepath(filename)
    dir = File.expand_path(File.dirname(__FILE__) + '/../../templates')
    "#{dir}/#{filename}"
  end

  def to_pdf(options={})
    to_prawn(options).render
  end

  private

  def format_amount(string)
    number = "%#.2f" % string.to_f

    parts = number.to_s.to_str.split('.')
    # Add comma delimeter for every three digits
    # Taken from Rails' ActionView::Helpers::NumberHelper#number_with_delimeter
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")

    parts.join('.').html_safe
  end

  def render_data_to_prawn(hash, position)
    y_offset = (position == :top ? 0 : 395)
    x_offset = 20

    col2_offset = 122
    col3_offset = 255

    x = @pdf.bounds.left + x_offset
    y = @pdf.bounds.top - y_offset - 10

    # Payer Contact Information
    @pdf.bounding_box([x, y], :width => 240, :height => 90) do
       hash[:payer_contact_information].each do |string|
         @pdf.text string
       end
    end

    y -= 115

    # Payer Federal ID
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       @pdf.text hash[:payer_federal_id]
    end

    # Recipient Federal ID
    @pdf.bounding_box([x + col2_offset, y], :width => 120, :height => 50) do
       @pdf.text hash[:recipient_federal_id]
    end

    y -= 45

    # Recipient Name
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       @pdf.text hash[:recipient_name]
    end

    # Nonemployee compensation
    @pdf.bounding_box([x + col3_offset, y - 10], :width => 120, :height => 50) do
       @pdf.text format_amount(hash[:nonemployee_compensation])
    end

    y -= 40

    # Recipient Address
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       @pdf.text hash[:recipient_street_address]
       @pdf.move_down 15
       @pdf.text hash[:recipient_city_state_zip]
    end

    y -= 60
    # Recipient Account Number
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       @pdf.text hash[:recipient_account_number]
    end

  end

  def check_valid_copy!
    raise "Invalid copy. Must be one of #{COPIES}. You entered #{copy}." unless COPIES.include?(copy)
  end

end
