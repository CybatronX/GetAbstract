# encoding: UTF-8

require 'rubygems'
require 'mechanize'
require 'Fileutils.rb'
require 'logger'

# require_relative 'config.rb'
###### Inspect the methods/fields in any element #########
def getMethodsInElement(element)
	return element.inspect;
end

def getElementsWithCSSMatch(page, identificationString)
	return page.parser.css(identificationString);
end

def getElementText(element)
	return element.children[0].content;
end

def getElementAttribute(element, attributeName)
	return element[attributeName];
end


def filterElementsByAttribute(elementList, attributeName, attributeValue)
	finalList = Array.new;

	elementList.each do |element|
		att = element.attributes.attributes[attributeName];
		finalList << element if att && att.value = attributeValue;
	end

	return finalList;
end



def downloadFile(url, fileName)
	begin
		$mechanizer.get(url).save_as fileName
	rescue Mechanize::ResponseCodeError
		$logger = $logger.info("File downloaded");
	end
end

def createDirectoryAndDownloadFile(bookName, parentDirectoryName, downloadLink, linkType, linkExtension)
	if(downloadLink != nil)
		directory_name = bookName;
		downloadFile(downloadLink, parentDirectoryName + "\\" + directory_name + "\\" + bookName+ "_" + linkType+"."+ linkExtension);
	end
end




####################### Regular Expressions ######################
	# myMatch = /(.*):(.*)ounces(.*)/.match(shippingWeightText)
	# return myMatch.captures[1].strip;


####################### Loggin in forms ###########################
# def login ()
# 	$logger.info("Log in started");

# 	$mechanizer.get('http://www.vikatan.com/') do |page|
# 		search_result = page.form_with(:name => 'login') do |login|
# 		    login.user_id = 'anandanganesan@yahoo.co.in';
# 		    login.password = 'magicmagic';
#   		end.submit
#   end

#   	$logger.info("Log in completed");
# end


####################### Crawling links ##############################
# def parsePage ()
# 	bookClasses = ["anandha-vikatan", "junior-vikatan", "aval-vikatan", "chutti-vikatan", "sakthi-vikatan", "nanayam-vikatan", "motor-vikatan", "pasumai-vikatan"];		

# 	$logger.info("Parsing main page to get links to books")
# 	$mechanizer.get('http://www.vikatan.com/')  do |page|
# 		bookClasses.each do |currentBookClass|

# 			currentAnchorElement = page.link_with(:class => currentBookClass);

# 			createCurrentBook(currentBookClass, currentAnchorElement.href);
# 		end
# 	end
# end

#####################################################################################################################################################
############### Constants #########################

$mainPage = "https://www.getabstract.com/AbstractList.do?u=microsoft&action=abstractList&pdfTypeId=15000000&sortBy=onlineDate&languageIds=1&sumGroup=1";
$nextButtonSelector = "input[name='next']";
$bookListSelector = "a[itemprop=\'url\']";



def login ()
	$logger.info("Log in started");

	$mechanizer.get('https://www.getabstract.com/en/login') do |page|
		search_result = page.form_with(:name => 'loginForm') do |login|
		    login.username = 'ajayan@microsoft.com';
		    login.password = '5d7n8TKCDnED';
  		end.submit
  end

  	$logger.info("Log in completed");
end

def extractBooks(category, link)
	$mechanizer.get(link)  do |page|
		headingspan		= getElementsWithCSSMatch(page,"span[itemprop = 'name']")[0];
		authorElement 	= getElementsWithCSSMatch(page,"p.author")[0];
		bookName 		= getElementText(headingspan).strip() ;
		author 			= getElementText(authorElement).strip();
	
		if (getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='PDF']").any?)
			pdfLink			= getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='PDF']")[0]["href"] ;
			createDirectoryAndDownloadFile(bookName, category, "https://www.getabstract.com/" + pdfLink, "pdf","pdf");	
		end
		sleep(rand(2));

		if (getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='MOBI']").any?)
		mobiLink 		= getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='MOBI']")[0]["href"];
		createDirectoryAndDownloadFile(bookName, category, "https://www.getabstract.com/" + mobiLink, "mobi","mobi");
		end
		sleep(rand(2));

		if(getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='EPUB']").any?)
		epubLink 		= getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='EPUB']")[0]["href"] 
		createDirectoryAndDownloadFile(bookName, category, "https://www.getabstract.com/" + epubLink, "epub","epub");
		end
		sleep(rand(2));

		if(getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='MOBILE_PDF']").any?)
		mobilePDFLink 	= getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='MOBILE_PDF']")[0]["href"] 
		createDirectoryAndDownloadFile(bookName, category, "https://www.getabstract.com/" + mobilePDFLink, "mobilePdf","pdf");
		end
		sleep(rand(2));

		if(getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='AUDIO']").any?)
		audioLink 		= getElementsWithCSSMatch(page, "#downloadArea a.sendSummaryText[data-download-format='AUDIO']")[0]["href"] 
		createDirectoryAndDownloadFile(bookName, category, "https://www.getabstract.com/" + audioLink, "mp3", "mp3");
		end
		sleep(rand(2));

		open( category+".txt" , 'a') { |f|
		  f.puts bookName +"\t"+  author;
		}
	end

end

# begin

	$logger = Logger.new("logfile.log");
	$loggerevel = Logger::INFO;

	$mechanizer = Mechanize.new { |agent|
	  agent.user_agent_alias = 'Windows Chrome';
	}
	$mechanizer.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	$logger.info("\n\n**********************************************");
	$logger.info("Program Started");

	login();

	################Change this Variable everytime#######################
	category = "Marketing"
	#####################################################################

	bookLinks = ["https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20659",
		"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21767",
		"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=23215",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22814",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22748",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22441",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22184",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22456",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22895",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22668",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21344",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22621",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22132",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22183",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19358",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22755",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22470",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22235",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22287",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22598",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22147",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22028",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20302",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21749",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=22177",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21858",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21993",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21643",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20841",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19805",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21845",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21823",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21859",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17605",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19614",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20210",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20409",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21343",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=9172",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20562",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=21545",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19606",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20490",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20312",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19527",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18929",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20789",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20911",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20922",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16734",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20013",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19319",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18454",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18451",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19296",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19918",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=8592",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19146",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19994",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20308",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19173",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19957",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18271",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18401",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19355",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19106",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18925",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19231",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17782",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18586",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20063",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20310",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18862",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18844",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18448",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19155",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19802",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=20006",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=15771",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18468",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18579",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18776",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=13513",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=19570",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18859",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18809",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18660",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18038",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18367",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18402",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=13015",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18832",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=15566",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18158",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18113",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=13919",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18431",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16810",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18326",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18330",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16625",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16778",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18290",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17291",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17415",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18080",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17481",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18291",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16847",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17242",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17723",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18180",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16831",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17851",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17350",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=18081",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17724",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=13607",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17979",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17042",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=16779",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=15969",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=12774",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17367",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=13653",
"https://www.getabstract.com/ShowAbstract.do?u=microsoft&dataId=17697"];

	totalCount = bookLinks.count;
	bookLinks.each_with_index do |currentLink, index|
		extractBooks(category, currentLink);
		puts "#{index}/#{totalCount} completed";
	end

	extractBooks();

	$logger.info("**********************************************");

# rescue => e
# 	$logger.error(e.message);
# 	$logger.error(e.backtrace);	
# end
