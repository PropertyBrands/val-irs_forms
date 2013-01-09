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

  def text(string, options={})
    if options[:at]
      @pdf.draw_text string.to_s, options
    else
      @pdf.text string.to_s, options
    end
  end

end
