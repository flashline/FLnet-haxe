/**
 * Copyright (c) jm Delettre.
 * 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
/**
* xml package
*/ 
package net.flash_line.util.xml;
import haxe.Http;
import net.flash_line.util.ApiCommon;
import net.flash_line.util.Object;
/**
 * Read xml file into a tree structure : {}of[]or{}of [...etc] of properties. -similar to json.
 * <br/>data access :
 * <br/>ex: trace(myRootVar.myElem.myContainer.myArray[n].myAttrib ; 		// an attribute value, in xmlfile.
 * <br/>ex: trace(myRootVar.myElem.myContainer.myArray[n].myElem.value ;  	// a node inner value, in xmlfile - "value" is a reserved keyword.
 * usage :
 * <br/> var xmp:XmlParser = new XmlParser();
 * <br/> xmp.onError = onLoadError;
 * <br/> xmp.onLoad = onLoad;
 * <br/> xmp.load("test.xml",null,false);
 * <br/> // with function onLoad (xml:Xml, xmp:XmlParser) {trace(xmp.parse(xmp.xml).toString());}
 * <br/> // OR 
 * <br/> xmp.onParse = onParse;
 * <br/> xmp.load("test.xml");
 * <br/> // with function onLoad (tree:Object, xmp:XmlParser) {trace(tree.toString());}
 * <br/> // OR 
 * <br/> xmp.load("test.xml",onParse);
 * <br/> // OR
 * <br/> xmp.load("test.xml",onLoad,false);
 * <br/> // OR 
 * <br/> new XmlParser().load("test.xml",onLoad,false);
 * <br/> // OR
 * <br/> new XmlParser().load("test.xml",onParse);
 * <br/> // OR 
 * <br/> // the best and simplest :     XmlParser.get("test.xml",onParse,onLoadError); 
 * <br/> // 					 or xmp=XmlParser.get("test.xml",onParse);
 * <br/> 
 */

class XmlParser extends ApiCommon   { 
	var autoParse:Bool; 
	public var tree (default,null):Object;
	public var xml (default,null):Xml;
	/**
	* constructor
	*/
	public function new () { }
	/**
	* create new, load, parse and assign done listener to onParse() at once.
	* <br/>
	* <br/><b>url</b> file url or pathname
	* <br/><b>onDone</b> on parse -done- listener .
	* <br/><b>onError</b> on error listener.
	* <br/><b>return</b> created XmlParser.
	*/
	public static function get(url:String, onDone:Object->XmlParser->Void, ?onError: String->Void ):XmlParser {
		var xmp = new XmlParser();
		if (onError!=null) xmp.onError = onError;
		return xmp.load(url,onDone);
	}	
	/**
	* may be implemented by caller
	* <br/><b>xml</b> Xml instance
	* <br/><b>xmp</b> This instance
	*/
	public dynamic function onLoad(xml:Xml,xmp:XmlParser) {}
	/**
	* may be implemented by caller
	* <br/><b>tree</b>tree object
	* <br/><b>xmp</b> This instance
	*/
	public dynamic function onParse(tree:Object,xmp:XmlParser) {}
	/**
	* may be implemented by caller
	* <br/><b>msg</b> error message
	*/
	public dynamic function onError( msg : String ) { }		
	/**
	* load xml file.
	* <br/>
	* <br/><b>url</b> file url or pathname
	* <br/><b>onDone</b> onParse or onLoad function depending of autoParse -default is onParse
	* <br/><b>autoParse</b> false if load only 
	* <br/><b>xreturn</b> this instance
	*/
	public function load (url:String,?onDone:Dynamic,?autoParse:Bool=true):XmlParser {
		this.autoParse = autoParse;
		if (onDone != null) {
			if (autoParse) onParse = onDone; 
			else onLoad = onDone ;
		}
		var r:Http = new Http(url);
		r.onError = onLoadError ;
		r.onData = onLoadData;
		r.request(false);
		return this;
	}
	/**
	* parse an Xml instance
	* <br/>
	* <br/><b>x</b> Xml instance
	* <br/><b>return</b> root tree structure.
	*/
	public function parse (x:Xml) :Object {
		x = x.firstElement();
		tree = new Object();
		parseNode(x, tree);		
		return tree ;
	}
	/**
	 * private 
	 */
	function onLoadData( result: String ) {
		try {
			Xml.parse(result);
		} catch( e:Dynamic ) {
			trace("f:: xml content isn't valid " );
		}	
		xml = Xml.parse(result);	
		if (autoParse) onParse( parse(xml), this); 
		onLoad(xml,this);
	}
	function onLoadError( msg : String ) {
		onError(msg);
		trace("f:: xml file doesn't exists => " + msg) ;
	}
	function parseNode( xml:Xml, ?o:Object ) {
		if (xml.firstChild() != null) {
			if (xml.firstChild().nodeType == Xml.PCData) { 
				var v = StringTools.trim(xml.firstChild().nodeValue) ;
				if (!empty(v)) {
					o.set("value", v);
				}
			}
		}		
		//if (xml.nodeType==Xml.Element) { // if bug
			for (i in xml.attributes()) {			
				o.set(i, xml.get(i));
			}
		//}
		var oo:Object;		
		for (i in xml.elements()) {
			if (o.get(i.nodeName) != null) {
				if (!(Std.is(o.get(i.nodeName), Array))) {
					oo = o.get(i.nodeName);
					o.set(i.nodeName, new Array() );
					o.get(i.nodeName).push(oo);
				} 
				oo = new Object();
				o.get(i.nodeName).push(oo);
				parseNode(i,oo);				
			}
			else {
				o.set(i.nodeName, new Object());
				parseNode(i,o.get(i.nodeName));
			}			
		}		
	}
}

