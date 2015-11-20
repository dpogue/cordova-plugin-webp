ca.dpogue.webp
==============

Cordova Plugin to automatically add WebP support for iOS web views. Works for
images referenced in HTML, CSS, or JS, including ones packaged with the app and
loaded from the device filesystem.


Installing
----------

With the Cordova command-line tools:

```
cordova plugin add cordova-plugin-webp
```

Version History
---------------

* **v1.2.0** - Updated to WebP 0.4.4
* **v1.1.0** - Updated to WebP 0.4.3, published to npm
* **v1.0.1** - Updated WebP.framework to support arm64
* **v1.0.0** - Initial version, based on libwebp 0.4.2


Acknowledgements
----------------

This is largely a repackaging of work by Scott Talbot. You can find his
original code at https://github.com/cysp/STWebPDecoder

The WebP.framework bundle was generated from ``libwebp/iosbuild.sh``

```bash
$ git submodule update --init
$ cd libwebp
$ ./iosbuild.sh
$ rm -rf ../src/ios/WebP.framework
$ cp -r ./WebP.framework ../src/ios/
```

Licence
-------

Licensed under the Mozilla Public License Version 2.0.
