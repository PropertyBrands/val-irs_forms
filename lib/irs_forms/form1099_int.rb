class IrsForms::Form1099Int < IrsForms::Form1099

  COPIES = %W{A B C}

  def template_filepath
    super("f1099int-copy#{copy}.pdf")
  end

  private

  def calculate_position(index)
    case index%3
    when 0
      :top
    when 1
      :middle
    when 2
      :bottom
    end
  end

  def render_data_to_prawn(hash, position)
    y_offset = case position
               when :top
                 0
               when :middle
                 263
               when :bottom
                 528
               end
    x_offset = 20

    col2_offset = 122
    col3_offset = 255

    x = @pdf.bounds.left + x_offset
    y = @pdf.bounds.top - y_offset - 10

    # Payer Contact Information
    @pdf.bounding_box([x, y], :width => 240, :height => 90) do
       hash[:payer_contact_information].each do |string|
         text string
       end
    end

    # Interest Income
    @pdf.bounding_box([x + col3_offset, y - 25], :width => 120, :height => 50) do
       text format_amount(hash[:interest_income])
    end

    y -= 75

    # Payer Federal ID
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:payer_federal_id]
    end

    # Recipient Federal ID
    @pdf.bounding_box([x + col2_offset, y], :width => 120, :height => 50) do
       text hash[:recipient_federal_id]
    end

    y -= 25

    # Recipient Name
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:recipient_name]
    end

    y -= 33

    # Recipient Address
    @pdf.bounding_box([x, y], :width => 240, :height => 50) do
       text hash[:recipient_street_address]
       @pdf.move_down 10
       text hash[:recipient_city_state_zip]
    end

    y -= 50

    # Recipient Account Number
    @pdf.bounding_box([x, y], :width => 120, :height => 50) do
       text hash[:recipient_account_number]
    end

  end
end
