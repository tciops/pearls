#!/usr/bin/perl
use XML::LibXML;
use XML::LibXML::XPathContext;
$|=1;
my $filename = $ARGV[0];
my $dom = XML::LibXML->load_xml(location => $filename);

my $xpc = XML::LibXML::XPathContext->new($dom);
$xpc->registerNs('graphml',  'http://graphml.graphdrawing.org/xmlns');
$xpc->registerNs('y', 'http://www.yworks.com/xml/graphml');



# xmlns="http://graphml.graphdrawing.org/xmlns"
# xmlns:java="http://www.yworks.com/xml/yfiles-common/1.0/java"
# xmlns:sys="http://www.yworks.com/xml/yfiles-common/markup/primitives/2.0"
# xmlns:x="http://www.yworks.com/xml/yfiles-common/markup/2.0"
# xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
# xmlns:y="http://www.yworks.com/xml/graphml"
# xmlns:yed="http://www.yworks.com/xml/yed/3"



# my($match2) = $xpc->findnodes('//y:Resources/y:Resource[@type="java.awt.image.BufferedImage"]');


@nodes = $xpc->findnodes('//graphml:node');
for $res (@nodes)
{
	# print "\n".'XPath: y:ImageNode  Matched: ', $res->nodeName;
	
	# $res->registerNs('graphml',  'http://graphml.graphdrawing.org/xmlns');
	@tooltip = $xpc->findnodes($res->nodePath.'/graphml:data[@key="d4"]',$res);
	
	@res1 = $xpc->findnodes($res->nodePath.'/graphml:data[@key="d7"]/y:SVGNode/y:SVGModel/y:SVGContent',$res);
	
	if ($#res1 >=0)
	{
		# printf "\t>>%s \n", $res1[0]->findvalue( '@refid' ) ;
		$res_id=$res1[0]->findvalue( '@refid' );
		
		
		my @resources = $xpc->findnodes('//y:Resources/y:Resource[@id="'.$res_id.'"]');
		
		# print 'XPath: y:ImageNode  Matched: ', $resources[0]->nodeName;
		
		@nic = split /\n/,$resources[0]->to_literal;
		@title = grep /title/,@nic;
		$title[0] =~s/.*\[(.*)\]\].*/\1/;
		# print $title[0];
		
		$tooltip[0]->removeChildNodes();
		$tooltip[0]->appendText($title[0]);
		
		printf "\nNew tooltip: %s",$tooltip[0]->nodeName;
	}
}


open XML, ">new.xml";
print XML $dom->toString();
close XML;

