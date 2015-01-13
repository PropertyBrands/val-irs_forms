class IrsForms::Form1099Int < IrsForms::Form1099

  COPIES = %W{A B C}

  def template_filepath
    super("f1099int-copy#{copy}.pdf")
  end

  private

  def calculate_position(index)
    case index%2
    when 0
      :top
    when 1
      :bottom
    end
  end

  def render_data_to_prawn(hash, position)
    y_offset = case position
               when :top
                 10
               when :bottom
                 405
               end
    x_offset = 20

    col2_offset = 122
    col3_offset = 255

    x = pdf_left + x_offset
    y = pdf_top - y_offset - 10

    # Payer Contact Information
    @pdf.bounding_box([x, y], :width => 240, :height => 90) do
       hash[:payer_contact_information].each do |string|
         text string
       end
    end

    # Interest Income
    @pdf.bounding_box([x + col3_offset, y - 30], :width => 120, :height => 50) do
       text format_amount(hash[:interest_income])
    end

    y -= 95

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
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:recipient_name]
    end

    if copy == 'A'
      y -= 25
    else
      y -= 35
    end

    # Recipient Address
    @pdf.bounding_box([x, y], :width => 240, :height => 50) do
       text hash[:recipient_street_address_line_1], size: 10
       text hash.fetch(:recipient_street_address_line_2, " "), size: 10
       @pdf.move_down 15
       text hash[:recipient_city_state_zip]
    end

    y -= 70

    # Recipient Account Number
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:recipient_account_number]
    end
  end
end
