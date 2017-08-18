#!/usr/bin/perl
use strict;
use warnings;
#use integer;
my $version="1b or maybe c";
#convert 1.3.0.png -fill white -opaque black out.png
#convert 1.3.0.png -fill white -fuzz 5% -opaque black out.png
#convert 1.3.0.png -fill yellow4 -fuzz 50% -opaque white out.png
#
#----------------------------------------
#Variables
#----------------------------------------
#dimensions refers to the dimension of a single cell
#The offsets give the location of the cell.
my %Xoffset_hash; my %Yoffset_hash;
my @spreadsheet_array;
my @identify_array; 
my $y=0;
my $which_white=100;
my $column; my $row;

#INSERT_COORDINATES_HERE
$Xoffset_hash{0}=16;$Yoffset_hash{0}=45;
$Xoffset_hash{1}=230;$Yoffset_hash{1}=43;
$Xoffset_hash{2}=447;$Yoffset_hash{2}=43;
$Xoffset_hash{3}=121;$Yoffset_hash{3}=153;
$Xoffset_hash{4}=338;$Yoffset_hash{4}=155;
$Xoffset_hash{5}=558;$Yoffset_hash{5}=157;
$Xoffset_hash{6}=13;$Yoffset_hash{6}=262;
$Xoffset_hash{7}=228;$Yoffset_hash{7}=264;
$Xoffset_hash{8}=449;$Yoffset_hash{8}=267;
$Xoffset_hash{9}=119;$Yoffset_hash{9}=372;
$Xoffset_hash{10}=337;$Yoffset_hash{10}=374;
$Xoffset_hash{11}=558;$Yoffset_hash{11}=377;

$Xoffset_hash{12}=121;$Yoffset_hash{12}=45;
$Xoffset_hash{13}=339;$Yoffset_hash{13}=43;
$Xoffset_hash{14}=558;$Yoffset_hash{14}=44;
$Xoffset_hash{15}=15;$Yoffset_hash{15}=154;
$Xoffset_hash{16}=228;$Yoffset_hash{16}=154;
$Xoffset_hash{17}=448;$Yoffset_hash{17}=157;
$Xoffset_hash{18}=120;$Yoffset_hash{18}=264;
$Xoffset_hash{19}=339;$Yoffset_hash{19}=265;
$Xoffset_hash{20}=559;$Yoffset_hash{20}=267;
$Xoffset_hash{21}=14;$Yoffset_hash{21}=370;
$Xoffset_hash{22}=227;$Yoffset_hash{22}=374;
$Xoffset_hash{23}=449;$Yoffset_hash{23}=378;

#how many cells are in photograph?
my $number_of_cells_per_image=24;
#dimensions of each cell
my $dimensions="68x71";

#To what degree should we brighten the final image?
my $brightness_up=350;
#The first cell is cell zero, the next one is cell one. 
#$cell_number is the current cell that we are working with.
my $cell_number;
#Do you want debugging reports turned on? If this is a mystery to you then you don't want it on.
my $DEBUG=0;
my $x;

my $input_image1; my $input_image2; my $output_image;
my $cell_name;
my $formatted_number;

#Load the Dec to Hex conversion hash

my %dec_to_hex_hash= (
"000000"   =>	"0",
"010101"   =>	"1",
"020202"   =>	"2",
"030303"   =>	"3",
"040404"   =>	"4",
"050505"   =>	"5",
"060606"   =>	"6",
"070707"   =>	"7",
"080808"   =>	"8",
"090909"   =>	"9",
"0A0A0A"   =>	"10",
"0B0B0B"   =>	"11",
"0C0C0C"   =>	"12",
"0D0D0D"   =>	"13",
"0E0E0E"   =>	"14",
"0F0F0F"   =>	"15",
"101010"   =>	"16",
"111111"   =>	"17",
"121212"   =>	"18",
"131313"   =>	"19",
"141414"   =>	"20",
"151515"   =>	"21",
"161616"   =>	"22",
"171717"   =>	"23",
"181818"   =>	"24",
"191919"   =>	"25",
"1A1A1A"   =>	"26",
"1B1B1B"   =>	"27",
"1C1C1C"   =>	"28",
"1D1D1D"   =>	"29",
"1E1E1E"   =>	"30",
"1F1F1F"   =>	"31",
"202020"   =>	"32",
"212121"   =>	"33",
"222222"   =>	"34",
"232323"   =>	"35",
"242424"   =>	"36",
"252525"   =>	"37",
"262626"   =>	"38",
"272727"   =>	"39",
"282828"   =>	"40",
"292929"   =>	"41",
"2A2A2A"   =>	"42",
"2B2B2B"   =>	"43",
"2C2C2C"   =>	"44",
"2D2D2D"   =>	"45",
"2E2E2E"   =>	"46",
"2F2F2F"   =>	"47",
"303030"   =>	"48",
"313131"   =>	"49",
"323232"   =>	"50",
"333333"   =>	"51",
"343434"   =>	"52",
"353535"   =>	"53",
"363636"   =>	"54",
"373737"   =>	"55",
"383838"   =>	"56",
"393939"   =>	"57",
"3A3A3A"   =>	"58",
"3B3B3B"   =>	"59",
"3C3C3C"   =>	"60",
"3D3D3D"   =>	"61",
"3E3E3E"   =>	"62",
"3F3F3F"   =>	"63",
"404040"   =>	"64",
"414141"   =>	"65",
"424242"   =>	"66",
"434343"   =>	"67",
"444444"   =>	"68",
"454545"   =>	"69",
"464646"   =>	"70",
"474747"   =>	"71",
"484848"   =>	"72",
"494949"   =>	"73",
"4A4A4A"   =>	"74",
"4B4B4B"   =>	"75",
"4C4C4C"   =>	"76",
"4D4D4D"   =>	"77",
"4E4E4E"   =>	"78",
"4F4F4F"   =>	"79",
"505050"   =>	"80",
"515151"   =>	"81",
"525252"   =>	"82",
"535353"   =>	"83",
"545454"   =>	"84",
"555555"   =>	"85",
"565656"   =>	"86",
"575757"   =>	"87",
"585858"   =>	"88",
"595959"   =>	"89",
"5A5A5A"   =>	"90",
"5B5B5B"   =>	"91",
"5C5C5C"   =>	"92",
"5D5D5D"   =>	"93",
"5E5E5E"   =>	"94",
"5F5F5F"   =>	"95",
"606060"   =>	"96",
"616161"   =>	"97",
"626262"   =>	"98",
"636363"   =>	"99",
"646464"	=>	"100",
"656565"	=>	"101",
"666666"	=>	"102",
"676767"	=>	"103",
"686868"	=>	"104",
"696969"	=>	"105",
"6A6A6A"	=>	"106",
"6B6B6B"	=>	"107",
"6C6C6C"	=>	"108",
"6D6D6D"	=>	"109",
"6E6E6E"	=>	"110",
"6F6F6F"	=>	"111",
"707070"	=>	"112",
"717171"	=>	"113",
"727272"	=>	"114",
"737373"	=>	"115",
"747474"	=>	"116",
"757575"	=>	"117",
"767676"	=>	"118",
"777777"	=>	"119",
"787878"	=>	"120",
"797979"	=>	"121",
"7A7A7A"	=>	"122",
"7B7B7B"	=>	"123",
"7C7C7C"	=>	"124",
"7D7D7D"	=>	"125",
"7E7E7E"	=>	"126",
"7F7F7F"	=>	"127",
"808080"	=>	"128",
"818181"	=>	"129",
"828282"	=>	"130",
"838383"	=>	"131",
"848484"	=>	"132",
"858585"	=>	"133",
"868686"	=>	"134",
"878787"	=>	"135",
"888888"	=>	"136",
"898989"	=>	"137",
"8A8A8A"	=>	"138",
"8B8B8B"	=>	"139",
"8C8C8C"	=>	"140",
"8D8D8D"	=>	"141",
"8E8E8E"	=>	"142",
"8F8F8F"	=>	"143",
"909090"	=>	"144",
"919191"	=>	"145",
"929292"	=>	"146",
"939393"	=>	"147",
"949494"	=>	"148",
"959595"	=>	"149",
"969696"	=>	"150",
"979797"	=>	"151",
"989898"	=>	"152",
"999999"	=>	"153",
"9A9A9A"	=>	"154",
"9B9B9B"	=>	"155",
"9C9C9C"	=>	"156",
"9D9D9D"	=>	"157",
"9E9E9E"	=>	"158",
"9F9F9F"	=>	"159",
"A0A0A0"	=>	"160",
"A1A1A1"	=>	"161",
"A2A2A2"	=>	"162",
"A3A3A3"	=>	"163",
"A4A4A4"	=>	"164",
"A5A5A5"	=>	"165",
"A6A6A6"	=>	"166",
"A7A7A7"	=>	"167",
"A8A8A8"	=>	"168",
"A9A9A9"	=>	"169",
"AAAAAA"	=>	"170",
"ABABAB"	=>	"171",
"ACACAC"	=>	"172",
"ADADAD"	=>	"173",
"AEAEAE"	=>	"174",
"AFAFAF"	=>	"175",
"B0B0B0"	=>	"176",
"B1B1B1"	=>	"177",
"B2B2B2"	=>	"178",
"B3B3B3"	=>	"179",
"B4B4B4"	=>	"180",
"B5B5B5"	=>	"181",
"B6B6B6"	=>	"182",
"B7B7B7"	=>	"183",
"B8B8B8"	=>	"184",
"B9B9B9"	=>	"185",
"BABABA"	=>	"186",
"BBBBBB"	=>	"187",
"BCBCBC"	=>	"188",
"BDBDBD"	=>	"189",
"BEBEBE"	=>	"190",
"BFBFBF"	=>	"191",
"C0C0C0"	=>	"192",
"C1C1C1"	=>	"193",
"C2C2C2"	=>	"194",
"C3C3C3"	=>	"195",
"C4C4C4"	=>	"196",
"C5C5C5"	=>	"197",
"C6C6C6"	=>	"198",
"C7C7C7"	=>	"199",
"C8C8C8"	=>	"200",
"C9C9C9"	=>	"201",
"CACACA"	=>	"202",
"CBCBCB"	=>	"203",
"CCCCCC"	=>	"204",
"CDCDCD"	=>	"205",
"CECECE"	=>	"206",
"CFCFCF"	=>	"207",
"D0D0D0"	=>	"208",
"D1D1D1"	=>	"209",
"D2D2D2"	=>	"210",
"D3D3D3"	=>	"211",
"D4D4D4"	=>	"212",
"D5D5D5"	=>	"213",
"D6D6D6"	=>	"214",
"D7D7D7"	=>	"215",
"D8D8D8"	=>	"216",
"D9D9D9"	=>	"217",
"DADADA"	=>	"218",
"DBDBDB"	=>	"219",
"DCDCDC"	=>	"220",
"DDDDDD"	=>	"221",
"DEDEDE"	=>	"222",
"DFDFDF"	=>	"223",
"E0E0E0"	=>	"224",
"E1E1E1"	=>	"225",
"E2E2E2"	=>	"226",
"E3E3E3"	=>	"227",
"E4E4E4"	=>	"228",
"E5E5E5"	=>	"229",
"E6E6E6"	=>	"230",
"E7E7E7"	=>	"231",
"E8E8E8"	=>	"232",
"E9E9E9"	=>	"233",
"EAEAEA"	=>	"234",
"EBEBEB"	=>	"235",
"ECECEC"	=>	"236",
"EDEDED"	=>	"237",
"EEEEEE"	=>	"238",
"EFEFEF"	=>	"239",
"F0F0F0"	=>	"240",
"F1F1F1"	=>	"241",
"F2F2F2"	=>	"242",
"F3F3F3"	=>	"243",
"F4F4F4"	=>	"244",
"F5F5F5"	=>	"245",
"F6F6F6"	=>	"246",
"F7F7F7"	=>	"247",
"F8F8F8"	=>	"248",
"F9F9F9"	=>	"249",
"FAFAFA"	=>	"250",
"FBFBFB"	=>	"251",
"FCFCFC"	=>	"252",
"FDFDFD"	=>	"253",
"FEFEFE"	=>	"254",
"FFFFFF"	=>	"255");


#@ARGV is an array that contains all of the command-line arguments.
#If it is empty, the test will fail, a suggestion will print and the program will exit.
#Use !=0 if you want just one argument. Use <1 is you want no fewer than 2 arguments.
#Use < 0 if you want 1 or more arguments.  Zero arguments gives a $#ARGV = -1.
# <3 means at least 4 arguments.
#This is how we handle wildcards. We let Bash handle the expansion of filenames.
#We just read them from $ARGV[];
if($#ARGV < 0)
{
	print "\n\n\n\n";
	print "|--------------------------------------June 8, 2009---------------------------------------|\n";
	print " Program name: $0 *.jpg\n";
	print " version #$version\n";
	print " *.jpg are your data files. They must all be in the same directory as $0.\n";
	print " I use a moving window in which consecutive files are compared and the window\n";
	print " moves in increments of 1.\n";
	print " That is; the comparisons will be file2-file1, file3-file2, file4-file3, etc.\n";
	print " In this program the manner in which the window moves is not adjustable.\n";
	print "\n";
	print " My advice to you is that you should not keep anything else in this directory.\n";
	print " I will overwrite files if they get in my way!\n";
	print " I will output the white values in results.txt\n";
	print " I acccept wild cards, but not Visa or Mastercard.\n\n";
	print "|-----------------------------------by Nigel Atkinson-------------------------------------|\n";
	exit; 
}
else
{
	print "version #$version\n";
}



#----------------------------------------------------
#open the outputfile which will store the spreadsheet
#This will be a tab delimited text file.
my $output_file;
$output_file="results.txt";
unless(open(OUTPUTFILE,">$output_file"))
{
	print("\ncannot open $output_file\n");
	exit;
}
#----------------------------------------------------

my $number_of_timepoints = @ARGV;
my @Files_to_process;

print "number_of_cells_per_image=$number_of_cells_per_image\n";
print "number_of_timepoints = $number_of_timepoints\n";

for($x=0;$x<$number_of_timepoints;$x++)
{
	$Files_to_process[$x]=$ARGV[$x];
	print "$Files_to_process[$x]\n";
	
	#convert to 256 colors
	print `convert $Files_to_process[$x] -depth 8 $Files_to_process[$x]`;
}

#Process one cell at a time
for($cell_number=0; $cell_number<$number_of_cells_per_image; $cell_number++)
{
	print "cell$cell_number, number_of_cells_per_image=$number_of_cells_per_image, (Xoffset,Yoffset)=($Xoffset_hash{$cell_number},$Yoffset_hash{$cell_number}) number_of_timepoints=$number_of_timepoints\n";
	
	#Insert the column names into the spreadsheet array
	$spreadsheet_array[$cell_number][0]= "cell$cell_number";

	#cell_number is the current cell that we are working on.
	#we start at cell 1 so that $Files_to_process[$x-1] can begin with cell 0.
	for($x=0; $x<($number_of_timepoints); $x++)
	{
		#This loop crops and simultaneously converts to jpg.
		$input_image1=$Files_to_process[($x)];
		
		$output_image="crop$cell_number.$x.jpg";
		#print "convert -crop $dimensions+$Xoffset_hash{$cell_number}+$Yoffset_hash{$cell_number} $input_image1 $output_image\n";
		print `convert -crop $dimensions+$Xoffset_hash{$cell_number}+$Yoffset_hash{$cell_number} $input_image1 $output_image`;
	}#end of cropping loop
	
	#The next loop begins with 1 because 0 contains the first image which is too be subtracted from each and every
	#image in the series.
	for($x=1; $x<($number_of_timepoints); $x++)
	{
		
		$input_image1="crop$cell_number.0.jpg";
		$input_image2="crop$cell_number.$x.jpg";
		#$output_image="diff$cell_number.$x.jpg";

		#output_image has been replaced with cell name.
		# Format batch number with 3 digits
		$formatted_number = sprintf("%05d", $x);
		$cell_name="cell_$cell_number.$formatted_number.jpg";
		
		#This is the subtraction.
		#print "composite -compose difference $input_image1 $input_image2 $cell_name\n";
		print `composite -compose difference $input_image1 $input_image2 $cell_name`;

		#grayscale
		#print "convert $cell_name -colorspace gray $cell_name\n";
		print `convert $cell_name -colorspace gray $cell_name`;
		
		#turn up brightness/contrast
		#print "mogrify -modulate $brightness_up $cell_name\n";
		print `mogrify -modulate $brightness_up $cell_name`;

		#Harvest the information from the file. This contains the white values.
		@identify_array= `identify -verbose $cell_name`; 
		
		print "$cell_name image manipulated\n";
		
		my $white=0;
		for($y=0; $y<@identify_array; $y++)
		{
			# Histogram:
			#         17: black                                         #000000
			#          5: rgb(1,1,1)                                    #010101
			#          9: rgb(2,2,2)                                    #020202
			#         13: grey1                                         #030303
			#         17: rgb(4,4,4)                                    #040404
			#         14: grey2                                         #050505
			#                          
			# Colormap: 256 <------- Make it end when it hits this
			#                                                    
			if($identify_array[$y]=~/\s*(\d+): \S*\s*#(\S*)/)
			{ 
				#Now collect all of the greys that we want to call white.
				#First guess was 72
				if($dec_to_hex_hash{$2}>=$which_white)
				{
					$white=$white+$1;
				}
				#print "$identify_array[$y]\n$1-----$2\nwhite=$white";
			}
			if($identify_array[$y+1]=~/\s*Colormap/)
			{
				#last;
				$y=@identify_array;
			}

		}
		#$cell_number is how we want each column in the spreadsheet to begin.
		#It would be nice to store this in an 2 dim array.
		#spreadsheet_array[column][row] where the columns are different cells and the row are differnt times.
		$spreadsheet_array[$cell_number][$x]= "$white";
	}#end of batch loop

#remove old files
print `rm crop*`;

}#end of cell for loop

#for($row=0; $row<$number_of_timepoints; $row++)
for $row(0 .. ($number_of_timepoints-1))
{
	for $column(0 .. $#spreadsheet_array)
	{
		#for $row(1 .. $#{$spreadsheet_array[$column]})
		print OUTPUTFILE $spreadsheet_array[$column][$row]."\t";
	}
	print OUTPUTFILE "\n";
}

print "Termino\n";
exit;
#Notes
#The command for changing 16-bit (65536 colors) to 8-bit (256 colors) is:
#mogrify -depth 8 *.png
#	or 
#convert input_file.png -depth 8 output_file.png 
#The "-depth" command can have one of two arguments, 8 or 16.  8 bit 
#corresponds to 2^8 colors, and 16 is 2^16 colors. 

#convert everyone to 256 colors
#print "mogrify -depth 8 *.jpg\n";
#print `mogrify -depth 8 *.jpg`;

#Crop all files
