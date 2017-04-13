# List of files to compile.
SOURCES = $(wildcard src/*.cpp)
DEPS = $(wildcard src/*.h)
OBJECTS = $(patsubst src/%.cpp, obj/%.o, $(SOURCES))
OBJECTDEPS = $(patsubst src/%.h, obj/%.o, $(DEPS))
TARGETS = bin/ParticleSwarm bin/CellTest

CC = g++
FLAGS = -Wall -std=c++11 -pthread

# 'make' or 'make all' compiles everything
all: $(TARGETS)

# 'make <file>' compiles and links just one file
$(TARGETS): bin/%: obj/%.o $(OBJECTS)
	$(CC) $(FLAGS) $(OBJECTDEPS) $< -o $@

# 'make <name>.o' just compiles and assembles one file, but does not link
$(OBJECTS): obj/%.o: src/%.cpp $(DEPS)
	$(CC) $(FLAGS) -c $< -o $@

# 'make clean' deletes everything that has been compiled
clean:
	-rm -f obj/*.o bin/*
