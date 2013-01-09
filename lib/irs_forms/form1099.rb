# Base class for Form1099s
class IrsForms::Form1099 < IrsForms::Form

  attr_accessor :copy, :data

  COPIES = %W{A B C 1 2}

  def initialize(options={})

    self.copy = options[:copy]
    check_valid_copy! if copy.present?

    self.data = options[:data] || []
  end

  def to_prawn(options={})
    options.reverse_merge!(with_template: false)

    prawn_options = {:bottom_margin => 0.0}
    prawn_options.merge!(:template => template_filepath) if options[:with_template]

    @pdf = Prawn::Document.new(prawn_options)

    data.each_with_index do |hash, index|
      position = calculate_position(index)
      @pdf.start_new_page(prawn_options) if index > 0 and position == :top
      render_data_to_prawn(hash, position)
    end

    @pdf
  end

  private

  def calculate_position(index)
    raise 'Implement #calculate_position'
  end

  def render_data_to_prawn(hash, position)
    raise 'Implement #render_data_to_prawn'
  end

  def check_valid_copy!
    raise "Invalid copy. Must be one of #{COPIES}. You entered #{copy}." unless COPIES.include?(copy)
  end

end
