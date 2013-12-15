#FL.net api 

Basic Haxe-js api.  

Dependency for FL- projects. 

- Example : [FL-Calendar](https://github.com/flashline/FL-Calendar)



##Features: 

- Extends js.html.Element & Array (with "using" keyword). 
- manages custom events this way :  myInstance.eventSourceType.addEventListener(myListener,[parameters to myListener]) ;
- parse Xml to create a tree of objects, arrays, values : object.object2.array[n].element.array2[m].element2.value (json like).
- etc...

##To be installed :   

- as haxe lib  
- or everywhere, adding in build.xml:  -cp everywhere/

NB:  
This repo include [feffects](https://github.com/skial/feffects) a tweens api by filt3r@free.fr.

##Licence 
GNU-GPL