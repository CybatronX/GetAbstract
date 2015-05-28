# encoding: UTF-8

require 'rubygems'
require 'mechanize'
require 'Fileutils.rb'
require 'logger'

require_relative 'config.rb'

def parseCustomerRating(productRatingElement)
	productRating = 0;

	if( !(/a-star-4-5/ !~ productRatingElement))
		productRating = 4.5;
	elseif ( !(/a-star-4/ !~ productRatingElement))
		productRating = 4;
	elseif ( !(/a-star-3-5/ !~ productRatingElement))
		productRating = 3.5;
	elseif ( !(/a-star-3/ !~ productRatingElement))
		productRating = 3;
	elseif ( !(/a-star-2-5/ !~ productRatingElement))
		productRating = 2.5;
	elseif ( !(/a-star-2/ !~ productRatingElement))
		productRating = 2;
	elseif ( !(/a-star-1-5/ !~ productRatingElement))
		productRating = 1.5;
	elseif ( !(/a-star-1/ !~ productRatingElement))
		productRating = 1;
	end

	return productRating;
end

def getShippingWeight(page)

	productDetails = page.parser.css("#prodDetails");
	
	if(productDetails.empty?)
		shippingWeightElements =page.parser.css("#detail-bullets .content li")

		shippingWeightElements.each do |currentDetailClass|
			if( !(/Shipping Weight/ !~ currentDetailClass))
				shippingWeightText = currentDetailClass.text
				myMatch = /(.*):(.*)ounces(.*)/.match(shippingWeightText)
				return myMatch.captures[1].strip;
			end
		end
	else
		shippingWeightText = page.parser.css("#prodDetails .shipping-weight td.value").text;
		if(shippingWeightText != "")
			myMatch = /(.*)ounces(.*)/.match(shippingWeightText.to_s)
			return myMatch.captures[0].strip;
		end

		return 8888;
	end



	return 9999;
	
end

def parseImageURL(productPictureImgText)
	testMatch = /.*data-a-dynamic-image='{"([^"]*)".*>/.match(productPictureImgText);
	return testMatch.captures[0];
end

# Scrape the Product Page
def scrapeProductPage (pageURL)
	$logger.info("Parsing product Page");
	puts("hahaha");
	$mechanizer.get(pageURL)  do |page|


			productTitle 			= page.parser.css('#title span');
			# productRating  			= parseCustomerRating(page.parser.css("#averageCustomerReviews_feature_div .a-icon-star").to_s);
			shippingWeight	 		= getShippingWeight(page);
			productURL				= pageURL;
			productPictureImgURL	= parseImageURL(page.parser.css("img#landingImage").to_s);

			puts   "<tr><td>#{productTitle}</td> <td>#{shippingWeight}</td> <td>#{productURL}</td> <td>#{productPictureImgURL}</td></tr>;"
			
			# puts shippingWeight;
			
	end
end

def test()
	# scrapeProductPage('http://www.amazon.com/Norpro-3-Piece-Stainless-Steel-Funnel/dp/B000FKERMW/ref=lp_13840241_1_3?s=kitchen&ie=UTF8&qid=1423900392&sr=1-3');
	scrapeProductPage('http://www.amazon.com/Isabella-Valance-Sweet-Jojo-Designs/dp/B005F43HV0/ref=sr_1_6?s=baby-products&ie=UTF8&qid=1423904493&sr=1-6');

end

begin

	$logger = Logger.new("logfile.log");
	$logger.level = Logger::INFO;

	$mechanizer = Mechanize.new { |agent|
	  agent.user_agent_alias = 'Windows Chrome';
	}

	$logger.info("\n\n**********************************************");
	$logger.info("Program Started");

	test();

	$logger.info("**********************************************");

# rescue => e
# 	$logger.error(e.message);
# 	$logger.error(e.backtrace);	
end
