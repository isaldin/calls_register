module PrintformBuilder

  class Builder

    attr_accessor :entity, :wb, :sheet, :s, :e

    def initialize(wb, sheet, entity, s, e, &block)

      @entity = entity
      @wb = wb
      @sheet = sheet
      @s = s
      @e = e

      self.instance_eval &block
    end

    #you can define own styles in view
    def a10;  PrintformBuilder::Styles.new(sz: 10)  end
    def a9;   PrintformBuilder::Styles.new(sz: 9)   end
    def a8;   PrintformBuilder::Styles.new(sz: 8)   end

    def row(*cells)
      content = []
      styles = []
      types = []

      cells.each do |cell|
        content << cell[:content]
        styles << cell[:styles]
        types << cell[:types]
      end

      @sheet.add_row(content.flatten, style: styles.flatten, types: types.flatten)
    end

    def cell(address, text, style, merge:true, type:nil) # cell(:A_Z, text, style:a8.b ... )
      abc = ('A'..'Z').inject(''){ |res, letter| res += letter }

      content = []
      styles = []
      types = []

      start_range_char, end_range_char = address.to_s.split('_')

      #конвертируем номер столбца из буквенного представления в 'человеческий'
      start_position = start_range_char.split('').reverse.each_with_index.inject(0) { |sum, (letter, index)|
        position_in_abc = abc.index(letter) + 1
        sum += index > 0 ? position_in_abc * 26 : position_in_abc
      }
      end_position = end_range_char.split('').reverse.each_with_index.inject(0) { |sum, (letter, index)|
        position_in_abc = abc.index(letter) + 1
        sum += index > 0 ? position_in_abc * 26 : position_in_abc
      }

      if merge
        row_num = @sheet.rows.size + 1
        @sheet.merge_cells "#{start_range_char}#{row_num}:#{end_range_char}#{row_num}"
      end

      content << text #add text only once
      styles  << (style ? @wb.styles.add_style(style.opts) : nil)
      types   << type

      (end_position - start_position).times{
        content << ''
        styles  << (style ? @wb.styles.add_style(style.opts) : nil)
        types   << type
      }

      { content: content, styles: styles, types: types }
    end

    def empty_row(height)
      @sheet.add_row().height = height
    end

    #write-less mode
    def empty_cells(merge:false)
      [nil, nil, merge:merge]
    end

    def skip(cells) #you can use :A instead of :A_A
      start_position = cells.to_s.split('_')[0]
      end_position = cells.to_s.split('_')[1] || start_position

      cell_address = [start_position, end_position].join('_').to_sym
      cell(cell_address, *empty_cells)
    end

  end

  class Styles
    def initialize(opts)
      @options =
          {
              sz: 10,
              b: false,
              i: false,
              font_name: 'Arial',

              alignment:
                  {
                      wrap_text: true,
                      horizontal: :left,
                      vertical: :bottom
                  },

              border:
                  {
                      style: :thin,
                      :color =>'00',
                      :edges => []
                  }
          }

      @options.merge! opts
    end

    def b
      @options.merge! b: true
      self
    end

    def i
      @options.merge! i: true
      self
    end

    def u
      @options.merge! u: true
      self
    end

    def center
      @options[:alignment].merge! horizontal: :center
      self
    end

    def right
      @options[:alignment].merge! horizontal: :right
      self
    end

    def no_wrap
      @options[:alignment].merge! wrap_text: false
      self
    end

    def middle
      @options[:alignment].merge! vertical: :center
      self
    end

    def top
      @options[:alignment].merge! vertical: :top
      self
    end

    def bottom
      @options[:alignment].merge! vertical: :bottom
      self
    end

    def border(border_opts)
      @options[:border].deep_merge! border_opts
      self
    end

    def bordered
      border :edges => nil
    end

    def thick
      border style: :thick
    end

    def edges(*edges)
      border edges: edges
    end

    def tg(format= '#,##0.00')
      @options.merge! format_code: format
      self
    end

    def _
      border edges: [:bottom]
    end

    def vertical_text
      @options[:alignment].merge! :textRotation => 90
      self
    end

    def size(size)
      @options.merge! sz: size
      self
    end

    def opts
      @options
    end
  end

end