example.java.helloworld (with signing of the jar file using a make file)
=======================

This is "Hello World" Example for Java.

The structure ``HelloWorld`` package is like this: ::

  example.java.helloworld/
  |-- HelloWorld
  |   `-- Main.java
  |-- LICENSE
  |-- Manifest.txt
  `-- README.md

Compile class
-------------

For compile the main class for package, execute the follow command: ::

  javac HelloWorld/Main.java

This generate the ``Main.class`` file into ``HelloWorld`` directory.

Run class
---------

For run the main class for package, execute the follow command: ::

  java -cp . HelloWorld.Main

This show the ``Hello world`` message.

Create a JAR file
-----------------

For pack the main class for package as a JAR file, execute the follow command: ::

  jar cfme Main.jar Manifest.txt HelloWorld.Main HelloWorld/Main.class


Run a JAR file
--------------

For run the JAR file packed, execute the follow command: ::

  java -jar Main.jar

This show the ``Hello world`` message.

Signing of jar
--------------
To sign the jar you need to create a keystore, you acn do this with next command: ::

	 keytool -genkeypair \
		 -alias signFiles \
     -validity 300 \
		 -keystore keystore.jks

To export the public certificate use: ::

	 keytool -export -keystore keystore.jks -alias signFiles -file public.cer

For the actual signing of the jar file: ::

	 jarsigner -signedjar \
		 signed-HelloWorld.jar HelloWorld.jar signFiles \
		 -tsa http://sha256timestamp.ws.symantec.com/sha256/timestamp \
		 -keystore keystore.jks

In order to verify the jar is correctly signed: ::

	 jarsigner -verify signed-HelloWorld.jar -keystore tmp-keystore.jks

If someone else wants to verify he should first import you public certificate: ::

   keytool -importcert \
   	 -file public.cer \
   	 -storepass tmptmp \
   	 -noprompt \
   	 -keystore tmp-keystore.jks

Automation
----------
All these steps have also been automated for you in a (Makefile)[./makefile].

You can simply run `make` in the directory to:

- compile the Main.java class
- bundle it into a jar
- create a keystore and prompt for password and info
- sign the jar
- export the public certificate

Other useful commands are `clean` to remove all generated files,
and `verify` to create a new keystore, import the public certificate and
verify the signed jar using that new keystore.

Reference
=========

- `java - How to run a JAR file - Stack Overflow <http://stackoverflow.com/questions/1238145/how-to-run-a-jar-file>`_.
- `Setting an Application's Entry Point (The Java™ Tutorials > Deployment > Packaging Programs in JAR Files) <http://docs.oracle.com/javase/tutorial/deployment/jar/appman.html>`_.
- hello world project: https://github.com/macagua/example.java.helloworld
- Gist used as reference for makefile: https://gist.github.com/isaacs/62a2d1825d04437c6f08
- using java keytool: https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html
- how to fix the timestamp error: https://stackoverflow.com/questions/21695520/tsa-or-tsacert-timestamp-for-applet-jar-self-signed
