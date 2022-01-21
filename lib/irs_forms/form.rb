class IrsForms::Form

  attr_accessor :data, :x_offset, :y_offset

  def initialize(options={})
    self.data = options[:data] || {}
    self.x_offset = options[:x_offset]
    self.y_offset = options[:y_offset]
  end

  def entries_per_page
    2
  end

  def template_filepath(filename)
    dir = File.expand_path(File.dirname(__FILE__) + '/../../templates')
    "#{dir}/#{filename}"
  end

  def to_pdf(options={})
    to_prawn(options).render
  end

  def x_offset
    @x_offset || 0
  end

  def y_offset
    @y_offset || 0
  end

  private

  def pdf_top
    @pdf.bounds.top + y_offset
  end

  def pdf_left
    @pdf.bounds.left + x_offset
  end

  def format_amount(string)
    number = "%#.2f" % string.to_f

    parts = number.to_s.to_str.split('.')
    # Add comma delimeter for every three digits
    # Taken from Rails' ActionView::Helpers::NumberHelper#number_with_delimeter
    parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")

    parts.join('.').html_safe
  end

  def text(string, options={})
    if options[:at]
      @pdf.draw_text string.to_s, options
    else
      @pdf.text string.to_s, options
    end
  end

  def auto_sized_text(text, target_size, max_width)
    size = target_size + 1
    width = max_width + 1
    while width >= 240 && size >= 8
      size -= 1
      width = @pdf.width_of(text, size: size)
    end
    @pdf.text(text, size: size)
  end
end
