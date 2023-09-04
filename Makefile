
build:
	gcc -std=c99 -Wall ./src/*.c ./lib/lua/src/*.c -DLUA_USE_LINUX -DLUA_USE_READLINE -lm -o main

clean:
	rm ./main

run:
	./main
