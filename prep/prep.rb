`rm -rf ./tmp && mkdir -p ./tmp`
`rm -rf ./outputs && mkdir -p ./outputs`
pages_to_halve = []

def form_url(type, year)
  "www.irs.gov/pub/irs-prior/f#{type}--#{year}.pdf"
end

def halve(filename)
  orig_width, orig_height = dimensions(filename)
  cropped_filename = filename.sub('orig', 'crop')
  `pdfcrop #{filename} #{cropped_filename}`
  crop_width, crop_height = dimensions(cropped_filename)

  expected_width = orig_width
  expected_height = orig_height / 2
  side_margin = (expected_width - crop_width) / 2
  top_margin = (expected_height - crop_height) / 2

  `rm #{cropped_filename}`
  command =  "pdfcrop --margins '#{side_margin} #{top_margin} #{side_margin} #{top_margin}' #{filename} #{cropped_filename}"
  puts command
  `#{command}`
  cropped_filename
end

def dimensions(filename)
  size_line =
    `pdfinfo #{filename}`.split("\n").detect { |line| line =~ /Page size/ }
  size_line =~ /(\d+) x (\d+)/
  [$1.to_i, $2.to_i]
end

def duplicate_top_half_to_bottom(filename)
  final_filename = filename.sub('-crop', '').sub('tmp/', '')
  tex_filename = "#{final_filename.sub('.pdf', '')}.tex"
  `cp file.tex.template tmp/#{tex_filename}`
  `perl -pi -e 's/FILENAME/#{filename.sub('/', '\/')}/' tmp/#{final_filename.sub('.pdf', '')}.tex`
  `pdflatex tmp/#{tex_filename}`
  `rm #{tex_filename.sub('.tex', '.aux')} #{tex_filename.sub('.tex', '.log')}`
  `mv #{final_filename} ./outputs/#{final_filename.sub('--', '-')}`
end

## PROGAM EXECUTION STARTS HERE ##

puts "This program will fetch and prepare f1099s"
puts "What year? (format: YYYY)"

# year = 2014
year = gets.chomp

url = form_url("1096", year)
puts "Fetching f1096 for #{year} from: #{url}"
`wget #{url} -O tmp/f1096.pdf`
puts "\tExtracting page 2 from f1096"
`pdftk tmp/f1096.pdf cat 2 output outputs/f1096.pdf`

type = "1099int"
url = form_url(type, year)
puts "Fetching #{type} for #{year} from: #{url}"
`wget #{url} -O tmp/f#{type}.pdf`
puts "\tExtracting various pages from f#{type}"
forms = {
  'copyA' => 1,
  'copy1' => 2,
  'copyB' => 3,
  'copy2' => 5,
  'copyC' => 7,
}
forms.each_pair do |form_name, page|
  puts "\tExtracting #{form_name} (page #{page})"
  filename = "tmp/f#{type}--#{form_name}-orig.pdf"
  pages_to_halve << filename
  `pdftk tmp/f#{type}.pdf cat #{page} output #{filename}`
end

type = "1099msc"
url = form_url(type, year)
puts "Fetching #{type} for #{year} from: #{url}"
`wget #{url} -O tmp/f#{type}.pdf`
puts "\tExtracting various pages from f#{type}"
forms = {
  'copyA' => 2,
  'copy1' => 3,
  'copyB' => 4,
  'copy2' => 6,
  'copyC' => 7,
}
forms.each_pair do |form_name, page|
  puts "\tExtracting #{form_name} (page #{page})"
  filename = "tmp/f#{type}--#{form_name}-orig.pdf"
  pages_to_halve << filename
  `pdftk tmp/f#{type}.pdf cat #{page} output #{filename}`
end

halved_pages = pages_to_halve.map do |page_to_halve|
  halve(page_to_halve)
end

halved_pages.each do |halved_page|
  duplicate_top_half_to_bottom(halved_page)
end

puts "Final copies location in ./outputs"
puts "Move to ../templates: mv ./outputs/* ../templates"
