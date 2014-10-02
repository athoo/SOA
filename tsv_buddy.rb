# Module that can be included (mixin) to create and parse TSV data
module TsvBuddy
  # @data should be a data structure that stores information
  #  from TSV or Yaml files. For example, it could be an Array of Hashes.
  attr_accessor :data

  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def take_tsv(tsv)
    @data = arr_to_yaml(tsv)
    # puts @data
  end

  def tsv_parser(tsv)
    sep_line = tsv.split("\n") 	# init var for each of lines seperated by '\n'.
    trans_sep = [] 	# transform each element in sep_line into an array.
    $header_names = []
    sep_line.each { |x| trans_sep.push(x.split("\t")) }
    $header_names = trans_sep[0] # Save the header for later use
    trans_sep.delete_at(0) # better for later use (ex: each..)
    yield trans_sep
  end

  def arr_to_yaml(tsv)
    complete_array = []	 # init var for final array of hashes.
    tsv_parser(tsv) do |trans_sep|
      trans_sep.each do |arr_of_header|
        temp_hash = Hash[$header_names.zip(arr_of_header)]
        # zip header content with names and put into hash
        complete_array << temp_hash
      end
    end
    complete_array  # puts complete_array
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def to_tsv
    stu_info = @data
    # print stu_info
    flag = false
    keyarr = []
    valuearr = []
    wholevalue = []
    stu_info.each do |unique|
      unique.each do |a, b|
        keyarr.push a if flag == false
        valuearr.push b
      end
      wholevalue.push valuearr.join("\t")
      valuearr = []
      flag = true
    end
    wholevalue.unshift(keyarr.join("\t"))
    out = wholevalue.join("\n")
    out << "\n"
  end
end
