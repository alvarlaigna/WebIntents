RELEASE := $(shell cat ./src/release.js)
DEBUG := $(shell cat ./src/debug.js)

all: webintents.js webintents.min.js server/cache.manifest webintents.debug.js examples tools

examples: examples/lib/webintents.js examples/lib/webintents.debug.js examples/lib/webintents.min.js

tools: tools/chrome/extensions/share/webintents.js

examples/lib/webintents.js: webintents.js
	ln -f webintents.js examples/lib/webintents.js

examples/lib/webintents.debug.js: webintents.debug.js
	ln -f webintents.debug.js examples/lib/webintents.debug.js

examples/lib/webintents.min.js: webintents.min.js
	ln -f webintents.min.js examples/lib/webintents.min.js

webintents.js: ./src/release.js ./src/webintents.js ./src/json2.js ./src/base64.js
	cat ./src/webintents.js ./src/json2.js ./src/base64.js | sed 's|// __WEBINTENTS_ROOT|$(RELEASE)|' > webintents.js

webintents.debug.js: ./src/webintents.js ./src/debug.js ./src/json2.js ./src/base64.js
	cat ./src/webintents.js ./src/json2.js ./src/base64.js | sed 's|// __WEBINTENTS_ROOT|$(DEBUG)|' > webintents.debug.js

webintents.min.js: webintents.js 
	uglifyJs $^ > $@

tools/chrome/extensions/share/webintents.js: webintents.js
	ln -f webintents.js tools/chrome/extensions/share/webintents.js

# Manifest depends on changes to other files, so include them in the dependency chain
server/cache.manifest: server/cache.manifest.src server/picker.html server/script/picker.js server/webintents.js server/intents.html server/script/json2.js server/script/webintents-server.js server/webintents.min.js server/webintents.debug.js server/script/controller.js server/script/base64.js
	cat server/cache.manifest.src >> server/cache.manifest
	echo '#' `date` >> server/cache.manifest

server/webintents.js:  webintents.js
	ln -f webintents.js server/webintents.js

server/webintents.debug.js:  webintents.debug.js
	ln -f webintents.debug.js server/webintents.debug.js

server/webintents.min.js:  webintents.min.js
	ln -f webintents.min.js server/webintents.min.js

clean: webintents.js webintents.min.js webintents.debug.js server/cache.manifest examples/lib/webintents.debug.js examples/lib/webintents.min.js examples/lib/webintents.js server/webintents.js server/webintents.min.js server/webintents.debug.js
	rm $^
