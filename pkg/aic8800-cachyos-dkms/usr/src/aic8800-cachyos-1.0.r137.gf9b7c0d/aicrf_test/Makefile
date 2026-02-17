# AIC8800 RF Test Tools Makefile
CC := $(CROSS_COMPILE)gcc
LDFLAGS := -lpthread

# Executables to build
TARGETS := wifi_test bt_test

all: $(TARGETS)

wifi_test: wifi_test.o
	$(CC) $+ -o $@

bt_test: bt_test.o
	$(CC) $+ $(LDFLAGS) -o $@

%.o: %.c
	$(CC) -c $< -o $@

clean:
	rm -f *.o $(TARGETS)

install:
	install -d /usr/local/bin
	install -m 755 wifi_test /usr/local/bin/
	install -m 755 bt_test /usr/local/bin/

uninstall:
	rm -f /usr/local/bin/wifi_test
	rm -f /usr/local/bin/bt_test
