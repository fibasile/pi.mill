pi.mill
=======

Pi.Mill is a web-based interface for controlling the Roland MDX machines family.

It's based on the [FabModules](http://kokompe.cba.mit.edu), the Bottle framework (http://bottlepy.org), and the 
[Tornado](http://www.tornadoweb.org/) web server for SockJS support.

It is meant to run on any linux-compatible system, but was especially made to run on low-power boards such as 
the Raspberry-PI. This way you can use your computers for other stuff and have a cheap controller for the MDX, 
while allowing anyone to mill on it.


Install instructions
--------------------

On the Raspbian distribution you need the following pre-requisites

sudo apt-get install build-essentials python python-dev \ 
libgif-dev libpng12-dev libboost-dev libboost-thread-dev bc imagemagick

Then you need to install the FabModules following the instructions on the [website](http://kokompe.cba.mit.edu)

Once you have FabModules installed you should clone this repository, and install requirements either using sudo,
for global install or using something like virtualenv without sudo

pip install -r requirements.txt

Now you are ready to launch pi.mill using the provided run.sh script

./run.sh

Demo
-----

Check out this demo of Pi.Mill 

<iframe width="480" height="360" src="//www.youtube.com/embed/Hj5fJSAUEkM" frameborder="0" allowfullscreen></iframe>


License
--------

The MIT License (MIT)

Copyright (c) 2014 Fiore Basile

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


