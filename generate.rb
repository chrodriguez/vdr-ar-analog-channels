require 'getoptlong'
require 'csv'

opts = GetoptLong.new(
    [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
    [ '--definitions', '-d', GetoptLong::REQUIRED_ARGUMENT ],
    [ '--add-xmltv2vdr-column', '-a', GetoptLong::NO_ARGUMENT],
    [ '--channels','-c', GetoptLong::REQUIRED_ARGUMENT ]
)

freq = {
  2 =>55.25,
  3 =>61.25,
  4 =>67.25,
  5 =>77.25,
  6 =>83.25,
  7 =>175.25,
  8 =>181.25,
  9 =>187.25,
  10 =>193.25,
  11 =>199.25,
  12 =>205.25,
  13 =>211.25,
  14 =>121.25,
  15 =>127.25,
  16 =>133.25,
  17 =>139.25,
  18 =>145.25,
  19 =>151.25,
  20 =>157.25,
  21 =>163.25,
  22 =>169.25,
  23 =>217.25,
  24 =>223.25,
  25 =>229.25,
  26 =>235.25,
  27 =>241.25,
  28 =>247.25,
  29 =>253.25,
  30 =>259.25,
  31 =>265.25,
  32 =>271.25,
  33 =>277.25,
  34 =>283.25,
  35 =>289.25,
  36 =>295.25,
  37 =>301.25,
  38 =>307.25,
  39 =>313.25,
  40 =>319.25,
  41 =>325.25,
  42 =>331.25,
  43 =>337.25,
  44 =>343.25,
  45 =>349.25,
  46 =>355.25,
  47 =>361.25,
  48 =>367.25,
  49 =>373.25,
  50 =>379.25,
  51 =>385.25,
  52 =>391.25,
  53 =>397.25,
  54 =>403.25,
  55 =>409.25,
  56 =>415.25,
  57 =>421.25,
  58 =>427.25,
  59 =>433.25,
  60 =>439.25,
  61 =>445.25,
  62 =>451.25,
  63 =>457.25,
  64 =>463.25,
  65 =>469.25,
  66 =>475.25,
  67 =>481.25,
  68 =>487.25,
  69 =>493.25,
  70 =>499.25,
  71 =>505.25,
  72 =>511.25,
  73 =>517.25,
  74 =>523.25,
  75 =>529.25,
  76 =>535.25,
  77 =>541.25,
  78 =>547.25,
  79 =>553.25,
  80 =>559.25,
  81 =>565.25,
  82 =>571.25,
  83 =>577.25,
  84 =>583.25,
  85 =>589.25,
  86 =>595.25,
  87 =>601.25,
  88 =>607.25,
  89 =>613.25,
  90 =>619.25,
  91 =>625.25,
  92 =>631.25,
  93 =>637.25,
  94 =>643.25 }


def help
    puts <<-EOF

Usage:

      #{$PROGRAM_NAME} -d <defnition-file>

          -h, --help:
            This help
          -d, --defnitions <definitions-file>
            File with channel number, channel name (Can be created from xmltv config file)
          -a, --add-xmltv2vdr-column
            Add last column required for xmltv2vdr.pl script

    EOF
end

definitions, add_column = nil, false

opts.each do |opt, arg|
  case opt
  when '--help'
    help
    exit
  when '--add-xmltv2vdr-column'
    add_column = true
  when '--definitions'
    definitions = CSV.open(arg,'r').inject(Hash.new) do |all,row|
      all.tap {|hash| hash[row[0]] = row[1] }
    end
  end
end

if definitions.nil?
  help
  fail "You must specify definitions and channels.conf files. Please see --help" 
end

definitions.each do |number, name|
  chan_name = "#{name},#{number}"
  puts "#{chan_name}:#{Integer(freq[number.to_i]*1000)}:TV:V:0:301+101=2:300=@4:305:0:1:0:#{Integer(freq[number.to_i]*16)}:0#{add_column ? ":#{number}.cablevision":""}"
end

