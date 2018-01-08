all: signed-HelloWorld.jar public.cer

HelloWorld/Main.class: HelloWorld/Main.java
	# 1 - compile
	javac HelloWorld/Main.java

HelloWorld.jar: Manifest.txt HelloWorld/Main.class
	# 2 - bundle into jar
	jar cfme HelloWorld.jar Manifest.txt HelloWorld.Main HelloWorld/Main.class

keystore.jks:
	# 3 - create a keystore
	keytool -genkeypair \
		-alias signFiles \
		-validity 300 \
		-keystore keystore.jks

signed-HelloWorld.jar: HelloWorld.jar keystore.jks
	# 4 - sign the jar
	jarsigner -signedjar \
		signed-HelloWorld.jar HelloWorld.jar signFiles \
		-tsa http://sha256timestamp.ws.symantec.com/sha256/timestamp \
		-keystore keystore.jks

public.cer: keystore.jks
	# 5 - export the public certificate
	keytool -export -keystore keystore.jks -alias signFiles -file public.cer

# commands to clean, and check results (run the jar and verify etc)
clean:
	rm *.jar
	rm HelloWorld/*.class
	rm *.jks
	rm *.cer

run-class:
	java -cp . HelloWorld.Main
run-jar:
	java -jar HelloWorld.jar
verify: all
	# remove tmp keystore if one already exists
	- rm tmp-keystore.jks
	# create a new keystore
	keytool -genkeypair \
		-dname "cn=Unknown, ou=Unknown, o=Unknown, c=BE" \
		-alias tmp \
		-keypass tmptmp \
		-storepass tmptmp \
		-validity 180 \
		-keystore tmp-keystore.jks
	# import public certificate
	keytool -importcert \
		-file public.cer \
		-storepass tmptmp \
		-noprompt \
		-keystore tmp-keystore.jks
	# verify the signed jar file
	jarsigner -verify signed-HelloWorld.jar \
		-keystore tmp-keystore.jks

