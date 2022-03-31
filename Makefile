CC=gcc
VERSION=0.0.2
PKG_CONFIG ?= $(shell which pkg-config)

PG_CONFIG := $(shell which pg_config)
PG_INCLUDEDIR := $(shell $(PG_CONFIG) --includedir-server)
PG_PKGLIBDIR := $(shell $(PG_CONFIG) --pkglibdir)
PG_EXTDIR := $(shell $(PG_CONFIG) --sharedir)/extension

MAX_CACHE_SIZE ?= 64

GUILE_INCLUDEDIR ?= $(shell $(PKG_CONFIG) --cflags guile-3.0)
GUILE_LDFLAGS ?= $(shell $(PKG_CONFIG) --libs guile-3.0)

MODULE_DIR ?= $(PG_PKGLIBDIR)

CPPFLAGS += -g -Wall -fPIC -c -I$(PG_INCLUDEDIR) $(GUILE_INCLUDEDIR)
CPPFLAGS += -DMODULE_DIR=\"$(MODULE_DIR)\"
CPPFLAGS += -DMAX_CACHE_SIZE=$(MAX_CACHE_SIZE)

LDFLAGS += -shared $(GUILE_LDFLAGS)
LDFLAGS += -L/usr/local/lib

U=u
ifneq ("$(SAFE_R5RS)", "")
	U=
	CPPFLAGS += -DSAFE_R5RS
endif

SRCS := plscheme.c
OBJS := plscheme$(U).o
SO := plscheme$(U).so

plscheme:
	$(CC) $(CPPFLAGS) -o $(OBJS) $(SRCS) 
	$(CC) $(OBJS) $(LDFLAGS) -o $(SO)

install:
	cp init.scm $(MODULE_DIR)
	cp dataconv.scm $(MODULE_DIR)
	cp plscheme$(U).control $(PG_EXTDIR)
	cp plscheme$(U)--$(VERSION).sql $(PG_EXTDIR)

.PHONY: init
init:
	docker-compose up -d plscheme

.PHONY: tests
tests:
	docker-compose run --rm pgtap

.PHONY: destroy
destroy:
	docker-compose stop
	docker-compose rm -f