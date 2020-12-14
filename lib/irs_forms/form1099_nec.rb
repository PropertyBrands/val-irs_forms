module IrsForms
  class Form1099Nec < IrsForms::Form1099
    COPIES = %W{A B C 1 2}

    attr_accessor :current_hash, :page_y_offset

    def copy_offset
      case copy
      when "A"
        5
      else
        0
      end
    end

    def template_filepath
      super("f1099nec-copy#{copy}.pdf")
    end

    private

    def calculate_position(index)
      index%2 == 0 ? :top : :bottom
    end

    def render_data_to_prawn(hash, position)
      self.page_y_offset = (position == :top ? -15 : -410)
      self.current_hash = hash

      render_payer_contact_information
      render_payer_federal_id
      render_recipient_federal_id
      render_recipient_name
      render_nonemployee_compensation
      render_recipient_address
      render_recipient_account_number
    end

    def check_valid_copy!
      raise "Invalid copy. Must be one of #{COPIES}. You entered #{copy}." unless COPIES.include?(copy)
    end

    private

    def original_left
      pdf_left + 20
    end

    def original_top
      pdf_top + copy_offset
    end

    def pdf_top
      super + page_y_offset
    end

    def render_nonemployee_compensation
      x = original_left + 255
      y = original_top - 70

      @pdf.bounding_box([x, y], width: 120, height: 50) do
        text format_amount(current_hash[:nonemployee_compensation])
      end
    end

    def render_payer_contact_information
      x = original_left
      y = original_top - 10

      @pdf.bounding_box([x, y], :width => 240, :height => 90) do
        current_hash.fetch(:payer_contact_information, []).each do |string|
          text string
        end
      end
    end

    def render_payer_federal_id
      x = original_left
      y = original_top - 100

      @pdf.bounding_box([x, y], :width => 120, :height => 50) do
        text current_hash[:payer_federal_id]
      end
    end

    def render_recipient_account_number
      x = original_left
      y = original_top - 290

      @pdf.bounding_box([x, y], :width => 120, :height => 50) do
        text current_hash[:recipient_account_number]
      end
    end

    def render_recipient_address
      x = original_left
      y = original_top - 182

      @pdf.bounding_box([x, y], :width => 240, :height => 50) do
        line1 = current_hash.fetch(:recipient_street_address_line_1)
        line2 = current_hash.fetch(:recipient_street_address_line_2, nil)

        text [line1, line2].reject(&:blank?).join(" ")
      end

      y -= 38

      @pdf.bounding_box([x, y], width: 240, height: 50) do
        text  current_hash[:recipient_city_state_zip]
      end
    end

    def render_recipient_federal_id
      x = original_left + 122
      y = original_top - 100

      @pdf.bounding_box([x, y], :width => 120, :height => 50) do
        text current_hash[:recipient_federal_id]
      end
    end

    def render_recipient_name
      x = original_left
      y = original_top - 146

      @pdf.bounding_box([x, y], width: 240, height: 50) do
        auto_sized_text(current_hash[:recipient_name], 12, 240)
      end
    end
  end
end
