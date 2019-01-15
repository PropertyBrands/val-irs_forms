class IrsForms::Form1099Misc < IrsForms::Form1099

  COPIES = %W{A B C 1 2}

  def template_filepath
    super("f1099msc-copy#{copy}.pdf")
  end

  private

  def calculate_position(index)
    index%2 == 0 ? :top : :bottom
  end

  def copy_offset(copy)
    if copy == "A"
      10
    else
      20
    end
  end

  def render_data_to_prawn(hash, position)
    y_offset = (position == :top ? 10 : 405)
    x_offset = 20

    col2_offset = 122
    col3_offset = 255

    x = pdf_left + x_offset
    y = pdf_top - y_offset - copy_offset(copy)

    # Payer Contact Information
    @pdf.bounding_box([x, y], :width => 240, :height => 90) do
       hash[:payer_contact_information].each do |string|
         text string
       end
    end

    y -= 90

    # Payer Federal ID
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:payer_federal_id]
    end

    # Recipient Federal ID
    @pdf.bounding_box([x + col2_offset, y], :width => 120, :height => 50) do
       text hash[:recipient_federal_id]
    end

    y -= 45

    # Recipient Name
    @pdf.bounding_box([x, y], width: 240, height: 50) do
      auto_sized_text(hash[:recipient_name], 12, 240)
    end

    # Nonemployee compensation
    @pdf.bounding_box([x + col3_offset, y], width: 120, height: 50) do
       text format_amount(hash[:nonemployee_compensation])
    end

    if copy == "A"
      y -= 35
    else
      y -= 31
    end

    # Recipient Address
    @pdf.bounding_box([x, y], :width => 240, :height => 50) do
      font_size = 10
      line2 = hash.fetch(:recipient_street_address_line_2, nil)
      text hash[:recipient_street_address_line_1], size: font_size
      if line2
        text line2, size: font_size
      end
    end

    y -= 37

    @pdf.bounding_box([x, y], width: 240, height: 50) do
      font_size = 10
      text hash[:recipient_city_state_zip], size: font_size
    end

    y -= 40

    # Recipient Account Number
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:recipient_account_number]
    end
  end

  def check_valid_copy!
    raise "Invalid copy. Must be one of #{COPIES}. You entered #{copy}." unless COPIES.include?(copy)
  end
end
