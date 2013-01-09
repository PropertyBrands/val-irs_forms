class IrsForms::Form1096 < IrsForms::Form

  attr_accessor :data

  def initialize(options={})
    self.data = options[:data] || {}
  end

  def template_filepath
    super("f1096.pdf")
  end

  def to_prawn(options={})
    options.reverse_merge!(with_template: false)

    prawn_options = {:bottom_margin => 0.0}
    prawn_options.merge!(:template => template_filepath) if options[:with_template]

    @pdf = Prawn::Document.new(prawn_options)
    render_data_to_prawn
    @pdf
  end

  private

  def render_data_to_prawn
    y_offset = 70
    x_offset = 20

    col2_offset = 200
    col3_offset = 355

    x = @pdf.bounds.left + x_offset
    y = @pdf.bounds.top - y_offset - 10

    # Filer Name/Address
    @pdf.bounding_box([x + 20, y], :width => 260, :height => 75) do
       text data[:filer_name].to_s
       @pdf.move_down(20)
       text data[:filer_street_address].to_s
       @pdf.move_down(15)
       text data[:filer_city_state_zip].to_s
    end

    y -= 86

    # Person Contact Information
    @pdf.bounding_box([x, y], :width => 200) do
       text data[:contact_name].to_s
       @pdf.move_down(10)
       text data[:email_address].to_s
    end
    @pdf.bounding_box([x + col2_offset, y], :width => 200) do
       text data[:telephone_number].to_s
       @pdf.move_down(10)
       text data[:fax_number].to_s
    end

    y -= 50

    # EIN
    @pdf.bounding_box([x, y], :width => 200) do
       text data[:employer_identification_number].to_s
    end

    # SSN
    @pdf.bounding_box([x + 100, y], :width => 200) do
       text data[:social_security_number].to_s
    end

    # Total Number of Forms
    @pdf.bounding_box([x + col2_offset, y], :width => 200) do
       text data[:total_number_of_forms].to_s
    end

    # Total Amount Reported
    @pdf.bounding_box([x + col2_offset + 190, y], :width => 200) do
       text format_amount(data[:total_amount_reported]).to_s
    end if data[:total_amount_reported]

    row1 = 475
    row2 = 428
    col3  = 100
    col14 = 515

    check_form_coords = case data[:type_of_form]
                        when '1099int'
                          [col14, row1]
                        when '1099msc'
                          [col3, row2]
                        end
    text "X", at: check_form_coords if check_form_coords
  end

end
