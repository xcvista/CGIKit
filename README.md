# CGIKit X

**CGIKit Web Developemnt Kit**. The FastCGI Web Application Framework for
Objective-C and Swift developers.

## Components of CGIKit

The CGIKit X comes in two major components: CGIKit framework that covers the
FastCGI and HTTP protocol, and WebUIKit that covers the Web application and
presentation layers. Also included is an example application CGIHello.

Proceed to README file of each component to find out details of each component.

## Swift Support

CGIKit is written entirely in Objective-C, with Swift-friendly annotations that
makes it compatible, as two pre-built framework modules, with Swift code.

## Building the Project

CGIKit X currently requires Xcode 7 to build (due to the heavy Swift annotations
which is only supported under OS X El Capitan SDK) and also runs best on OS X El
Capitan. After the project being built the resulting libraries should be useable
under OS X Yosemite too.

## Demo

The CGIKit project file also includes two demo apps: CGIHello and SwiftHello,
written in Objective-C and Swift. Both demo apps listen on [::]:9000 for
incoming FastCGI requests. You can use nginx as a test server for this, although
building nginx on OS X can be a bit brutal.

After launching both the demo app and nginx, you should be able to visit a few
links and see results:

* <http://localhost/>: redirects to <http://localhost/index.wib>
* <http://localhost/info.wib>: a brief page describing the received request.
* <http://localhost/error.wib>: a demo page of non-critical error page.
* <http://localhost/exception.wib>: request processing is intentionally crashed.

## License

CGIKit 9, on its own, is covered in [the three-clause BSD license](LICENSE.md).

CGIKit framework depend on FastCGI C Library by Open Market. I have included a
preconfigured, stripped down and slightly modified version in its source form as
part of the library code. Those are covered in the original license of [FastCGI
C Library](https://github.com/xcvista/libfastcgi/blob/master/LICENSE.md)

WebUIKit used Bootstrap, jQuery and Ractive.js for its presentation layers to
work by generating HTML pages that depend on those libraries (but not using them
directly,) hence a copy of each is included as resources of the framework. Those
file are covered under their respective licenses (which happened to all be [the
MIT license](http://opensource.org/licenses/MIT).)

Bootstrap is a work of Twitter Inc. jQuery is a work of jQuery Team. Ractive.js
is a work of Ractive.js team, originally part of The Guardian.

## Contact information

DreamCity by Max Chan

* Email: &lt;<max@maxchan.info>&gt;
* Website: <https://en.maxchan.info>
* Twitter: [@maxtch](https://twitter.com/maxtch)