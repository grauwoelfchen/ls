.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W $<

MODS = ls

all: compile

compile: ${MODS:%=%.beam}

clean:
	rm -rf *.beam erl_crash.dump
